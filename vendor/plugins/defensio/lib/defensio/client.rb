require 'net/http'
require 'yaml'

module Defensio
  module StubResponses
    class Response
      def success?
        true
      end
    end
  end

  class Error < RuntimeError; end
  class InvalidAPIKey < Error; end
  
  class Response
    attr_reader :raw
    
    def initialize(response_body)
      @raw = response_body
      @parameters = YAML.load(response_body)['defensio-result'] || {}
    end
    
    def [](parameter)
      @parameters[parameter.to_s.tr('_', '-')]
    end
    
    # Indicates whether the action could be processed
    def success?
      self[:status] == 'success'
    end
    
    def self.response_attr_reader(*attrs)
      attrs.each do |attr|
        define_method attr do
          self[attr]
        end
      end
    end

    # a message provided by the action if applicable
    response_attr_reader :message
    
    # the version of the API used to process the request
    response_attr_reader :api_version
  end
  
  class AuditCommentResponse < Response
    # a message signature that uniquely identifies the comment in the Defensio
    # system. this signature should be stored by the client for retraining purposes
    response_attr_reader :signature
    
    # A boolean value indicating whether Defensio believe the comment to be spam
    response_attr_reader :spam
    
    # A value indicating the relative likelihood of the comment being spam.
    # this value should be stored by the client for use in building convenient
    # spam sorting user-interfaces
    response_attr_reader :spaminess
  end
  
  class StatsResponse < Response
    # Describes the percentage of comments correctly identified as spam/ham
    # by Defensio on this blog
    response_attr_reader :accuracy
    
    # the number of spam comments caught by the filter
    response_attr_reader :spam
    
    # the number of ham (legitimate) comments accepted by the filter
    response_attr_reader :ham
    
    # the number of times a legitimate message was retrained from the spambox
    # (i.e. "de-spammed" by the user)	
    response_attr_reader :false_positives
    
    # the number of times a spam message was retrained from comments box
    # (i.e. "de-legitimized" by the user)
    response_attr_reader :false_negatives
  end
  
  class Client
    attr_accessor :api_key, :owner_url, :version
    
    # Create a new Defensio service wrapper.
    #
    # Required options:
    #     api_key: Your api key supplied by the Defensio dudes
    #   owner_url: Your site URL
    #
    # Optional options:
    #     version: The version of the Defensio API you wanna use (default: 1.1)
    def initialize(options)
      @mode      = options.delete(:mode)      || 'production' 
      unless test?
        @api_key   = options.delete(:api_key)   || raise(InvalidAPIKey, 'api_key required')
        @owner_url = options.delete(:owner_url) || raise(Error, 'owner_url required')
        @version   = options.delete(:version)   || '1.1'
      end

      @default_params = { :owner_url => @owner_url }
    end
    
    # This action verifies that the key is valid for the owner calling the service.
    def validate_key
      call :validate_key, Response
    end
    
    # This action should be invoked upon the publication of an article to announce
    # its existence. The actual content of the article is sent to Defensio for analysis.
    #
    #   Parameter             Description                             Possible Values
    #   =============================================================================
    #   article_author        the name of the author of the article   any string
    #   article_author_email  the email address of the person posting valid email
    #                         the article
    #   article_title         the title of the article                string
    #   article_content       the content of the blog posting itself  text
    #   permalink             the permalink of the article just       valid URL
    #                         posted
    def announce_article(params)
      call :announce_article, Response, params
    end
    
    # This central action determines not only whether Defensio thinks a comment is spam
    # or not, but also a measure of its "spaminess", i.e. its relative likelihood of being
    # spam.
    # 
    # It should be noted that one of Defensio's key features is its ability to rank spam
    # according to how "spammy" it appears to be. In order to make the most of the Defensio
    # system in their applications, developers should take advantage of the spaminess value
    # returned by this function, to build interfaces that make it easy for the user to
    # quickly sort through and manage their spamboxes
    #
    #   Parameter             Description                             Possible Values
    #   =============================================================================
    #   user_ip               the IP address of whomever is posting   xxx.xxx.xxx.xxx
    #                         the comment
    #   article_date          the date the original blog article      yyyy/mm/dd
    #                         was posted
    #   comment_author        the name of the author of the comment	  any string
    #   comment_type          the type of the comment being posted    comment, trackback,
    #                         to the blog                             pingback, other
    #
    # Optional parameters:
    #   Parameter             Description                             Possible Values
    #   =============================================================================
    #   comment_content       the actual content of the comment       text
    #   comment_author_email  the email address of the person         email address
    #                         posting the comment
    #   comment_author_url    the URL of the person posting the       valid URL
    #                         comment
    #   permalink             the permalink of the blog post to which valid URL
    #                         the comment is being posted
    #   referrer              the URL of the site that brought        valid URL
    #                         commenter to this page
    #   user_logged_in        whether or not the user posting the     true or false
    #                         comment is logged-into the blogging
    #                         platform
    #   trusted_user          whether or not the user is an           true or false
    #                         administrator, moderator or editor of
    #                         this blog; the client should pass true
    #                         only if blogging platform can guarantee
    #                         that the user has been authenticated and
    #                         has a role of responsibility on this
    #                         blog
    #   test_force            FOR TESTING PURPOSES ONLY:              "spam,x.xxxx"
    #                         use this parameter to force the outcome "ham,x.xxxx"
    #                         of audit-comment . optionally affix
    #                         (with a comma) a desired spaminess
    #                         return value (in the range 0 to 1).
    #
    # Returned response object will contain: signature, spam and spaminess
    def audit_comment(params)
      call :audit_comment, AuditCommentResponse, params
    end
    
    # This action is used to retrain false negatives. That is to say, to indicate to
    # the filter that comments originally tagged as "ham" (i.e. legitimate) were in
    # fact spam.
    # 
    # Retraining the filter in this manner contributes to a personalized learning
    # effect on the filtering algorithm that will improve accuracy for each user over time.
    #
    #   Parameter             Description                             Possible Values
    #   =============================================================================
    #   signatures            list of signatures (may contain a       comma-separated
    #                         single entry) of the comments to be     list of alphanumeric
    #                         submitted for retraining. note that a   strings
    #                         signature for each comment was
    #                         originally provided by Defensio's
    #                         audit-comment action.
    def report_false_negatives(params)
      call :report_false_negatives, Response, params
    end
    
    # This action is used to retrain false positives. That is to say, to indicate to
    # the filter that comments originally tagged as spam were in fact "ham" (i.e.
    # legitimate comments).
    # 
    # Retraining the filter in this manner contributes to a personalized learning 
    # effect on the filtering algorithm that will improve accuracy for each user
    # over time.
    #
    # Same parameters as report_false_negatives
    def report_false_positives(params)
      call :report_false_positives, Response, params
    end
    
    # This action returns basic statistics regarding the performance of Defensio
    # since activation.
    def get_stats
      call :get_stats, StatsResponse
    end
    
    protected
      def convert_name(name)
        name.to_s.tr('_', '-')
      end
    
      def convert_params(params)
        params.inject({}) do |hash, (param, value)|
          hash[convert_name(param)] = value
          hash
        end
      end
    
      def call(action, response_class, params={})
        RAILS_DEFAULT_LOGGER.debug "[DEFENSIO] #{action} #{params.inspect}"
        if test?
          Defensio::StubResponses.const_get(response_class.to_s.split('::').last).new
        else  
          response_class.new post(convert_name(action), convert_params(@default_params.merge(params)))
        end
      end
    
      def post(action, params={})
        raise("Unstubbed method called in test mode") if test?
        Net::HTTP.post_form(URI.parse("http://api.defensio.com/app/#{@version}/#{action}/#{@api_key}.yaml"), params).body
      end

      def test?
        @mode == 'test'
      end
  end
end

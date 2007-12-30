module Defensio
  mattr_accessor :config_file
  self.config_file = RAILS_ROOT + '/config/defensio.yml'
  
  module ActsAs
    module ClassMethods
      # Add Defensio magic for managing a comment or something that
      # can be marked as Spam or Ham.
      # By default those following fields are maped to the column of the
      # same name, if the column exists: 
      # <tt>
      #   author, content, title, author_email, author_url,
      #   user_logged_in, trusted_user, article.permalink
      # </tt>
      # See +acts_as_defensio+ for more details.
      def acts_as_defensio_comment(options={})
        acts_as_defensio :comment, options
      end
      
      # Add Defensio magic for managing an article or something that
      # can be commented (spamed) about.
      # By default those following fields are maped to the column of the
      # same name, if the column exists: 
      # <tt>
      #   author, author_email, title, content, permalink
      # </tt>
      # By default the article will be published after creation. You can
      # override this behaviour with the :announce_when option. Specified
      # a method returning if the article needs to be announced to the
      # Defensio server. If you're using the :announce_when option, you'll
      # also need to create an announced column as this will be set to
      # +true+ when the article is published.
      # See +acts_as_defensio+ for more details.
      def acts_as_defensio_article(options={})
        acts_as_defensio :article, options
      end
      
      # Add Defensio magic to an ActiveRecord class.
      # 
      # Options are the same as +Defensio::Client#new+ plus the <tt>:fields</tt>
      # option that allows to customize the fields that will be sent to
      # Defensio to help the classification of a comment.
      # For example if the content of a comment is stored in the comment
      # column set the <tt>:fields</tt> option to <tt>{ :content => :comment }</tt>.
      # Try to map as much column as possible as this helps Defensio to
      # classify one comment effectively.
      #
      # You can also set the type of comment with the :comment_type option.
      # 
      # Usage:
      # <tt>
      #   acts_as_defensio_comment :owner_url => 'http://code.macournoyer.com/svn/plugins/defensio',
      #                            :fields => { :content => :comment }
      # </tt>
      #
      # You must specify the <tt>:api_key</tt> and <tt>:owner_url</tt> option.
      # Other options are optional.
      # All options can be specified in a YAML config file by default in
      # RAILS_ROOT/config/defensio.yml.
      def acts_as_defensio(type, options={})
        include InstanceMethods
        
        case type
        when :article
          if options.has_key? :announce_when
            after_save :announce_article
          else
            after_create :announce_article!
          end
        when :comment
          after_create :audit_comment
        end
        
        @defensio_type = type
        self.defensio_options = options
        @defensio = Defensio::Client.new(@defensio_options)
        
        unless defensio_options.has_key?(:validate_key) && !defensio_options[:validate_key]
          raise Defensio::InvalidAPIKey unless @defensio.validate_key.success?
        end
      end
      
      def defensio
        @defensio
      end
      
      def defensio_options=(options)
        @defensio_options = {}
        @defensio_options.merge! File.open(Defensio.config_file) { |file| YAML.load(file) }[ENV['RAILS_ENV']] if File.exists?(Defensio.config_file)
        @defensio_options.merge! options
        @defensio_options.symbolize_keys!
      end
      
      def defensio_options
        @defensio_options
      end
      
      def defensio_type
        @defensio_type
      end
      
      def defensio_fields(field)
        (@defensio_options[:fields] || {})[field] || field
      end
      
      def comment_type
        @defensio_options[:comment_type] || 'comment'
      end
      
      def defensio_stats
        @defensio.get_stats
      end
    end
    
    module InstanceMethods
      def self.included(base)
        base.class_eval do
          alias_method :report_as_spam, :report_as_false_negative
          alias_method :report_as_ham, :report_as_false_positive
        end
      end
      
      def audit_comment
        raise Defensio::Error,
              "You have to pass the current request environement:\n\t@comment.env = request.env" unless @env
        
        article_field = self.class.defensio_fields(:article)
        raise Defensio::Error,
              "You must specify an assiociated object which acts_as_defensio_article" unless respond_to? article_field
        article = send article_field
        
        fields = { :user_ip      => @env['REMOTE_ADDR'],
                   :referrer     => @env['HTTP_REFERER'],
                   :article_date => convert_to_defensio_date(article.created_at),
                   :comment_type => self.class.comment_type }
        
        fields.merge! extract_optional_fields_value(self, :author, :content, :title, :author_email, :author_url, :prefix => 'comment_')
        fields.merge! extract_optional_fields_value(self, :user_logged_in, :trusted_user)
        fields.merge! extract_optional_fields_value(article, :permalink)

        response = nil
        log_and_ignore_error do
          response = self.class.defensio.audit_comment fields
        end
        
        if response
          raise Defensio::Error, response.message unless response.success?
          self.signature = response.signature
          self.spam      = response.spam
          self.spaminess = response.spaminess
          save(false)
        end
      end
      
      def announce_article
        announce_when = self.class.defensio_options[:announce_when]
        announced_field = self.class.defensio_fields(:announced)
        
        raise Defensio::Error, "announced field not found" unless respond_to? announced_field
        
        return unless send(announce_when) && !send(announced_field)
        
        announce_article!
        
        self.announced = true
        save(false)
      end
      
      def announce_article!
        fields = {}
        
        fields.merge! extract_optional_fields_value(self, :author, :author_email, :title, :content, :prefix => 'article_')
        fields.merge! extract_optional_fields_value(self, :permalink)
        
        response = nil
        log_and_ignore_error do
          response = self.class.defensio.announce_article fields
        end
        
        if response
          raise Defensio::Error, response.message unless response.success?
        end
      end
      
      def env=(env)
        @env = env
      end
      
      def report_as_false_negative
        log_and_ignore_error do
          self.class.defensio.report_false_negatives :signatures => self.signature
        end
        self.spam      = true
        self.spaminess = 1.0
        save(false)
      end
      
      def report_as_false_positive
        log_and_ignore_error do
          self.class.defensio.report_false_positives :signatures => self.signature
        end
        self.spam      = false
        self.spaminess = 0.0
        save(false)
      end
      
      private
        def convert_to_defensio_date(date)
          [date.strftime('%Y'), date.month, date.day] * '/'
        end
        
        def extract_optional_fields_value(object, *fields)
          options = fields.last.is_a?(Hash) ? fields.pop : {}
          prefix = options.delete(:prefix)
          
          fields.inject({}) do |hash, field|
            field_name = object.class.defensio_fields(field)
            hash[:"#{prefix}#{field}"] = object.send(field_name) if object.respond_to? field_name
            hash
          end
        end
        
        def log_and_ignore_error
          tries = 0
          begin
            tries += 1
            yield
          rescue Exception => e
            if tries < 3
              retry
            else
              RAILS_DEFAULT_LOGGER.error "[DEFENSIO] Could not contact server : #{e}"
            end
          end
        end
    end
  end
end

ActiveRecord::Base.extend Defensio::ActsAs::ClassMethods
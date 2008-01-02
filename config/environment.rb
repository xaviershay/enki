# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_better_log_session',
    :secret      => 'd9b13a4ed2cfce88d62a6765b99530fd5a984ac827aa9068bf893aff51233f486c5f57f83d537945fb89caf2cd8bd3f42a5c3bfc5adce818afe28fca0452b52b'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
end

require 'lesstile'
require 'coderay'
require 'core_extensions/string'
require 'core_extensions/object'
$:.unshift("vendor/ruby-openid-2.0.2/lib")
require 'openid'
require 'openid/store/filesystem'
require 'openid/extensions/sreg'

class OpenID::AuthenticationFailure < OpenID::OpenIDError
  attr_accessor :response

  def initialize(response)
    @response = response
  end

  def identity_url
    @response.identity_url
  end
end

# http://dev.rubyonrails.org/ticket/10672
module ActionView::Helpers::AtomFeedHelper
  def atom_feed(options = {}, &block)
    if options[:schema_date].blank?
      logger.warn("You must provide the :schema_date option to atom_feed for your feed to be valid. A good default is the year you first created this feed.")
    else
      options[:schema_date] = options[:schema_date].strftime("%Y-%m-%d") if options[:schema_date].respond_to?(:strftime)
      options[:schema_date] = "," + options[:schema_date]
    end

    xml = options[:xml] || eval("xml", block.binding)
    xml.instruct!

    xml.feed "xml:lang" => options[:language] || "en-US", "xmlns" => 'http://www.w3.org/2005/Atom' do
      xml.id("tag:#{request.host}#{options[:schema_date]}:#{request.request_uri.split(".")[0]}")      
      xml.link(:rel => 'alternate', :type => 'text/html', :href => options[:root_url] || (request.protocol + request.host_with_port))
        xml.link(:rel => 'self', :type => 'application/atom+xml', :href => options[:url] || request.url)

      yield AtomFeedBuilder.new(xml, self, options)
    end
  end
        
  class AtomFeedBuilder
    def initialize(xml, view, feed_options = {})
      @xml, @view, @feed_options = xml, view, feed_options
    end

    def entry(record, options = {})
      @xml.entry do 
        @xml.id("tag:#{@view.request.host}#{@feed_options[:schema_date]}:#{record.class}/#{record.id}")

        if options[:published] || (record.respond_to?(:created_at) && record.created_at)
          @xml.published((options[:published] || record.created_at).xmlschema)
        end

        if options[:updated] || (record.respond_to?(:updated_at) && record.updated_at)
          @xml.updated((options[:updated] || record.updated_at).xmlschema)
        end

        @xml.link(:rel => 'alternate', :type => 'text/html', :href => options[:url] || @view.polymorphic_url(record))

        yield @xml
      end
    end

    private

    def method_missing(method, *arguments, &block)
      @xml.__send__(method, *arguments, &block)
    end
  end
end

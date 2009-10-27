# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
Webrat.configure do |config|
  config.mode = :rails
  config.open_error_files = false
end
require 'cucumber/rails/world'

# Comment out the next line if you're not using RSpec's matchers (should / should_not) in your steps.
require 'cucumber/rails/rspec'

require File.expand_path(File.dirname(__FILE__) + '/factories')

#require 'rr'
#Cucumber::Rails::World.send(:include, RR::Adapters::RRMethods)

# Fix for Webrat for Rails 2.3 until Webrat gets patched
# http://webrat.lighthouseapp.com/projects/10503/tickets/161-urlencodedpairparser-removed-in-edge-rails
module Webrat
  class Field < Element #:nodoc:
    def to_param
      return nil if disabled?

      case Webrat.configuration.mode
      when :rails
        parse_rails_request_params("#{name}=#{escaped_value}")
      when :merb
        ::Merb::Parse.query("#{name}=#{escaped_value}")
      else
        { name => escaped_value }
      end
    end
    
    protected

    def parse_rails_request_params(params)
      if defined?(ActionController::AbstractRequest)
        ActionController::AbstractRequest.parse_query_parameters(params)
      elsif defined?(ActionController::UrlEncodedPairParser)
        # For Rails > 2.2
        ActionController::UrlEncodedPairParser.parse_query_parameters(params)
      else
        # For Rails > 2.3
        Rack::Utils.parse_nested_query(params)
      end
    end
  end
end

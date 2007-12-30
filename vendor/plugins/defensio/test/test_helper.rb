$:.unshift File.dirname(__FILE__) + "../lib"
require 'test/unit'
require 'rubygems'
require 'yaml'
require 'active_support'
require 'active_record'
require 'mocha'

RAILS_ROOT = ''
RAILS_DEFAULT_LOGGER = Logger.new(nil)
# RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
ENV['RAILS_ENV'] = 'test'

require 'defensio'

Defensio.config_file = File.dirname(__FILE__) + '/config.yml'
API_KEY = File.open(Defensio.config_file) { |file| YAML.load(file) }['test']['api_key']
OWNER_URL = 'http://code.macournoyer.com/svn/plugins/defensio'

# Allow using AR without a DB
class ActiveRecord::Base
  def transaction; yield end
  def update; true end
  def create
    # Hackish simulation of AR behaviour
    send :callback, :before_create
    self.new_record = false
    send :callback, :after_create
    true
  end
  
  def new_record=(new_record)
    @new_record = new_record
  end
    
  def self.column(name, sql_type)
    self.columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, nil, sql_type, false)
  end
  
  def self.columns
    @columns ||= []
  end
end

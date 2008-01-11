require 'hyper_open_id/controller_methods'
require 'hyper_open_id/authentication_failure'

ActionController::Base.send(:include, HyperOpenID::ControllerMethods)

# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

map Rails.configuration.action_controller.relative_url_root || "/" do
  run Enki::Application
end

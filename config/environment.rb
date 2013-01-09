# Load the rails application
require File.expand_path('../application', __FILE__)

ActionDispatch::ParamsParser::DEFAULT_PARSERS.delete(Mime::XML)
ActionDispatch::ParamsParser::DEFAULT_PARSERS.delete(Mime::YAML)

ActiveSupport::XmlMini::PARSING.delete("symbol")
ActiveSupport::XmlMini::PARSING.delete("yaml")

# Initialize the rails application
Enki::Application.initialize!

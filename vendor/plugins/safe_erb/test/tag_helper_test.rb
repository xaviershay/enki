require File.expand_path(File.dirname(__FILE__) + '/../../../../config/environment')
require 'test_help'

class TagHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::TagHelper

  def test_inclusion_in_taghelper
    assert self.respond_to?(:escape_once_with_untaint)
    assert self.respond_to?(:escape_once_without_untaint)
  end

  def test_taghelper_untaints
    evil_str = "evil knievel".taint
    assert !escape_once(evil_str).tainted?
    assert escape_once_without_untaint(evil_str).tainted?
  end
end

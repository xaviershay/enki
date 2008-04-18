require File.dirname(__FILE__) + '/test_helper'

class StatusTest < Test::Unit::TestCase
  include OpenIdAuthentication

  def test_state_conditional
    assert Result[:missing].missing?
    assert Result[:missing].unsuccessful?
    assert !Result[:missing].successful?

    assert Result[:successful].successful?
    assert !Result[:successful].unsuccessful?
  end

  def test_server_url
    assert_equal 'http://example.com', Result[:successful, 'http://example.com'].server_url
  end
end

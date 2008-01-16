# Test for facets/continuation.rb

require 'facets/continuation.rb'
require 'test/unit'

class TC_Continuation < Test::Unit::TestCase

  def test_Continuation_create
    assert_nothing_raised { c, r = Continuation.create }
  end

end


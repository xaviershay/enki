# Test for facets/kernel/callstack

require 'facets/kernel/callstack.rb'

require 'test/unit'

class TCKernel < Test::Unit::TestCase

  def test_call_stack
    assert_nothing_raised{ call_stack }
  end

  def test_called
    assert_equal( :test_called, called )
  end

  def test_method_name
    assert_equal( "test_method_name", callee.to_s )
  end

end

# Test for facets/binding/vars.rb

require 'facets/binding/vars.rb'

require 'test/unit'

class TestBindingVariables < Test::Unit::TestCase

  def setup
    a = 1
    b = 2
    x = "hello"
    # the line number must be updated if it moves
    @bind = binding; @this_line_no = __LINE__
    @this_file_name = File.basename( __FILE__ ) # why does it equal basename only?
  end

  def test_local_variables
    assert_equal( ["a","b","x"], @bind.local_variables )
  end

  def test_op_store
    assert_nothing_raised{ @bind["x"] = "goodbye" }
    assert_equal( "goodbye", @bind["x"] )
  end

  def test_op_fetch
    assert_equal( "hello", @bind["x"] )
  end

end

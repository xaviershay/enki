# Test for lib/facets/symbol/to_proc

require 'facets/symbol/to_proc.rb'
require 'test/unit'

class TestSymbolToProc < Test::Unit::TestCase

  def test_to_proc
    x = (1..10).inject(&:*)
    assert_equal(3628800, x)

    x = %w{foo bar qux}.map(&:reverse)
    assert_equal(%w{oof rab xuq}, x)

    x = [1, 2, nil, 3, nil].reject(&:nil?)
    assert_equal([1, 2, 3], x)

    x = %w{ruby and world}.sort_by(&:reverse)
    assert_equal(%w{world and ruby}, x)
  end

  def test_to_proc_call
    assert_instance_of(Proc, up = :upcase.to_proc )
    assert_equal( "HELLO", up.call("hello") )
  end

  def test_to_proc_map
    q = [[1,2,3], [4,5,6], [7,8,9]].map(&:reverse)
    a = [[3, 2, 1], [6, 5, 4], [9, 8, 7]]
    assert_equal( a, q )
  end

end



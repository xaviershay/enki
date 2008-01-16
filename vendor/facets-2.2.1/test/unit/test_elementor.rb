# Test facets/elementor.rb

require 'facets/elementor.rb'
require 'test/unit'

class TCElementor < Test::Unit::TestCase

  def test_to_elem
    e = [1,2,3].to_elem
    assert_equal( [4,5,6], e + 3 )
    assert_equal( [0,1,2], e - 1 )
  end

  def test_to_elem_str
    e = [1,2,3].to_elem
    assert_equal( ['1','2','3'], e.to_s )
  end

  def test_every
    a = [1,2,3]
    assert_equal( [4,5,6], a.every + 3 )
    assert_equal( [0,1,2], a.every - 1 )
    assert_equal( ['1','2','3'], a.every.to_s )
  end

  def test_every!
    a = [1,2,3]
    a.every! + 3
    assert_equal( [4,5,6], a )
  end

  def test_to_enum_every
    e = [1,2,3].to_enum(:map)
    w = e.every + 3
    assert_equal( [4,5,6], w )
  end

end

class TestElementWise < Test::Unit::TestCase

  def test_elementwise
    a = [1,2,3]
    b = [4,5]
    assert_equal( [4,5,6], a.elementwise + 3 )
    assert_equal( [5,7], a.elementwise + b )
    assert_equal( [[5,7],[3,4,5]], a.elementwise.+(b,2) )
    assert_equal( [[5,7],[4,5,6]], a.elementwise.+(b,3) )
  end

  def test_ewise
    a = [1,2,3]
    assert_equal( [4,5,6], a.ewise + 3 )
    assert_equal( [5,7], a.ewise + [4,5] )
    assert_equal( [[5,7],[3,4,5]], a.ewise.+([4,5],2) )
    assert_equal( [[5,7],[4,5,6]], a.ewise.+([4,5],3) )
  end

end

# Test for facets/enumerable/each

require 'facets/enumerable/each.rb'

require 'test/unit'

class TestEnumerable < Test::Unit::TestCase

  def test_each_by_01
    x = []
    [1,2,3,4].each_by{ |a,b| x << [a,b] }
    o = [[1,2],[3,4]]
    assert_equal( o, x )
  end

  def test_each_by_02
    x = []
    [1,2,3,4,5].each_by{ |a,b,c| x << [a,b,c] }
    o = [[1,2,3],[4,5,nil]]
    assert_equal( o, x )
  end

  def test_each_by_03
    x = []
    [1,2,3,4].each_by(2){ |a,b| x << [a,b] }
    o = [[1,2],[3,4]]
    assert_equal( o, x )
  end

  def test_each_by_04
    x = []
    [1,2,3,4,5,6,7,8].each_by(4){ |*a| x << a }
    o = [ [[1,2,3,4]],[[5,6,7,8]] ]
    assert_equal( o, x )
  end

  def test_each_by_05
    x = []
    [1,2,3,4,5,6].each_by(3){ |*a| x << a }
    o = [ [[1,2,3]],[[4,5,6]] ]
    assert_equal( o, x )
  end

  def test_each_by_06
    a = [1,2,3,4,5,6]
    r = []
    a.each_by(2){ |x,y| r << [x,y] }
    assert_equal( [[1,2],[3,4],[5,6]], r )
  end

  def test_each_by_07
    a = [1,2,3,4,5,6]
    r = []
    a.each_by(3){ |*e| r << e }
    assert_equal( [ [[1,2,3]], [[4,5,6]] ], r )
  end

  def test_each_pair
    r = []
    a = [1,2,3,4]
    a.each_pair{ |a,b| r << [a,b] }
    assert_equal( [[1,2],[3,4]], r )
  end

  def test_eachn
    x = []
    [1,2,3,4].eachn{ |a,b| x << [a,b] }
    o = [[1,2],[3,4]]
    assert_equal( o, x )

    x = []
    [1,2,3,4,5].eachn{ |a,b,c| x << [a,b,c] }
    o = [[1,2,3],[4,5,nil]]
    assert_equal( o, x )
  end

end

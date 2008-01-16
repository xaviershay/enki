# Test facets/tuple.rb

require 'facets/tuple.rb'
require 'test/unit'

class TC_Tuple < Test::Unit::TestCase

  def test_01
    t1 = Tuple[1,2,3]
    t2 = Tuple[2,4,5]
    assert( t1 < t2 )
    assert( t2 > t1 )
  end

  def test_02
    t1 = Tuple[1,2,3]
    a1 = t1.to_a
    assert( Array === a1 )
  end

  def test_03
    t1 = Tuple[1,2,3]
    t2 = Tuple[1,2,3]
    assert( t1.object_id === t2.object_id )
  end

  def test_04
    t1 = Tuple[1,2,3]
    t1 = t1 << 4
    assert( Tuple === t1 )
    t2 = Tuple[1,2,3,4]
    assert( t1.object_id == t2.object_id )
  end

  def test_05
    t1 = "1.2.3".to_t
    assert( Tuple === t1 )
    t2 = Tuple[1,2,3]
    assert( t1.object_id == t2.object_id )
  end

  def test_06
    t1 = "1.2.3a".to_t
    assert( Tuple === t1 )
    t2 = Tuple[1,2,'3a']
    assert_equal( t2, t1 )
    assert( t2.object_id == t1.object_id )
  end

end

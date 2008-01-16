# Test facets/inheritor.rb

require 'facets/inheritor.rb'

require 'test/unit'

#class TC_Inheritor_01 < Test::Unit::TestCase
#  def setup
#    @a = [1]
#    @i = Inheritor.new( @a, [2], :+ )
#  end
#  def test_01_001
#    assert_equal([2],@i)
#  end
#  def test_01_002
#    assert_equal([1,2],@i.inheritance)
#  end
#end

class TC_Inheritor_02 < Test::Unit::TestCase
  class C
    inheritor :koko, [1], :+
  end
  class D < C
    inheritor :koko, [2], :+
  end

  def test_02_001
    assert_equal( [1], C.koko! )
  end
  def test_02_002
    assert_equal( [1], C.koko )
  end
  def test_02_003
    assert_equal( [2], D.koko! )
  end
  def test_02_004
    assert_equal( [1,2], D.koko )
  end
end

class TC_Inheritor_03 < Test::Unit::TestCase
  class C
    inheritor :koko, [1], :+
  end
  class D < C
  end

  def test_03_001
    assert_equal( [1], C.koko! )
  end
  def test_03_002
    assert_equal( [1], C.koko )
  end
  def test_03_003
    assert_equal( [], D.koko! )
  end
  def test_03_004
    assert_equal( [1], D.koko )
  end
end

class TC_Inheritor_04 < Test::Unit::TestCase
  class X
    inheritor :x, {:a=>1}, :merge
  end
  module M
    inheritor :x, {:b=>2}, :merge
  end
  class Y < X
    include M
    inheritor :x, {:c=>3}, :merge
  end

  def test_04_001
    assert_equal( {:a=>1}, X.x )
  end
  def test_04_002
    assert_equal( 2, M.x[:b] )
  end
  def test_04_003
    assert_equal( {:a=>1,:b=>2,:c=>3}, Y.x )
  end
  def test_04_004
    assert_equal( 1, X.x[:a] )
    assert_equal( nil, X.x[:b] )
    assert_equal( nil, X.x[:c] )
  end
  def test_04_005 ; assert_equal( 1, Y.x[:a] ) ; end
  def test_04_006 ; assert_equal( 2, Y.x[:b] ) ; end
  def test_04_007 ; assert_equal( 3, Y.x[:c] ) ; end
  def test_04_008
    Y.x![:d] = 4
    assert_equal( 4, Y.x[:d] )
  end
end

class TC_Inheritor_05 < Test::Unit::TestCase
  class C
    inheritor :relations, [], :concat
  end
  class D < C
    #inheritor :relations, [], :concat
  end

  C.relations! << 1
  C.relations! << 2
  D.relations! << 3

  def test_05_001
    assert_equal( [1,2], C.relations )
    assert_equal( [1,2,3], D.relations )
  end
end

class TC_Inheritor_06 < Test::Unit::TestCase
  module MM
    inheritor :koko, [], :+
    koko! << 1
  end
  class CC1
    include MM
    #inheritor :koko, [], :+
    koko! << 2
    koko! << 3
  end
  class CC2
    include MM
    #inheritor :koko, [], :+
    koko! << 4
  end

  def test_06_001
    assert_equal( [1], MM.koko )
  end
  def test_06_002
    assert_equal( [1,2,3], CC1.koko )
  end
  def test_06_003
    assert_equal( [1,4], CC2.koko )
  end
end

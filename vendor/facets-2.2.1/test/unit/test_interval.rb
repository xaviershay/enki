# Test facets/interval.rb

require 'facets/interval.rb'

require 'test/unit'

class InclusiveTest < Test::Unit::TestCase

  def setup
    @a = Interval.new( 1, 10 )
    @b = Interval.new( 1, 10, true, false )
    @c = Interval.new( 1, 10, false, true )
    @d = Interval.new( 1, 10, true, true )
  end

  def test_001A ; assert_equal( false, @a.include?(0)  ) ; end
  def test_002A ; assert_equal( true,  @a.include?(1)  ) ; end
  def test_003A ; assert_equal( true,  @a.include?(2)  ) ; end
  def test_004A ; assert_equal( true,  @a.include?(9)  ) ; end
  def test_005A ; assert_equal( true,  @a.include?(10) ) ; end
  def test_006A ; assert_equal( false, @a.include?(11) ) ; end

  def test_001B ; assert_equal( false, @b.include?(0)  ) ; end
  def test_002B ; assert_equal( false, @b.include?(1)  ) ; end
  def test_003B ; assert_equal( true,  @b.include?(2)  ) ; end
  def test_004B ; assert_equal( true,  @b.include?(9)  ) ; end
  def test_005B ; assert_equal( true,  @b.include?(10) ) ; end
  def test_006B ; assert_equal( false, @b.include?(11) ) ; end

  def test_001C ; assert_equal( false, @c.include?(0)  ) ; end
  def test_002C ; assert_equal( true,  @c.include?(1)  ) ; end
  def test_003C ; assert_equal( true,  @c.include?(2)  ) ; end
  def test_004C ; assert_equal( true,  @c.include?(9)  ) ; end
  def test_005C ; assert_equal( false, @c.include?(10) ) ; end
  def test_006C ; assert_equal( false, @c.include?(11) ) ; end

  def test_001D ; assert_equal( false, @d.include?(0)  ) ; end
  def test_002D ; assert_equal( false, @d.include?(1)  ) ; end
  def test_003D ; assert_equal( true,  @d.include?(2)  ) ; end
  def test_004D ; assert_equal( true,  @d.include?(9)  ) ; end
  def test_005D ; assert_equal( false, @d.include?(10) ) ; end
  def test_006D ; assert_equal( false, @d.include?(11) ) ; end

end

class LrgNumericTest < Test::Unit::TestCase

  def setup
    @a = Interval.new(0,100000000)
    @b = Interval.new(0,100000000)
  end

  def test_001A ; assert_equal( true,  @a.include?(0)         ) ; end
  def test_002A ; assert_equal( true,  @a.include?(1000)      ) ; end
  def test_003A ; assert_equal( true,  @a.include?(1000000)   ) ; end
  def test_004A ; assert_equal( true,  @a.include?(100000000) ) ; end
  #def test_005A ; assert_equal( false, @a.include?(INFINITY)  ) ; end

  def test_001B ; assert_equal( true,  @b.include?(0)         ) ; end
  def test_002B ; assert_equal( true,  @b.include?(5)         ) ; end
  def test_002B ; assert_equal( true,  @b.include?(70007)     ) ; end
  def test_002B ; assert_equal( true,  @b.include?(5000005)   ) ; end
  #def test_002B ; assert_equal( false, @b.include?(INFINITY)  ) ; end

end

class SelectTest < Test::Unit::TestCase

  def setup
    @a = Interval.new( 0,10 )
  end

  def test_001
    b = @a.collect( 2 ){ |n| n }
    assert_equal( [0,2,4,6,8,10], b )
  end

  def test_002
    b = @a.select{ |n| n % 2 == 0 }
    assert_equal( [0,2,4,6,8,10], b )
  end

  def test_003
    b = @a.collect( 1,2 ){ |n| n }
    assert_equal( [0,5,10], b )
  end

  def test_004
    b = @a.select( 1,2 ){ |n| n % 2 == 0 }
    assert_equal( [0,10], b )
  end

end

class ArrayTest < Test::Unit::TestCase

  def setup
    @a = Interval.new( 0,10 )
    @b = Interval.new( 0,1 )
  end

  def test_001A ; assert_equal( [0,5,10], @a.to_a(1,2) ) ; end

  def test_001B ; assert_equal( [0, 0.25, 0.5, 0.75, 1.0], @b.to_a(1,4) ) ; end

end


=begin
  class InfTest < Test::Unit::TestCase

    def setup
      @a = Interval.new( -INFINITY, -3 )
      @b = Interval.new( -INFINITY, -3, true, false )
      @c = Interval.new( -3, INFINITY )
      @d = Interval.new( -INFINITY, INFINITY )
      @e = Interval.new( -3, -2 )
    end

    def test_001A ; assert_equal( true,  @a.include?(-INFINITY) ) ; end
    def test_002A ; assert_equal( true,  @a.include?(-4)        ) ; end
    def test_003A ; assert_equal( true,  @a.include?(-3)        ) ; end
    def test_004A ; assert_equal( false, @a.include?(-2)        ) ; end
    def test_005A ; assert_equal( false, @a.include?(INFINITY)  ) ; end

    def test_001B ; assert_equal( true,  @b.include?(-INFINITY) ) ; end
    def test_002B ; assert_equal( true,  @b.include?(-4)        ) ; end
    def test_003B ; assert_equal( false, @b.include?(-3)        ) ; end
    def test_004B ; assert_equal( false, @b.include?(-2)        ) ; end
    def test_005B ; assert_equal( false, @b.include?(INFINITY)  ) ; end

    def test_001C ; assert_equal( false, @c.include?(-INFINITY) ) ; end
    def test_002C ; assert_equal( false, @c.include?(-4)        ) ; end
    def test_003C ; assert_equal( true,  @c.include?(-3)        ) ; end
    def test_004C ; assert_equal( true,  @c.include?(-2)        ) ; end
    def test_005C ; assert_equal( true,  @c.include?(INFINITY)  ) ; end

    def test_001D ; assert_equal( true,  @d.include?(-INFINITY) ) ; end
    def test_002D ; assert_equal( true,  @d.include?(-4)        ) ; end
    def test_003D ; assert_equal( true,  @d.include?(-3)        ) ; end
    def test_004D ; assert_equal( true,  @d.include?(-2)        ) ; end
    def test_005D ; assert_equal( true,  @d.include?(INFINITY)  ) ; end

    def test_001E ; assert_equal( false, @e.include?(-INFINITY) ) ; end
    def test_002E ; assert_equal( false, @e.include?(-4)        ) ; end
    def test_003E ; assert_equal( true,  @e.include?(-3)        ) ; end
    def test_004E ; assert_equal( true,  @e.include?(-2)        ) ; end
    def test_005E ; assert_equal( false, @e.include?(INFINITY)  ) ; end

  end
=end

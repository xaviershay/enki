# Test for lib/facets/numeric/round

require 'facets/numeric/round.rb'

require 'test/unit'

class TestRound < Test::Unit::TestCase

  def setup
    @f0 = [ 0, 10, 15, 105 ]
    @f1 = [ 10.1, 10.01, 10.9, 10.09, 10.5, 10.05, 10.49 ]
  end

  def test_round_at_arg1
    fr = @f0.collect{ |f| f.round_at(1) }
    assert_equal( [0,10,15,105], fr )
    fr = @f1.collect { |f| f.round_at(1) }
    assert_equal( [10.1,10.0,10.9,10.1,10.5,10.1,10.5], fr )
  end

  def test_round_at_arg2
    fr = @f0.collect { |f| f.round_at(2) }
    assert_equal( [0,10,15,105], fr )
    fr = @f1.collect { |f| f.round_at(2) }
    assert_equal( [10.1,10.01,10.9,10.09,10.5,10.05,10.49], fr )
  end

  def test_round_off
    assert_equal( 1.0, 1.2.round_off )
    assert_equal( 2.0, 1.8.round_off )
  end

  def test_round_to_arg1
    fr = @f0.collect { |f| f.round_to(0.1) }
    assert_equal( [0,10,15,105], fr )
    fr = @f1.collect { |f| f.round_to(0.1) }
    assert_equal( [10.1,10.0,10.9,10.1,10.5,10.1,10.5], fr )
  end

  def test_round_to_arg10
    fr = @f0.collect { |f| f.round_to(10) }
    assert_equal( [0,10,20,110], fr )
    fr = @f1.collect { |f| f.round_to(10) }
    assert_equal( [10,10,10,10,10,10,10], fr )
  end

  def test_round_off
    assert_equal( 1.0, 1.2.round_off )
    assert_equal( 2.0, 1.8.round_off )
  end

  def test_approx?
    f = 10.006
    assert( f.approx?(10.01) )
    assert( f.approx?(10, 0.1) )
    assert( 100.4.approx?(100.6, 1) )
  end

end

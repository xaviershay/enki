# Test for facets/boolean.rb

require 'facets/boolean.rb'
require 'test/unit'


class TestStringBoolean < Test::Unit::TestCase

  def test_to_b
    assert( 'true'.to_b )
    assert( 'True'.to_b )
    assert( 'yes'.to_b )
    assert( 'YES'.to_b )
    assert( 'on'.to_b )
    assert( 'ON'.to_b )
    assert( 't'.to_b )
    assert( '1'.to_b )
    assert( 'y'.to_b )
    assert( 'Y'.to_b )
    assert( '=='.to_b )
    assert( ! 'nil'.to_b )
    assert( ! 'false'.to_b )
    assert( ! 'blahblahtrueblah'.to_b )
    assert_equal( nil, 'nil'.to_b )
    assert_equal( nil, 'null'.to_b )
  end

end


class TestArrayBoolean < Test::Unit::TestCase

  def test_to_b
    a = []
    assert_equal( false, a.to_b )
  end

end


class TestNumericBoolean < Test::Unit::TestCase

  def test_to_b
    assert_equal( false, 0.to_b )
    assert_equal( true, 1.to_b )
  end

end


class TestKernelBoolean < Test::Unit::TestCase

  def test_to_b
    assert_equal( true, true.to_b )
    assert_equal( false, false.to_b )
    assert_equal( false, nil.to_b )
  end

  def test_false?
    assert( false.false? )
    assert( (1 == 2).false? )
    assert( ! (1 == 1).false? )
  end

  def test_true?
    assert( true.true? )
    assert( (1 == 1).true? )
    assert( ! (1 == 2).true? )
  end

  def test_bool?
    assert_equal( true, true.bool? )
    assert_equal( true, false.bool? )
    assert_equal( false, nil.bool? )
    assert_equal( false, 0.bool? )
  end

end


class TestBoolean < Test::Unit::TestCase

  def test_to_bool
    assert_equal( true, true.to_bool )
    assert_equal( false, false.to_bool )
    assert_equal( false, nil.to_bool )
  end

end

# Test for facets/kernel/val

require 'facets/kernel/val.rb'

require 'test/unit'

class TestKernelVal < Test::Unit::TestCase

  def test_val_1
    f = nil
    t = 1
    assert( ! f.val? )
    assert( t.val? )
  end

  def test_val_2
    f = []
    t = [1]
    assert( ! f.val? )
    assert( t.val? )
  end

  def test_val_3
    f = ''
    t = '1'
    assert( ! f.val? )
    assert( t.val? )
  end

  def test_in?
    assert( 5.in?(0..10) )
    assert( 5.in?([1,2,3,4,5]) )
  end

  def test_non_nil?
    assert_equal(true,  5.non_nil?)
    assert_equal(true,  :x.non_nil?)
    assert_equal(false, nil.non_nil?)
    assert_equal(true,  false.non_nil?)
  end

end

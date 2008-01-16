# Test for facets/array/pad.rb

require 'facets/array/pad.rb'

require 'test/unit'

class TestArray < Test::Unit::TestCase

  def test_pad
    r = [0,1,2,3].pad(7,"x")
    x = [0,1,2,3,"x","x","x"]
    assert_equal(x,r)
  end

  def test_pad!
    a = [0,1,2,3]
    r = a.pad!(6,"y")
    x = [0,1,2,3,"y","y"]
    assert_equal(x,a)
  end

  def test_pad_negative
    r = [0,1,2,3].pad(-7,"n")
    x = ["n","n","n",0,1,2,3]
    assert_equal(x,r)
  end

  def test_pad_negative!
    a = [0,1,2,3]
    r = a.pad!(-6,"q")
    x = ["q","q",0,1,2,3]
    assert_equal(x,a)
  end

end

# Test for facets/integer/multiples

require 'facets/integer/multiple.rb'

require 'test/unit'

class TCInteger < Test::Unit::TestCase

  def test_even?
    (-100..100).step(2) do |n|
      assert(n.even? == true)
    end
    (-101..101).step(2) do |n|
      assert(n.even? == false)
    end
  end

  def test_odd?
    (-101..101).step(2) do |n|
      assert(n.odd? == true)
    end
    (-100..100).step(2) do |n|
      assert(n.odd? == false)
    end
  end

  def test_multiple?
    assert( ! 1.multiple?(2) )
    assert(   2.multiple?(2) )
    assert( ! 5.multiple?(3) )
    assert(   6.multiple?(3) )
  end

end




# Test facets/infinity.rb

require 'facets/infinity.rb'

require 'test/unit'

class GeneralTest < Test::Unit::TestCase

  def test_pos
    assert_equal((1.0/0), INFINITY.to_f)
    assert_equal(1, INFINITY<=>5)
    assert_equal(1, INFINITY<=>"a")
    assert_equal("PosInf", INFINITY.to_s)
  end

  def test_neg
    assert_equal((-1.0/0), -INFINITY.to_f)
    assert_equal(-1, -INFINITY<=>5)
    assert_equal(-1, -INFINITY<=>"a")
    assert_equal("NegInf", (-INFINITY).to_s)
  end

  def test_ord
    assert_equal((-1.0/0), -INFINITY.to_f)
    assert_equal(-1, 5<=>INFINITY)
    assert_equal(1, 5<=>-INFINITY)
  end

  def test_eq
    assert_equal(Inf, Inf)
    assert_equal(-Inf, -Inf)
    assert_equal(PosInf, PosInf)
    assert_equal(NegInf, NegInf)
    assert_not_equal(NaN, NaN)
  end

end




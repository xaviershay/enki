# Test for facets/string/interpolate

require 'facets/string/interpolate.rb'

require 'test/unit'

class TestStringInterpolate < Test::Unit::TestCase

  def test_interpolate
    a = 1
    assert_equal('this is 1', String.interpolate{ 'this is #{a}' })
  end

end



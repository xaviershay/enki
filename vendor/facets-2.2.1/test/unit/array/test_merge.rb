#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |
#   |_|\___||___/\__|
#
# for facets/array/merge.rb

require 'facets/array/merge.rb'

require 'test/unit'

class TestArray < Test::Unit::TestCase

  def test_merge
    a = [1,2,3]
    b = [3,4,5]
    assert_equal( [1,2,3,4,5], a.merge(b) )
  end

  def test_merge!
    a = [1,2,3]
    b = [3,4,5]
    a.merge!(b)
    assert_equal( [1,2,3,4,5], a )
  end

end


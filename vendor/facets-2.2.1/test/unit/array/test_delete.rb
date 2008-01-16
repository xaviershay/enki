#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |
#   |_|\___||___/\__|
#

require 'facets/array/delete.rb'

require 'test/unit'

class TestArray < Test::Unit::TestCase

  def test_delete_unless
    a = [1,2,3]
    a.delete_unless{ |e| e == 2 }
    assert_equal( [2], a )
  end

  def test_delete_values
    a = [1,2,3,4]
    assert_equal( [1,2], a.delete_values(1,2) )
    assert_equal( [3,4], a )
  end

  def test_delete_values_at
    a = [1,2,3,4]
    assert_equal( [2,3], a.delete_values_at(1,2) )
    assert_equal( [1,4], a )
    a = [1,2,3,4]
    assert_equal( [1,2,3], a.delete_values_at(0..2) )
    assert_equal( [4], a )
  end

end




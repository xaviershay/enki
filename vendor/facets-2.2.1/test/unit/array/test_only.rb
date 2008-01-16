#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |
#   |_|\___||___/\__|
#
require 'facets/array/only.rb'

require 'test/unit'

class TestArrayOnly < Test::Unit::TestCase

  def test_only
    assert_equal(5,   [5].only)
    assert_equal(nil, [nil].only)
    assert_raise(IndexError) { [].only }
    assert_raise(IndexError) { [1,2,3].only }
  end

end


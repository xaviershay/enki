# Test for facets/hash/insert

require 'facets/hash/insert.rb'

require 'test/unit'

class TestHashInsert < Test::Unit::TestCase

  def test_insert
    h = { :a=>1, :b=>2 }
    assert_equal( true  , h.insert(:c,3) )
    assert_equal( false , h.insert(:a,0) )
  end
end


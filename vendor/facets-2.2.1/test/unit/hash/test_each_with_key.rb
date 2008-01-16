# Test for lib/facets/hash/iterate

require 'facets/hash/each_with_key.rb'

require 'test/unit'

class TestHashIterate < Test::Unit::TestCase

  def test_each_with_key
    h1 = { :a=>1, :b=>2 }
    h2 = {}
    h1.each_with_key { |v,k| h2[v] = k }
    assert_equal( {1=>:a, 2=>:b}, h2 )
  end

end

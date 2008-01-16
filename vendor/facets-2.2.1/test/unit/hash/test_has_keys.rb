# Test for facets/hash/has_keys

require 'facets/hash/has_keys.rb'

require 'test/unit'

class TestHashHasKeys < Test::Unit::TestCase

  def test_has_keys?
    assert( { :a=>1,:b=>2,:c=>3 }.has_keys?(:a,:b) )
    assert( ! { :a=>1,:b=>2,:c=>3 }.has_keys?(:a,:b,:d) )
  end

  def test_has_only_keys?
    assert( { :a=>1,:b=>2,:c=>3 }.has_only_keys?(:a,:b,:c) )
    assert( ! { :a=>1,:b=>2,:c=>3 }.has_only_keys?(:a,:b) )
  end

end

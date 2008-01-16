# Test for facets/hash/alias

require 'facets/hash/alias.rb'

require 'test/unit'

class TestHashRekey < Test::Unit::TestCase

  def test_alias!
    foo = { 'a'=>1, 'b'=>2 }
    assert_equal( { 'a'=>1, 'b'=>2, 'c'=>2 }, foo.alias!('c','b') )
    foo = { 'a'=>1, 'b'=>2 }
    assert_equal( { :a=>1, 'a'=>1, 'b'=>2 }, foo.alias!(:a,'a') )
    foo = { :a=>1, :b=>2 }
    assert_equal( { :a=>1, :b=>2 }, foo.alias!('bar','foo') )
  end

end

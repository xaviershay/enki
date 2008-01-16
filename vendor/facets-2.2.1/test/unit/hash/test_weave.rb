# Test for facets/hash/weave

require 'facets/hash/weave.rb'

require 'test/unit'

class TestHashWeave < Test::Unit::TestCase

  def test_weave
    b = { :a=>1, :b=>[1,2,3], :c=>{ :x=>'X' } }
    c = { :a=>2, :b=>[4,5,6], :c=>{ :x=>'A', :y => 'B' } }
    r = { :a=>2, :b=>[1,2,3,4,5,6], :c=>{ :x => 'A', :y => 'B' } }
    assert_equal( r, b.weave(c) )
  end

end



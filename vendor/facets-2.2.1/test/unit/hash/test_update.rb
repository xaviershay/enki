# Test for facets/hash/update

require 'facets/hash/update.rb'

require 'test/unit'

class TestHashUpdate < Test::Unit::TestCase

  def test_replace_each
    a = { :a => 1, :b => 2, :c => 3 }
    e = { :a => 2, :b => 3, :c => 4 }
    a.replace_each{ |k,v| { k => v+1 } }
    assert_equal( e, a )
  end

  def test_update_each
    a = { :a => 1, :b => 2, :c => 3 }
    e = { :a => 2, :b => 3, :c => 4 }
    a.update_each{ |k,v| { k => v+1 } }
    assert_equal( e, a )
  end

  def test_update_keys
    h = { 'A' => 1, 'B' => 2 }
    h.update_keys{ |k| k.downcase }
    assert_equal( { 'a' => 1, 'b' => 2 }, h)
  end

  def test_update_values
    h = { 1 => 'A', 2 => 'B' }
    h.update_values{ |v| v.downcase }
    assert_equal( { 1 => 'a', 2 => 'b' }, h )
  end

end

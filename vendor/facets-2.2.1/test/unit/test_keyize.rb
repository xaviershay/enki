# Test for facets/hash/keyize

require 'facets/hash_keyize.rb'

require 'test/unit'

class TestHashKeyize < Test::Unit::TestCase

  def test_normalize_keys_01
    foo = { :a=>1, :b=>2 }
    assert_equal( { "a"=>1, "b"=>2 }, foo.normalize_keys{|k|k.to_s} )
    assert_equal( { :a =>1, :b=>2 }, foo  )
  end

  def test_normalize_keys_02
    foo = { :a=>1, :b=>2 }
    assert_equal( { "a"=>1, "b"=>2 }, foo.normalize_keys!{|k|k.to_s}  )
    assert_equal( { "a"=>1, "b"=>2 }, foo )
  end

  def test_keys_to_s
    foo = { :a=>1, :b=>2 }
    assert_equal( { "a"=>1, "b"=>2 }, foo.stringify_keys )
    assert_equal( { :a =>1, :b=>2 }, foo  )
  end

  def test_keys_to_s!
    foo = { :a=>1, :b=>2 }
    assert_equal( { "a"=>1, "b"=>2 }, foo.stringify_keys!  )
    assert_equal( { "a"=>1, "b"=>2 }, foo )
  end

  def test_keys_to_sym
    foo = { 'a'=>1, 'b'=>2 }
    assert_equal( { :a=>1, :b=>2 }, foo.symbolize_keys )
    assert_equal( { "a" =>1, "b"=>2 }, foo )
  end

  def test_keys_to_sym!
    foo = { 'a'=>1, 'b'=>2 }
    assert_equal( { :a=>1, :b=>2 }, foo.symbolize_keys! )
    assert_equal( { :a=>1, :b=>2 }, foo  )
  end

end

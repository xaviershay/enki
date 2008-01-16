# Test for facets/hash/rekey

require 'facets/hash/rekey.rb'

require 'test/unit'

class TestHashRekey < Test::Unit::TestCase

  def test_rekey_01
    foo = { :a=>1, :b=>2 }
    assert_equal( { "a"=>1, "b"=>2 }, foo.rekey{|k|k.to_s} )
    assert_equal( { :a =>1, :b=>2 }, foo  )
  end

  def test_rekey_02
    foo = { :a=>1, :b=>2 }
    assert_equal( { "a"=>1, "b"=>2 }, foo.rekey!{|k|k.to_s}  )
    assert_equal( { "a"=>1, "b"=>2 }, foo )
  end

  def test_rekey_03
    foo = { :a=>1, :b=>2 }
    assert_equal( { "a"=>1, "b"=>2 }, foo.rekey(:to_s) )
    assert_equal( { :a =>1, :b=>2 }, foo  )
  end

  def test_rekey_04
    foo = { :a=>1, :b=>2 }
    assert_equal( { "a"=>1, "b"=>2 }, foo.rekey!(:to_s) )
    assert_equal( { "a"=>1, "b"=>2 }, foo )
  end

  def test_rekey_05
    foo = { "a"=>1, "b"=>2 }
    assert_equal( { :a=>1, :b=>2 }, foo.rekey! )
    assert_equal( { :a=>1, :b=>2 }, foo )
  end

end

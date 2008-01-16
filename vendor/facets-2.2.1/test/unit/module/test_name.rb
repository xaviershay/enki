# Test for facets/module/name.rb

require 'facets/module/name.rb'
require 'test/unit'

class TestModuleName < Test::Unit::TestCase

  def test_by_name
    c = ::Test::Unit::TestCase.name
    assert_equal( ::Test::Unit::TestCase, Module.by_name(c) )
    c = "Test::Unit::TestCase"
    assert_equal( ::Test::Unit::TestCase, Class.by_name(c) )
  end

  def test_basename
    assert_equal( "TestCase", ::Test::Unit::TestCase.basename )
  end

  def test_dirname
    assert_equal( 'Test::Unit', Test::Unit::TestCase.dirname )
    assert_equal( 'Test::Unit', ::Test::Unit::TestCase.dirname )
    assert_equal( '', Test.dirname )
    assert_equal( '', ::Test.dirname )
  end

  def test_modspace
    assert_equal( Test::Unit, Test::Unit::TestCase.modspace )
    assert_equal( ::Test::Unit, ::Test::Unit::TestCase.modspace )
    assert_equal( Object, ::Test.modspace )
  end

  module M
    module N
      class C
        def n
          self.class.nesting
        end
      end
    end
  end

  def test_nesting
    assert_equal( [TestModuleName, M, M::N, M::N::C], M::N::C.new.n )
  end

end


# Test for facets/module/clone.rb

require 'facets/module/clone.rb'

require 'test/unit'

class TestModuleClone < Test::Unit::TestCase

  module M
    def f; 1; end
    def g; 2; end
  end

  class Remove
    include M.clone_removing( :g )
  end

  class Rename
    include M.clone_renaming( :q => :g )
  end

  class Use
    include M.clone_using( :f )
  end

  def test_removing
    assert( Remove.method_defined?(:f) )
    assert( ! Remove.method_defined?(:g) )
  end

  def test_renaming
    assert( ! Rename.method_defined?(:g) )
    assert( Rename.method_defined?(:f) )
    assert( Rename.method_defined?(:q) )
  end

  def test_using_2
    assert( ! Use.method_defined?(:g) )
    assert( Use.method_defined?(:f) )
  end

end




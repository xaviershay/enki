# Test for facets/module/modify.rb

require 'facets/module/modify.rb'

require 'test/unit'

# integrate

class TestModuleModifyIntegrate < Test::Unit::TestCase

  module M
    def x ; 1 ; end
  end

  class C
    integrate M do
      rename :y, :x
    end
  end

  def test_integrate
    c = C.new
    assert_raises( NoMethodError ) { c.x }
    assert_equal( 1, c.y )
  end

end

# revisal

class TestModuleModifyRevisal < Test::Unit::TestCase

  module M
    def x ; 1 ; end
  end

  class C
    include M.revisal {
      rename :y, :x
    }
  end

  def test_revisal
    c = C.new
    assert_raises( NoMethodError ) { c.x }
    assert_equal( 1, c.y )
  end

end

# nodef

class TestModuleModifyNoDef < Test::Unit::TestCase

  def the_undefined_method ; 'not here' ; end

  nodef :the_undefined_method

  def test_nodef
    assert( ! respond_to?( :the_undefined_method ) )
  end

end

# redef

class TestModuleModifyReDef < Test::Unit::TestCase

  # redef_method

  def a; "a"; end

  redefine_method(:a) { nil }

  def test_redefine_method
    assert_equal( nil, a )
  end

  # redef

  def b; "b"; end

  redef(:b) { "x" }

  def test_redef
    assert_equal( "x", b )
  end

end

# redirect_method

class TestModuleModifyReDirect < Test::Unit::TestCase

  def red1 ; 1 ; end

  redirect_method :red2 => :red1

  def test_redirect
    assert_equal( 1, red2 )
  end

  # redirect

  def blue1 ; 1 ; end

  redirect :blue2 => :blue1

  def test_redirect
    assert_equal( 1, blue2 )
  end

end

# remove method

class TestModuleModifyRemove < Test::Unit::TestCase

  def the_removed_method ; 'not here' ; end

  remove :the_removed_method

  def test_remove
    assert( ! respond_to?( :the_removed_method ) )
  end

end

# Rename

class TestModuleModifyRename < Test::Unit::TestCase

  def a; "A" ; end

  rename_method :b, :a

  def test_rename_method
    assert( ! respond_to?( :a ) )
    assert( respond_to?( :b ) )
  end

  # rename

  def c; "C" ; end

  rename :d, :c

  def test_rename
    assert( ! respond_to?( :c ) )
    assert( respond_to?( :d ) )
  end

end

# wrap_method

class TestModuleModifyWrap < Test::Unit::TestCase

  def a; "A"; end

  wrap_method(:a) { |old| old.call + "B" }

  def test_wrap_method
    assert_equal( "AB", a )
  end

  # wrap

  def b; "B"; end

  wrap(:b) { |old| old.call + "C" }

  def test_wrap
    assert_equal( "BC", b )
  end

end

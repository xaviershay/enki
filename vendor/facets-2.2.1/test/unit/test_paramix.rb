# Test facets/paramix.rb

require 'facets/paramix.rb'

require 'test/unit'

class TC_Paramix_01 < Test::Unit::TestCase

  module M
    def f
      M(:p)
    end
    def self.included_with_parameters( base, parms )
      base.class_eval do
        define_method :check do
          parms
        end
      end
    end
  end

  class C
    include M, :p => "check"
  end

  class D
    include M, :p => "steak"
  end

  def test_01_001
    c = C.new
    assert_equal( "check", c.M(:p) )
    assert_equal( "check", c.f )
  end

  def test_01_002
    d = D.new
    assert_equal( "steak", d.M(:p) )
    assert_equal( "steak", d.f )
  end

  def test_01_003
    assert_equal( {M=>{:p => "check"}}, C.mixin_parameters )
    assert_equal( {M=>{:p => "steak"}}, D.mixin_parameters )
  end

  def test_01_004
    c = C.new
    assert_equal( {:p => "check"}, c.check )
    d = D.new
    assert_equal( {:p => "steak"}, d.check )
  end

end


class TC_Paramix_02 < Test::Unit::TestCase

  module M
    def f
      M(:p)
    end
  end

  class C
    extend M, :p => "mosh"
  end

  class D
    extend M, :p => "many"
  end

  def test_02_001
    assert_equal( "mosh", C.f )
  end

  def test_02_002
    assert_equal( "many", D.f )
  end

  def test_02_003
    assert_equal( {M=>{:p => "mosh"}}, (class << C; self; end).mixin_parameters )
    assert_equal( {M=>{:p => "many"}}, (class << D; self; end).mixin_parameters )
  end

end

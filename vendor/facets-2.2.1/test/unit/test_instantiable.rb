# Test lib/facets/instantiable.rb

require 'facets/instantiable.rb'
require 'test/unit'

class TestInstantiable < Test::Unit::TestCase

  module M
    extend Module::Instantiable

    attr :a

    def initialize( a )
      @a = a
    end
  end

  def test_new
    m = M.new( 1 )
    assert_equal( 1, m.a )
  end

end

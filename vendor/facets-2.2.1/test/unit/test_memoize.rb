# Test lib/facets/memoize.rb

require 'facets/memoize.rb'
require 'test/unit'

# test

class TC_Memoize < Test::Unit::TestCase

  class T
    def initialize(a)
      @a = a
    end
    def a
      "#{@a ^ 3 + 4}"
    end
    memoize :a
  end


  def setup
    @t = T.new(2)
  end

  def test_memoize_01
    assert_equal( @t.a, @t.a )
  end

  def test_memoize_02
    assert_equal( @t.a.__id__, @t.a.__id__ )
  end

  def test_memoize_03
    assert_equal( @t.a.__id__, @t.a.__id__ )
  end

end

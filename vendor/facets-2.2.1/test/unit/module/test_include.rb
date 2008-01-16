# Test for facets/module/include.rb

require 'facets/module/include.rb'
require 'test/unit'

class TestInclude < Test::Unit::TestCase

  def test_ancestor
    assert( self.class.ancestor?(::Test::Unit::TestCase) )
  end

end

class TestOnInclude < Test::Unit::TestCase

  module M
    def self.check ; @@check ; end
    on_included %{
      @@check = 1
    }
  end

  module Q
    def self.check ; @@check ; end
    on_included %{
      @@check = 1
    }
    on_included %{
      @@check = 2
    }
  end

  class C
    include M
    include Q
  end

  def test_included
    assert_equal(1, M.check)
    assert_equal(2, Q.check)
  end

end

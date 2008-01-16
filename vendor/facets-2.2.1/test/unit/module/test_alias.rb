# Test for facets/module/alias

require 'facets/module/alias.rb'

require 'test/unit'

class TC_Module < Test::Unit::TestCase

  module MockModule
    # for alias_module_method
    def x ; 33 ; end
    module_function :x
    alias_module_function :y, :x
  end

  def test_alias_module_function
    assert_equal( 33, MockModule.y )
    #assert_equal( 33, @m.send(:y) ) # use send b/c private
  end


  module X
    def self.included(base)
      base.module_eval {
        alias_method_chain :foo, :feature
      }
    end
    def foo_with_feature
      foo_without_feature + '!'
    end
  end

  class Y
    def foo
      "FOO"
    end
    include X
    #alias_method_chain :foo, :feature
  end


  def test_001
    y = Y.new
    assert_equal( "FOO!", y.foo )
  end

end

# TITLE:
#
#   Memoize
#
# SUMMARY:
#
#   Directive for making your functions faster by trading
#   space for time. When you "memoize" a method/function
#   its results are cached so that later calls with the
#   same arguments returns results in the cache instead
#   of recalculating them.
#
# COPYRIGHT:
#
#   Copyright (c) 2005 Robert Feldt
#
# LICENSE:
#
#   Ruby License
#
#   This module is free software. You may use, modify, and/or redistribute this
#   software under the same terms as Ruby.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
#   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#   FOR A PARTICULAR PURPOSE.
#
# AUTHORS:
#
#   - Robert Feldt


#
class Module

  # Directive for making your functions faster by trading
  # space for time. When you "memoize" a method/function
  # its results are cached so that later calls with the
  # same arguments returns results in the cache instead
  # of recalculating them.
  #
  #   class T
  #     def initialize(a)
  #       @a = a
  #     end
  #     def a
  #       "#{@a ^ 3 + 4}"
  #     end
  #     memoize :a
  #   end
  #
  #   t = T.new
  #   t.a.__id__ == t.a.__id__  #=> true
  #
  def memoize(*meths)
    @_MEMOIZE_CACHE ||= Hash.new
    meths.each do |meth|
      mc = @_MEMOIZE_CACHE[meth] = Hash.new
      old = instance_method(meth)
      new = proc do |*args|
        if mc.has_key? args
          mc[args]
        else
          mc[args] = old.bind(self).call(*args)
        end
      end
      send(:define_method, meth, &new)
    end
  end

end

# This allows memoize to work in main and instance scope too.
#--
# Would this be good to have? Will need to modify for instance level, if so.
#++

def memoize(*args)
  Object.memoize(*args)
end

#
module Kernel

  # Object#cache is essentially like Module#memoize except
  # it can also be used on singleton/eigen methods.
  # OTOH, memoize's implementation is arguably better for it's
  # use of #bind instead of #alias. Eventually the two implmenations
  # will be reconciled with a single implmentation.

  def cache m = nil
    if m
      (Module === self ? self : (class << self; self; end)).module_eval <<-code
        alias_method '__#{ m }__', '#{ m }'
        def #{ m }(*__a__,&__b__)
          c = cache['#{ m }']
          k = [__a__,__b__]
          if c.has_key? k
            c[k]
          else
            c[k] = __#{ m }__(*__a__,&__b__)
          end
        end
      code
    end
    @cache ||= Hash::new{|h,k| h[k]={}}
  end

end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#
=begin test

  require 'test/unit'

  class T
    def initialize(a)
      @a = a
    end
    def a
      "#{@a ^ 3 + 4}"
    end
    memoize :a
  end

  # test

  class TC_Memoize < Test::Unit::TestCase

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

=end

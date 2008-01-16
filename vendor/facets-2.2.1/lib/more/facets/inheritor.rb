# TITLE:
#
#   Inheritor
#
# SUMMARY:
#
#   Prototype-like class design.
#
# COPYRIGHT:
#
#   Copyright (c) 2005 Thomas Sawyer
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
#   - Thomas Sawyer

#require 'facets/module/class_extension'
require 'facets/class_extension'

# = Inheritor
#
# Inheritor providse a means to store and inherit data via
# the class heirarchy. An inheritor creates two methods
# one named after the key that provides a reader. And one
# named after key! which provides the writer. (Because of
# the unique nature of inheritor the reader and writer
# can't be the same method.)
#
#   class X
#     inheritor :foo, [], :+
#   end
#
#   class Y < X
#   end
#
#   X.x! << :a
#   X.x => [:a]
#   Y.x => [:a]
#
#   Y.x! << :b
#   X.x => [:a]
#   Y.x => [:a, :b]
#
# It is interesting to note that the only reason inheritor is needed at all
# is becuase Ruby does not allow modules to be inherited at the class-level, or
# conversely that the "class-levels" of classes are not modules instead.

class Object

  # Create an inheritor "class attribute".
  def inheritor( key, obj, op=nil )

    # inhertiance operator
    op = op ? op.to_sym : :add

    # inheritor store a this level
    instance_variable_set("@#{key}", obj)

    #base = self
    deflambda = lambda do

      define_method( key ) do
        defined?(super) ? super.__send__(op,obj) : obj.dup
      end

      define_method( "#{key}!" ) do
        instance_variable_get("@#{key}") || inheritor( key, obj.class.new, op )
        #if instance_variables.include?("@#{key}")
        #  instance_variable_get("@#{key}")
        #else
        #  if self != base
        #    inheritor( key, obj.class.new, op )
        #  end
        #end
      end
    end

    # TODO This is an issue if you try to include a module
    # into Module or Class itself. How to fix?

    # if the object is a module (not a class or other object)
    if self == Class or self == Module
      class_eval &deflambda
    elsif is_a?(Class)
      (class << self; self; end).class_eval &deflambda
    elsif is_a?(Module)
      #class_inherit &deflambda
      extend class_extension( &deflambda )
    else # other Object
      (class << self; self; end).class_eval &deflambda
    end

    obj
  end

end


#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

=begin testing

  require 'test/unit'

  #class TC01 < Test::Unit::TestCase
  #  def setup
  #    @a = [1]
  #    @i = Inheritor.new( @a, [2], :+ )
  #  end
  #  def test_01_001
  #    assert_equal([2],@i)
  #  end
  #  def test_01_002
  #    assert_equal([1,2],@i.inheritance)
  #  end
  #end

  class TC02 < Test::Unit::TestCase
    class C
      inheritor :koko, [1], :+
    end
    class D < C
      inheritor :koko, [2], :+
    end

    def test_02_001
      assert_equal( [1], C.koko! )
    end
    def test_02_002
      assert_equal( [1], C.koko )
    end
    def test_02_003
      assert_equal( [2], D.koko! )
    end
    def test_02_004
      assert_equal( [1,2], D.koko )
    end
  end

  class TC03 < Test::Unit::TestCase
    class C
      inheritor :koko, [1], :+
    end
    class D < C
    end

    def test_03_001
      assert_equal( [1], C.koko! )
    end
    def test_03_002
      assert_equal( [1], C.koko )
    end
    def test_03_003
      assert_equal( [], D.koko! )
    end
    def test_03_004
      assert_equal( [1], D.koko )
    end
  end

  class TC04 < Test::Unit::TestCase
    class X
      inheritor :x, {:a=>1}, :merge
    end
    module M
      inheritor :x, {:b=>2}, :merge
    end
    class Y < X
      include M
      inheritor :x, {:c=>3}, :merge
    end

    def test_04_001
      assert_equal( {:a=>1}, X.x )
    end
    def test_04_002
      assert_equal( 2, M.x[:b] )
    end
    def test_04_003
      assert_equal( {:a=>1,:b=>2,:c=>3}, Y.x )
    end
    def test_04_004
      assert_equal( 1, X.x[:a] )
      assert_equal( nil, X.x[:b] )
      assert_equal( nil, X.x[:c] )
    end
    def test_04_005 ; assert_equal( 1, Y.x[:a] ) ; end
    def test_04_006 ; assert_equal( 2, Y.x[:b] ) ; end
    def test_04_007 ; assert_equal( 3, Y.x[:c] ) ; end
    def test_04_008
      Y.x![:d] = 4
      assert_equal( 4, Y.x[:d] )
    end
  end

  class TC05 < Test::Unit::TestCase
    class C
      inheritor :relations, [], :concat
    end
    class D < C
      #inheritor :relations, [], :concat
    end

    C.relations! << 1
    C.relations! << 2
    D.relations! << 3

    def test_05_001
      assert_equal( [1,2], C.relations )
      assert_equal( [1,2,3], D.relations )
    end
  end

  class TC06 < Test::Unit::TestCase
    module MM
      inheritor :koko, [], :+
      koko! << 1
    end
    class CC1
      include MM
      #inheritor :koko, [], :+
      koko! << 2
      koko! << 3
    end
    class CC2
      include MM
      #inheritor :koko, [], :+
      koko! << 4
    end

    def test_06_001
      assert_equal( [1], MM.koko )
    end
    def test_06_002
      assert_equal( [1,2,3], CC1.koko )
    end
    def test_06_003
      assert_equal( [1,4], CC2.koko )
    end
  end

=end

# TITLE:
#
#   ClassMethods
#
# SUMMARY:
#
#   Miniframework provides a very convenient way to have modules
#   pass along class methods in the inheritance chain.
#
# COPYRIGHT:
#
#    Copyright (c) 2005 Nobu Nakada, Thomas Sawyer
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
# HISTORY:
#
#   Thanks to Nobu and Ulysses for their original work on this.
#
# AUTHORS:
#
#   - Nobu Nakada
#   - Thomas Sawyer
#   - Ulysses
#
# NOTES:
#
#   - There are currently two approaches to this, ClassMethods and class_extensions.
#     A third is being worked on called Component with the idea that a "component"
#     is like a module except that it's class-level methods are mixed-in as well.
#     This is an idea solution, however it is less that ideal to implement.


# = ClassMethods
#
# Miniframework provides a very convenient way to have modules
# pass along class methods in the inheritance chain.
#
# An oddity of Ruby, when including modules, class/module methods
# are not inherited. To achieve this behavior requires some clever
# Ruby Karate. Instead ClassMethods provides an easy to use and clean
# solution. Simply place the class inheritable methods in a block of
# the special module method #ClassMetods.
#
#   module Mix
#     def inst_meth
#       puts 'inst_meth'
#     end
#
#     class_methods do
#       def class_meth
#         "Class Method!"
#       end
#     end
#   end
#
#   class X
#     include Mix
#   end
#
#   X.class_meth  #=> "Class Method!"
#
# This is equivalent to the original (but still functional) techinique of
# putting the class/module methods in a nested ClassMethods module
# and extending the original module *manually*. Eg.
#
#   module Mix
#     def inst_meth
#       puts 'inst_meth'
#     end
#
#     module ClassMethods
#       def class_meth
#         "Class Method!"
#       end
#     end
#
#     extend ClassMethods
#   end
#
#   class X
#     include Mix
#   end
#
#   X.class_meth  #=> "Class Method!"
#
# Also note that #class_inherit is an available alias
# for #class_methods for the sake of backward compatability.
# And #class_extension is alias (potentially) looking forward
# to a future version on Ruby.
#
# == Notes
#
# Just a quick comment on the need for this behavior.
#
# A module is an encapsulation of code, hence when a module is included
# (or extends), the module itself should have discretion over how it
# effects the receiving class/module. That is the very embodiment of
# encapsulation. Having it otherwise, as Ruby now does, stymies the
# practice --and we end up with "hacks", like this and ClassMethods,
# to compensate.
#
# Ruby would be much improved by making this bevaivor standard.
# And making non-inheritance the exception, which is alwasy easy
# enough to achieve: put the code in a separate (and thus uninherited)
# module.

class Module

  alias_method :append_features_without_classmethods, :append_features

  def append_features( base )
    result = append_features_without_classmethods( base )
    if const_defined?( :ClassMethods )
      base.extend( self::ClassMethods )
      unless base.is_a?( Class )
        unless base.const_defined?( :ClassMethods )
          base.const_set( :ClassMethods, Module.new )
        end
        my = self
        base::ClassMethods.class_eval do
          include my::ClassMethods
        end
      end
    end
    result
  end

  def class_methods( &yld )
    if const_defined?( :ClassMethods )
      self::ClassMethods.class_eval( &yld )
    else
      self.const_set( :ClassMethods, Module.new( &yld ) )
    end
    extend( self::ClassMethods )
    self::ClassMethods
  end

  # For compatibility with old rendition.
  alias_method :class_inherit, :class_methods

end

class Class
  undef_method :class_methods
  undef_method :class_inherit
end


#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

=begin test

  require 'test/unit'

  class TC_ClassMethods < Test::Unit::TestCase

    # fixture

    module N
      class_methods do
        def n ; 43 ; end
        def s ; self ; end
      end
    end

    class X
      include N
      def n ; 11 ; end
    end

    module K
      include N
      class_methods do
        def n ; super + 1 ; end
      end
    end

    class Z
      include K
    end

    # tests

    def test_01
      assert_equal( 43, N.n )
      assert_equal(  N,  N.s )
    end
    def test_02
      assert_equal( 43, X.n )
      assert_equal(  X, X.s )
    end
    def test_03
      assert_equal( 11, X.new.n )
    end
    def test_04
      assert_equal( 44, K.n )
      assert_equal(  K, K.s )
    end
    def test_05
      assert_equal( 44, Z.n )
      assert_equal(  Z, Z.s )
    end

  end

=end

# TITLE:
#
#  Typecast
#
# DESCRIPTION:
#
#   Provides a generic simple type conversion utility. All the ruby core
#   conversions are available by default.
#
# AUTHORS:
#
#   - Jonas Pfenniger
#
# HISTORY:
#
#   2006-06-06 3v1l_d4y:
#     - Removed transformation options.
#     - Removed StringIO typecast. It is not required by default.
#     - Added TypeCastException for better error reporting while coding.
#
# TODOS:
#
#   - Consider how this might fit in with method signitures, overloading,
#     and expiremental euphoria-like type system.
#
#   - Look to implement to_int, to_mailtext, to_r, to_rfc822text and to_str.
#
# COPYRIGHT:
#
#   Copyright (c) 2004 Jonas Pfenniger
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

require 'time'
require 'facets/stylize'  # for methodize and modulize

# = TypeCast
#
# Provides a generic simple type conversion utility. All the ruby core
# conversions are available by default.
#
# To implement a new type conversion, you have two choices :
#
# Take :
#
#  class CustomType
#    def initialize(my_var)
#      @my_var = my_var
#    end
#  end
#
# * Define a to_class_name instance method
#
#  class CustomType
#    def to_string
#      my_var.to_s
#    end
#  end
#
#  c = CustomType.new 1234
#  s.cast_to String   =>  "1234" (String)
#
# * Define a from_class_name class method
#
#  class CustomType
#    def self.from_string(str)
#      self.new(str)
#    end
#  end
#
#  "1234".cast_to CustomType  =>  #<CustomType:0xb7d1958c @my_var="1234">
#
# Those two methods are equivalent in the result. It was coded like that to
# avoid the pollution of core classes with tons of to_* methods.
#
# The standard methods to_s, to_f, to_i, to_a and to_sym are also used by
# this system if available.
#
# == Usage
#
#  "1234".cast_to Float     => 1234.0  (Float)
#  Time.cast_from("6:30")   => 1234.0   (Time)
#
# == FAQ
#
# Why didn't you name the `cast_to` method to `to` ?
#
#   Even if it would make the syntax more friendly, I suspect it could cause
#   a lot of collisions with already existing code. The goal is that each
#   time you call cast_to, you either get your result, either a
#   TypeCastException
#

# Exception error.

class TypeCastException < Exception; end

#

class Object

  # class TypeCastException < Exception; end

  # Cast an object to another
  #
  #    1234.cast_to(String)  => "1234"
  #
  def cast_to(klass)
    klass.cast_from(self)
  end

  # Cast on object from another
  #
  #   String.cast_from(1234) => "1234"
  #
  def cast_from(object)
    method_to = "to_#{self.name.methodize}".to_sym
    if object.respond_to? method_to
      retval = object.send(method_to)
      return retval
    end

    method_from = "from_#{object.class.name.methodize}".to_sym
    if respond_to? method_from
      retval = send(method_from, object)
      return retval
    end

    raise TypeCastException, "TypeCasting from #{object.class.name} to #{self.name} not supported"
  end
end

# Extend the ruby core

class Array
  class << self
    def cast_from(object)
      return super
    rescue TypeCastException
      return object.to_a if object.respond_to? :to_a
      raise
    end
  end
end

class Float
  class << self
    def cast_from(object)
      return super
    rescue TypeCastException
      return object.to_f if object.respond_to? :to_f
      raise
    end
  end
end

class Integer
  class << self
    def cast_from(object)
      return super
    rescue TypeCastException
      return object.to_i if object.respond_to? :to_i
      raise
    end
  end
end

class String
  class << self
    def cast_from(object)
      return super
    rescue TypeCastException
      return object.to_s if object.respond_to? :to_s
      raise
    end
  end
end

class Symbol
  class << self
    def cast_from(object)
      return super
    rescue TypeCastException
      return object.to_sym if object.respond_to? :to_sym
      raise
    end
  end
end

# Extensions

class Class
  class << self

    # "string".cast_to Class         #=> String

    def from_string(string)
      string = string.to_s.modulize
      base   = string.sub!(/^::/, '') ? Object : (self.kind_of?(Module) ? self : self.class )
      klass  = string.split(/::/).inject(base){ |mod, name| mod.const_get(name) }
      return klass if klass.kind_of? Class
      nil
    rescue
      nil
    end

    alias_method :from_symbol, :from_string

  end
end

class Time
  class << self
    def from_string(string, options={})
      parse(string)
    rescue
      nil
    end
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

  class TestClass
    attr_accessor :my_var
    def initialize(my_var); @my_var = my_var; end

    def to_string(options={})
      @my_var
    end

    class << self
      def from_string(string, options={})
        self.new( string )
      end
    end
  end

  class TC_TypeCast < Test::Unit::TestCase

    def setup
      @test_string = "this is a test"
      @test_class = TestClass.new(@test_string)
    end

    def test_to_string
      assert_equal( '1234', 1234.cast_to(String) )
    end

    def test_custom_to_string
      assert_equal( @test_string, @test_class.cast_to(String) )
    end

    def test_custom_from_string
      assert_equal( @test_class.my_var, @test_string.cast_to(TestClass).my_var )
    end

    def test_string_to_class
      assert_equal( Test::Unit::TestCase, "Test::Unit::TestCase".cast_to(Class) )
    end

    def test_string_to_time
      assert_equal( "Mon Oct 10 00:00:00 2005", "2005-10-10".cast_to(Time).strftime("%a %b %d %H:%M:%S %Y") )
    end

    def test_no_converter
      "sfddsf".cast_to( ::Regexp )
      assert(1+1==3, 'should not get here')
    rescue TypeCastException => ex
      assert_equal(TypeCastException, ex.class)
    end
  end

=end

# Author::    Jonas Pfenniger
# Copyright:: Copyright (c) 2004 Jonas Pfenniger
# License::   Ruby License

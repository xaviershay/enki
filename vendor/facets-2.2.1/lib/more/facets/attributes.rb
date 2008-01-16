# TITLE
#
#   Annotated Attributes
#
# DESCRIPTION:
#
#   This framework modifies the attr_* methods to allow easy
#   addition of annotations.
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
#   - George Moschovitis

require 'facets/annotations.rb'
require 'facets/inheritor.rb'

# = Annotated Attributes
#
# This framework modifies the attr_* methods to allow easy addition of annotations.
# It the built in attribute methods (attr, attr_reader, attr_writer and attr_accessor),
# to allow annotations to added to them directly rather than requireing a separate
# #ann statement.
#
#   class X
#     attr :a, :valid => lambda{ |x| x.is_a?(Integer) }
#   end
#
# See annotation.rb for more information.
#
# NOTE This library was designed to be backward compatible with the
# standard versions of the same methods.

class ::Module

  inheritor :instance_attributes, [], :|

  def attr( *args )
    args.flatten!
    case args.last
    when TrueClass
      args.pop
      attr_accessor( *args )
    when FalseClass
      args.pop
      attr_reader( *args )
    else
      attr_reader( *args )
    end
  end

  alias :plain_reader :attr_reader
  alias :plain_writer :attr_writer
  alias :plain_accessor :attr_accessor

  code = ''

  [ :_reader, :_writer, :_accessor].each do |m|

    code << %{
      def attr#{m}(*args)
        args.flatten!

        harg={}; while args.last.is_a?(Hash)
          harg.update(args.pop)
        end

        raise ArgumentError if args.empty? and harg.empty?

        if args.empty?        # hash mode
          harg.each { |a,h| attr#{m}(a,h) }
        else
          klass = harg[:class] = args.pop if args.last.is_a?(Class)

          args.each { |a|
            plain#{m} a
            a = a.to_sym
            ann(a,harg)
          }
          instance_attributes!.concat( args )  #merge!

          # Use this callback to customize for your needs.
          if respond_to?(:attr_callback)
            attr_callback(self, args, harg)
          end

          # return the names of the attributes created
          return args
        end
      end
    }

  end

  class_eval( code )

  # TODO Should attribute alias be kept?
  alias_method :attribute, :attr_accessor

  # Return list of attributes that have a :class annotation.
  #
  #   class MyClass
  #     attr_accessor :test
  #     attr_accessor :name, String, :doc => 'Hello'
  #     attr_accessor :age, Fixnum
  #   end
  #
  #   MyClass.instance_attributes # => [:test, :name, :age, :body]
  #   MyClass.classified_attributes # => [:name, :age]

  def classified_attributes
    instance_attributes.find_all do |a|
      self.ann(a, :class)
    end
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

  class TC01 < Test::Unit::TestCase
    class A
      attr_accessor :x, :cast=>"to_s"
    end

    def test_09_001
      a = A.new
      assert_equal( [:x], A.instance_attributes )
    end
  end

  class TC10 < Test::Unit::TestCase
    class A
      attr :x, :cast=>"to_s"
    end

    def test_10_001
      assert_equal( "to_s", A.ann(:x,:cast) )
    end
  end

=end

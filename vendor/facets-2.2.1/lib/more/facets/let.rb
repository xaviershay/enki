# TITLE:
#
#   Let
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

require 'facets/functor'

#
class Module

  # Use let to build a class like so:
  #
  #   class X
  #
  #     let.y = "Hello"
  #
  #     let.up = lambda { puts @y.upcase }
  #
  #   end
  #
  #   X.new.up  #=> HELLO
  #
  def let
    klass = self
    Functor.new do |op, *args|
      case op.to_s[-1,1]
      when '='
        op = op.to_s.chomp('=')
        if Proc === args[0]
          define_method(op, &args[0])
        else
          define_method( op ) do
            r = instance_variable_set( "@#{op}", args[0] )
            klass.class.class_eval %{
              def #{op}; @#{op}; end
            }
            r
          end
        end
      else
        klass.class_eval %{
          def #{op}; @#{op}; end
        }
      end
    end
  end

end


=begin test

  require 'test/unit'

  class TCthis < Test::Unit::TestCase

    class Foo
      this.bar = 10
    end

    def test01
      x = Foo.new
      assert_equal( 10, x.bar )
    end

  end

=end


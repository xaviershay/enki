# TITLE:
#
#  Curry
#
# DESCRIPTION:
#
#   Simple currying library.
#
# COPYRIGHT:
#
#   Copyright (c) 2007 Thomas Sawyer
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
#   - 7rans (Thomas Sawyer)


# MissingArgument class is used to represent a curry hole.

class MissingArgument < ArgumentError
end

# Convenience method for curry hold (ie. MissingArgument)

def __
  MissingArgument
end


class Proc
  # Curry Proc object into new Proc object.

  def curry(*args)
    Proc.new do |*spice|
      result = args.collect do |a|
        MissingArgument == a ? spice.pop : a
      end
      call(*result)
    end
  end
end


class Method
  # Curry a Method into a new Proc.

  def curry(*args)
    Proc.new do |*spice|
      result = args.collect do |a|
        MissingArgument == a ? spice.pop : a
      end
      call(*result)
    end
  end
end


=begin test

  require 'test/unit'

  class TestCurry < Test::Unit::TestCase

    def setup
      @p = Proc.new{ |a,b,c| a + b + c }
    end

    def test_first
      n = @p.curry(__,2,3)
      assert_equal( 6, n[1] )
    end

    def test_second
      n = @p.curry(1,__,3)
      assert_equal( 6, n[2] )
    end

    def test_third
      n = @p.curry(1,2,__)
      assert_equal( 6, n[3] )
    end

  end

=end

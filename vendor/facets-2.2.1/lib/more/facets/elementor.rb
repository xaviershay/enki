# TITLE:
#
#  Elementor
#
# SUMMARY:
#
#   Provides elementwise functionality.
#
# COPYRIGHT:
#
#   Copyright (c) 2006 Thomas Sawyer
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
#   - Martin DeMello
#
# NOTES:
#
#   - This could have been impemented with a generic Functor, rather than
#     the specialized Elementor, but for the fact Procs can not yet
#     handle blocks.
#
#   - There used to be a "Cascading Elementor", but that proved idiotic
#     in the face of adding an instance_eval block to #every.
#
#   - Any ideas for a better name for #accumulate? --gmosx
#
#   - The use of every! and it's relation to Enumerator still seems a bit
#     off beat. Should #every always use #map? And another method #each?

require 'enumerator'
require 'facets/functor'

module Enumerable

  # Accumulate a set of a set.
  #
  # For example, in an ORM design if Group
  # has_many User then
  #
  #   groups.accumulate.users
  #
  # will return a list of users from all groups.

  def accumulate
    @_accumulate ||= Functor.new do |op, *args|
      inject([]) { |a, x| a << x.send(op, *args) }.flatten
    end
  end

  # Create Elementor.

  def to_elem(meth=nil)
    Elementor.new(self, meth || :map)
  end

  # Returns an elemental object. This allows
  # you to map a method on to every element.
  #
  #   r = [1,2,3].every + 3  #=> [4,5,6]

  def every
    @_every ||= to_elem
  end

  # In place version of #every.

  def every!
    raise NoMethodError unless respond_to?(:map!)
    @_every_inplace ||= to_elem(:map!)
  end

  #def every
  #  @_every ||= Functor.new do |op,*args|
  #    map{ |a| a.send(op,*args) }
  #  end
  #end

  #def every!
  #  raise NoMethodError unless respond_to?(:map!)
  #  @_every_inplace ||= Functor.new do |op,*args|
  #    map!{ |a| a.send(op,*args) }
  #  end
  #end

  # Expiremental alias for every.
  #
  #   r = [1,2,3].x + 3  #=> [4,5,6]
  #
  # Good, bad or ugly?

  alias_method :x, :every
  alias_method :x!, :every!

  # Possible name change for every.
  #
  #   r = [1,2,3].elements + 3  #=> [4,5,6]
  #
  # Certainly reads better.

  alias_method :elements, :every
  alias_method :elements!, :every!

  # Returns an elementwise Functor designed to make R-like
  # elementwise operations possible.
  #
  #   [1,2].elementwise + 3          #=> [4,5]
  #   [1,2].elementwise + [4,5]      #=> [5,7]
  #   [1,2].elementwise + [[4,5],3]  #=> [[5,7],[4,5]
  #
  #--
  # Special thanks to Martin DeMello for helping to develop this.
  #++

  def elementwise(count=1)
    @_elementwise_functor ||= []
    @_elementwise_functor[count] ||= Functor.new do |op,*args|
      if args.empty?
        r = self
        count.times do
          r = r.collect{ |a| a.send(op) }
        end
        r
      else
        r = args.collect do |arg|
          if Array === arg #arg.kind_of?(Enumerable)
            x = self
            count.times do
              ln = (arg.length > length ? length : arg.length )
              x = x.slice(0...ln).zip(arg[0...ln]).collect{ |a,b| a.send(op,b) }
              #slice(0...ln).zip(arg[0...1n]).collect{ |a,b| b ? a.send(op,b) : nil }
            end
            x
          else
            x = self
            count.times do
              x = x.collect{ |a| a.send(op,arg) }
            end
            x
          end
        end
        r.flatten! if args.length == 1
        r
      end
    end
  end

  # Concise alias for #elementwise.
  #
  #   a = [1,2]
  #   a.ewise + 3          #=> [4,5]
  #   a.ewise + [4,5]      #=> [5,7]
  #   a.ewise + [[4,5],3]  #=> [[5,7],[4,5]
  #
  # Note this used to be #ew as weel as the '%' operator.
  # Both of whihc are deprecated.

  alias_method :ewise, :elementwise
end


# = Elementor
#
# Elementor is a type of *functor*. Operations
# applied to it are routed to each element.

class Enumerable::Elementor
  private *instance_methods.select{|x| x !~ /^__/ }

  def initialize(elem_object, elem_method=nil)
    @elem_object = elem_object
    @elem_method = elem_method || :map
  end

  def instance_delegate
    @elem_object
  end

  def instance_operator
    @elem_method
  end

  #def ==(other)
  #  instance_delegate == other.instance_delegate &&
  #  instance_operator == other.instance_operator
  #end

  def method_missing(sym,*args,&blk)
    @elem_object.send(@elem_method){ |x| x.send(sym,*args,&blk) }
  end
end


class Enumerable::Enumerator

  # Create Elementor.

  def to_elem(meth=nil)
    Elementor.new(self, meth || :each)
  end

  # Enumerator doesn't support inplace element operations, per se.

  undef_method :every!
  undef_method :x!
  undef_method :elements!
end


#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#
=begin test

  require 'test/unit'

  class TCElementor < Test::Unit::TestCase

    def test_to_elem
      e = [1,2,3].to_elem
      assert_equal( [4,5,6], e + 3 )
      assert_equal( [0,1,2], e - 1 )
    end

    def test_to_elem_str
      e = [1,2,3].to_elem
      assert_equal( ['1','2','3'], e.to_s )
    end

    def test_every
      a = [1,2,3]
      assert_equal( [4,5,6], a.every + 3 )
      assert_equal( [0,1,2], a.every - 1 )
      assert_equal( ['1','2','3'], a.every.to_s )
    end

    def test_every!
      a = [1,2,3]
      a.every! + 3
      assert_equal( [4,5,6], a )
    end

    def test_to_enum_every
      e = [1,2,3].to_enum(:map)
      w = e.every + 3
      assert_equal( [4,5,6], w )
    end

  end

  class TestElementWise < Test::Unit::TestCase

    def test_elementwise
      a = [1,2,3]
      b = [4,5]
      assert_equal( [4,5,6], a.elementwise + 3 )
      assert_equal( [5,7], a.elementwise + b )
      assert_equal( [[5,7],[3,4,5]], a.elementwise.+(b,2) )
      assert_equal( [[5,7],[4,5,6]], a.elementwise.+(b,3) )
    end

    def test_ewise
      a = [1,2,3]
      assert_equal( [4,5,6], a.ewise + 3 )
      assert_equal( [5,7], a.ewise + [4,5] )
      assert_equal( [[5,7],[3,4,5]], a.ewise.+([4,5],2) )
      assert_equal( [[5,7],[4,5,6]], a.ewise.+([4,5],3) )
    end

  end

=end

# TITLE:
#
#   EnumerablePass
#
# SUMMARY:
#
#   A straigt-foward reimplementation of the core Enumerable module
#   to allow the methods to take and pass-on arbitrary arguments to the
#   underlying #each call.
#
# COPYRIGHT:
#
#   Copyright (c) 2004 Thomas Sawyer
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

require 'enumerator'

# = EnumerablePass
#
# This is a simple reimplementation of the core Enumerable module
# to allow the methods to take and pass-on arbitrary arguments to the
# underlying #each call. This library uses Enumerator and scans
# Enumerable so it can alwasy stay in sync.
#
# NOTE Any Enumerable method with a negative arity cannot do pass arguments
# due to ambiguity in the argument count. So the methods #inject and #zip
# do NOT work this way, but simply work as they do in Enumerable.
# The method #find (and #detect) though has been made to work by removing
# its rarely used optional parameter and providing instead an optional
# keyword parameter (:ifnone => ...). Please keep these difference in mind.
#
# == Synopsis
#
#   class T
#     include EnumerablePass
#     def initialize(arr)
#       @arr = arr
#     end
#     def each(n)
#       arr.each{ |e| yield(e+n) }
#     end
#   end
#
#   t = T.new([1,2,3])
#   t.collect(4)
#   #=> [5,6,7]
#

module EnumerablePass

  def self.wrap_enumerable_method( methodname )

    m = methodname
    meth = Enumerable.instance_method(m)
    arity = meth.arity

    case arity <=> 0
    when 0
      class_eval %{
        def #{m}( *args, &yld )
          enum_for(:each, *args).#{m}( &yld )
        end
      }
    when 1
      class_eval %{
        def #{m}( *args, &yld )
          args, each_args = args[0...#{arity}], args[#{arity}..-1]
          enum_for(:each, *each_args).#{m}( *args, &yld )
        end
      }
    else
      class_eval %{
        def #{m}( *args, &yld )
          enum_for(:each).#{m}( *args, &yld )
        end
      }
    end
  end

  Enumerable.instance_methods(false).each do |m|
    wrap_enumerable_method( m )
  end

  # Make exception for #find (a negative arity method) to accept
  # keyword argument.
  #
  #   ObjectSpace.find(Class, :ifnone=>lambda{1}) { |e| ... }
  #   ObjectSpace.find(Class, :ifnone=>lambda{1}) { |e| ... }
  #
  def find(*args, &yld)  # future use **keys ?
    if Hash === args.last and args.last.key?(:ifnone)
      ifnone = args.last.delete(:ifnone)
      args.pop if args.last.empty?
      enum_for(:each, *args).find( ifnone, &yld )
    else
      enum_for(:each, *args).find( &yld )
    end
  end
  alias_method :detect, :find

end


=begin  OLD CODE
module EnumerableArgs

  def collect(*args)  # :yield:
    a = []
    each(*args){ |n| a << yield(n) }
    a
  end
  alias_method( :map, :collect )

  def detect(*args)  # :yield:
    each(*args){ |n| return n if yield(n) }
    nil
  end
  alias_method( :find, :detect )

  def each_with_index(*args)
    i=0
    each(*args){ |*n| n << i; yield(*n); i+=1 }
    self
  end

  def to_a(*args)
    a = []
    each(*args){ |n| a << n }
    a
  end
  alias_method( :entries, :to_a )

  # An additional method not part of standard Enumerable.
  # The regular version of this method can be found in Facets,
  # but it is a bit more advanced then this one.
  # At some point they need to be put into sync.
  def each_slice(*args, &yld)
    a = []; s = []
    ar = yld.arity.abs
    each(*args){ |n|
      s << n
      if s.length >= ar
        yld.call(*s)
        s = []
      end
    }
    a
  end
  alias_method( :each_by, :each_slice )

  def select(*args)  # :yield:
    a = []
    each(*args){ |n| a << n if yield(n) }
    a
  end
  alias_method( :find_all, :select )

  def grep(pattern, *args)
    a = []
    each(*args){ |n| a << (block_given? ? yield(n) : n) if pattern === n }
    a
  end

  def include?(anObj, *args)
    each(*args){ |n| return true if anObj == n }
    false
  end
  alias_method( :member?, :include? )

  def max(*args)
    to_a(*args).max
  end

  def min(*args)
    to_a(*args).min
  end

  def reject(*args)
    a = []
    each(*args){ |n| a << n if ! yield(n) }
    a
  end

  def sort(*args)
    # TODO
  end

end
=end


#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

=begin testing

  require 'test/unit'

  # fixture

  class PlusArray
    include EnumerablePass
    def initialize(arr)
      @arr = arr
    end
    def each(n=0)
      @arr.each{ |e| yield(e+n) }
    end
  end

  class TC_Enumerable < Test::Unit::TestCase

    def test_collect
      t = PlusArray.new([1,2,3])
      assert_equal( [5,6,7], t.collect(4){ |e| e } )
    end

    #def test_each_slice
    #  t = PlusArray.new([1,2,3,4])
    #  a = []
    #  t.each_slice(2,4){ |e,f| a << [e,f] }
    #  assert_equal( [[5,6],[7,8]], a )
    #end

    #def test_find
    #  t = PlusArray.new([1,2,3,4])
    #  f = t.find(2, :ifnone=>lambda{:NOPE}) { |a| a == 10 }
    #  assert_equal(:NOPE, f)
    #end

    def test_grep
      # TODO
    end

    def test_to_a
      t = PlusArray.new([1,2,3])
      assert_equal( [5,6,7], t.to_a(4) )
    end

    def test_min
      t = PlusArray.new([1,2,3])
      assert_equal( 5, t.min(4) )
    end

    def test_max
      t = PlusArray.new([1,2,3])
      assert_equal( 7, t.max(4) )
    end

    def test_include?
      t = PlusArray.new([1,2,3])
      assert( t.include?(7,4) )
    end

    def test_select
      t = PlusArray.new([1,2,3])
      assert_equal( [6], t.select(4){ |x| x == 6 } )
    end

    def test_reject
      t = PlusArray.new([1,2,3])
      assert_equal( [5,7], t.reject(4){ |x| x == 6 } )
    end

  end

=end

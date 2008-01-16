# TITLE:
#
#   Interval
#
# SUMMARY:
#
#   While Ruby support the Range class out of the box, is does not quite
#   fullfil the role od a real Interval class. This class does.
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
#
# TODOs:
#
#   - Still need to tie in Infinity.

require 'facets/multiton'
require 'facets/enumerablepass'
#require 'facets/infinity'

# = Interval
#
# While Ruby support the Range class out of the box, is does not quite
# fullfil the role od a real Interval class. For instance, it does
# not support excluding the front sentinel. This is because Range
# also tries to do triple duty as a simple Sequence and as a simple Tuple-Pair,
# thus limiting its potential as an Interval. The Interval class remedies
# the situation by commiting to interval behavior, and then extends the class'
# capabilites beyond that of the standard Range in ways that naturally
# fall out of that.
#
# Range depends on two methods: #succ and #<=>. If numeric
# ranges were the only concern, those could just as well be #+ and #<=>,
# but esoteric forms make that unfeasible --the obvious example being a String
# range. But a proper Interval class requires mathematical continuation,
# thus the Interval depends on #+ and #<=>, as well as #- as the inverse of #+.
#
# == Synopsis
#
#   i = Interval.new(1,5)
#   i.to_a       #=> [1,2,3,4,5]
#
#   i = Interval[0,5]
#   i.to_a(2)    #=> [0,2,4]
#
#   i = Interval[1,5]
#   i.to_a(-1)   #=> [5,4,3,2,1]
#
#   i = Interval[1,3]
#   i.to_a(1,2)  #=> [1.0,1.5,2.0,2.5,3.0]

class Interval

  include Multiton
  include EnumerablePass

  def self.[]( *args )
    self.new( *args )
  end

  def initialize(first, last, exclude_first=false, exclude_last=false )
    raise ArgumentError, "bad value for interval" if first.class != last.class
    @first = first
    @last = last
    @exclude_first = exclude_first
    @exclude_last = exclude_last
    @direction = (@last <=> @first)
  end

  # Returns a two element array of first and last sentinels.
  #
  #  (0..10).sentinels   #=> [0,10]
  #
  def sentinels
    return [@first, @last]
  end

  # Returns the first or last sentinal of the interval.
  def first ; @first ; end
  def last ; @last ; end

  #
  def exclude_first? ; @exclude_first ; end
  def exclude_last? ; @exclude_last ; end

  # (IMHO) these should be deprectated
  alias_method( :begin, :first )
  alias_method( :end, :last )
  alias_method( :exclude_begin?, :exclude_first? )
  alias_method( :exclude_end?, :exclude_last? )

  # Returns +true+ if the start and end sentinels are equal and the interval is closed; otherwise +false+.
  def degenerate? ; @direction == 0 and ! (@exclusive_first or @exclusive_last) ;  end

  # Returns +true+ if the start and end sentinels are equal and the interval is open; otherwise +false+.
  def null? ; @direction == 0 and @exclusive_first and @exclusive_last ; end

  # Returns the direction of the interval indicated by +1, 0 or -1.
  #
  #   (1..5).direction  #=> 1
  #   (5..1).direction  #=> -1
  #   (1..1).direction  #=> 0
  #
  def direction ; @direction ; end

  # Returns a new interval inclusive of of both sentinels.
  def closed; Interval.new(@first, @last, true, true) ; end

  # Returns a new interval exclusive of both sentinels.
  def opened; Interval.new(@first, @last, true, true) ; end

  # Returns a new interval with either the first or the last sentinel exclusive.
  # If the parameter is false, the deafult, then the first sentinel is excluded;
  # if the parameter is true, the last sentinel is excluded.
  def half_closed(e=false)
    e ? Interval.new(@first, @last, true, false) : Interval.new(@first, @last, false, true)
  end

  # Returns a new interval with one of the two sentinels opened or closed
  def first_closed ; Interval.new(@first, @last, false, true) ; end
  def last_closed ; Interval.new(@first, @last, true, false) ; end
  def first_opened ; Interval.new(@first, @last, true, false) ; end
  def last_opened ; Interval.new(@first, @last, false, true) ; end

  # Unary shorthands. These return a new interval exclusive of first,
  # last or both sentinels, repectively.
  def +@ ; Interval.new(first, last, true, false) ; end
  def -@ ; Interval.new(first, last, false, true) ; end
  def ~@ ; Interval.new(first, last, true, true) ; end

  # Returns a new interval with the sentinels reversed.
  #
  #   (0..10).reversed  #=> 10..0
  #
  def reversed
    Interval.new(@last, @first, true, true)
  end

  # Returns the length of the interval as the difference between
  # the first and last elements. Returns +nil+ if the sentinal objects
  # do not support distance comparison (#distance).
  # TODO: Add +n+ parameter to count segmentations like those produced by #each.
  def distance
    @last - @first
    #if @last.respond_to?( :distance )
    #  @last.distance( @first )
    #else
    #  #self.to_a.length
    #end
  end
  alias_method( :length, :distance )
  alias_method( :size, :distance )

  # Returns the lesser of the first and last sentinals.
  def min
    ((@first <=> @last) == -1) ? @first : @last
  end

  # Returns the greater of the first and last sentinals.
  def max
    ((@first <=> @last) == 1) ? @first : @last
  end

  # Returns true or false if the element is part of the interval.
  def include?(x)
    # todo: infinity?
    tf = exclude_first? ? 1 : 0
    tl = exclude_last? ? -1 : 0
    (x <=> first) >= tf and (x <=> last) <= tl
  end
  alias_method( :===, :include? )
  alias_method( :member?, :include? )

=begin
#     def include?(x)
#       tf = exclude_first? ? 1 : 0
#       tl = exclude_last? ? -1 : 0
#       # if other classes handled Infinity in their <=> method
#       # (which probably they should) this clause would not be required
#       if first.kind_of?(InfinityClass)
#         ft = ((first <=> x) <= tf)
#       else
#         ft = (x <=> first) >= tf
#       end
#       if last.kind_of?(InfinityClass)
#         fl = ((last <=> x) >= tl)
#       else
#         fl = (x <=> last) <= tl
#       end
#       ft && fl
#     end
=end

  # Iterates over the interval, passing each _n_th element to the block.
  # If n is not given then n defaults to 1. Each _n_th step is determined
  # by invoking +\++ or +\-+ n, depending on the direction of the interval.
  # If n is negative the iteration is preformed in reverse form end sentinal
  # to front sentinal. A second parameter, d, can be given in which case
  # the applied step is calculated as a fraction of the interval's length
  # times n / d. This allows iteration over the whole interval in equal sized
  # segments.
  #
  #   1..5.each { |e| ... }        #=> 1 2 3 4 5
  #   1..5.each(2) { |e| ... }     #=> 1 3 5
  #   1..5.each(1,2) { |e| ... }   #=> 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0
  #
  def each(n=1, d=nil)  # :yield:
    return (n < 0 ? @last : @first) if degenerate?  # is this right for all values of n ?
    s = d ? self.length.to_f * (n.to_f / d.to_f) : n.abs
    raise "Cannot iterate over zero length steps." if s == 0
    s = s * @direction
    if n < 0
      e = @exclude_last ? @last - s : @last
      #e = @exclude_last ? @last.pred(s) : @last
      t = @exlude_last ? 1 : 0
      #while e.cmp(@first) >= t
      while (e <=> @first) >= t
        yield(e)
        e -= s
        #e = e.pred(s)
      end
    else
      e = @exclude_first ? @first + s : @first
      #e = @exclude_first ? @first.succ(s) : @first
      t = @exlude_last ? -1 : 0
      #while e.cmp(@last) <= t
      while (e <=> @last) <= t
        yield(e)
        e += s
        #e = e.succ(s)
      end
    end
  end
  alias_method( :step, :each )

  # Should there be a #reverse_each ?
  # Since #each can now take a negative argument, this isn't really needed.
  # Should it exist anyway and routed to #each?
  # Also, alias_method( :reverse_step, :reverse_each )

  # Compares two intervals to see if they are equal
  def eql?(other)
    return false unless @first == other.first
    return false unless @last == other.last
    return false unless @exclude_first == other.exclude_first?
    return false unless @exclude_last == other.exclude_last?
    true
  end

end

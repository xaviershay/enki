# TITLE:
#
#   PQueue
#
# DESCRIPTION:
#
#   A priority queue is like a standard queue, except that each inserted
#   elements is given a certain priority, based on the result of the
#   comparison block given at instantiation time.
#
# AUTHOR:
#
#   - K.Kodama
#     Created original PQueue.rb.
#
#   - Ronald Butler
#     Created original Heap.rb.
#
#   - Olivier Renaud
#     Merged these two classes into this unique full-featured class.
#
# LICENSE:
#
#   Copyright (c) 2005 K.Kodama, Ronald Butler, Olivier Renaud
#
#   GNU General Public License
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or (at
#   your option) any later version.
#
#   This program is distributed in the hope that it will be useful, but
#   WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#   General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
# THANKS:
#
#   Rick Bradley 2003/02/02, patch for Ruby 1.6.5. Thank you!


# = PQueue
#
# Priority queue with array based heap.
#
# A priority queue is like a standard queue, except that each inserted
# elements is given a certain priority, based on the result of the
# comparison block given at instantiation time. Also, retrieving an element
# from the queue will always return the one with the highest priority
# (see #pop and #top).
#
# The default is to compare the elements in repect to their #> method.
# For example, Numeric elements with higher values will have higher
# priorities.


class PQueue

  # number of elements
  attr_reader :size
  # compare Proc
  attr_reader :gt
  attr_reader :qarray #:nodoc:
  protected :qarray

  # Returns a new priority queue.
  #
  # If elements are given, build the priority queue with these initial
  # values. The elements object must respond to #to_a.
  #
  # If a block is given, it will be used to determine the priority between
  # the elements.
  #
  # By default, the priority queue retrieves maximum elements first
  # (using the #> method).
  def initialize(elements=nil, &block) # :yields: a, b
    @qarray = [nil]
    @size = 0
    @gt = block || lambda {|a,b| a > b}
    replace(elements) if elements
  end

  private

  # Assumes that the tree is a heap, for nodes < k.
  #
  # The element at index k will go up until it finds its place.
  def upheap(k)
    k2 = k.div(2)
    v = @qarray[k]
    while k2 > 0 && @gt[v, @qarray[k2]]
      @qarray[k] = @qarray[k2]
      k = k2
      k2 = k2.div(2)
    end
    @qarray[k] = v
  end

  # Assumes the entire tree is a heap.
  #
  # The element at index k will go down until it finds its place.
  def downheap(k)
    v = @qarray[k]
    q2 = @size.div(2)
    loop {
      break if k > q2
      j = 2 * k
      if j < @size && @gt[@qarray[j+1], @qarray[j]]
        j += 1
      end
      break if @gt[v, @qarray[j]]
      @qarray[k] = @qarray[j]
      k = j
    }
    @qarray[k] = v;
  end


  # Recursive version of heapify. I kept the code, since it may be
  # easier to understand than the non-recursive one.
  #  def heapify
  #    @size.div(2).downto(1) {|i| h(i)}
  #  end
  #  def h(t)
  #    l = 2 * t
  #    r = l + 1
  #    hi = if r > @size || @gt[@qarray[l],@qarray[r]] then l else r end
  #    if @gt[@qarray[hi],@qarray[t]]
  #      @qarray[hi], @qarray[t] = @qarray[t], @qarray[hi]
  #      h(hi) if hi <= @size.div(2)
  #    end
  #  end

  # Make a heap out of an unordered array.
  def heapify
    @size.div(2).downto(1) do |t|
      begin
        l = 2 * t
        r = l + 1
        hi = if r > @size || @gt[@qarray[l],@qarray[r]] then l else r end
        if @gt[@qarray[hi],@qarray[t]]
          @qarray[hi], @qarray[t] = @qarray[t], @qarray[hi]
          if hi <= @size.div(2)
            t = hi
            redo
          end # if
        end #if
      end #begin
    end # downto
  end

  public

  # Add an element in the priority queue.
  #
  # The insertion time is O(log n), with n the size of the queue.
  def push(v)
    @size += 1
    @qarray[@size] = v
    upheap(@size)
    return self
  end

  alias :<< :push

  # Return the element with the highest priority and remove it from
  # the queue.
  #
  # The highest priority is determined by the block given at instanciation
  # time.
  #
  # The deletion time is O(log n), with n the size of the queue.
  #
  # Return nil if the queue is empty.
  def pop
    return nil if empty?
    res = @qarray[1]
    @qarray[1] = @qarray[@size]
    @size -= 1
    downheap(1)
    return res
  end

  # Return the element with the highest priority.
  def top
    return nil if empty?
    return @qarray[1]
  end

  # Add more than one element at the same time. See #push.
  #
  # The elements object must respond to #to_a, or to be a PQueue itself.
  def push_all(elements)
    if empty?
      if elements.kind_of?(PQueue)
        initialize_copy(elements)
      else
        replace(elements)
      end
    else
      if elements.kind_of?(PQueue)
        @qarray[@size + 1, elements.size] = elements.qarray[1..-1]
        elements.size.times{ @size += 1; upheap(@size)}
      else
        ary = elements.to_a
        @qarray[@size + 1, ary.size] = ary
        ary.size.times{ @size += 1; upheap(@size)}
      end
    end
    return self
  end

  alias :merge :push_all


  # Return top n-element as a sorted array.
  def pop_array(n=@size)
    ary = []
    n.times{ary.push(pop)}
    return ary
  end


  # True if there is no more elements left in the priority queue.
  def empty?
    return @size.zero?
  end

  # Remove all elements from the priority queue.
  def clear
    @qarray.replace([nil])
    @size = 0
    return self
  end

  # Replace the content of the heap by the new elements.
  #
  # The elements object must respond to #to_a, or to be a PQueue itself.
  def replace(elements)
    if elements.kind_of?(PQueue)
      initialize_copy(elements)
    else
      @qarray.replace([nil] + elements.to_a)
      @size = @qarray.size - 1
      heapify
    end
    return self
  end

  # Return a sorted array, with highest priority first.
  def to_a
    old_qarray = @qarray.dup
    old_size = @size
    res = pop_array
    @qarray = old_qarray
    @size = old_size
    return res
  end

  alias :sort :to_a

  # Replace the top element with the given one, and return this top element.
  #
  # Equivalent to successively calling #pop and #push(v).
  def replace_top(v)
    # replace top element
    if empty?
      @qarray[1] = v
      @size += 1
      return nil
    else
      res = @qarray[1]
      @qarray[1] = v
      downheap(1)
      return res
    end
  end

  # Return true if the given object is present in the queue.
  def include?(element)
    return @qarray.include?(element)
  end

  # Iterate over the ordered elements, destructively.
  def each_pop #:yields: popped
    until empty?
      yield pop
    end
    return nil
  end

  # Pretty print
  def inspect
    "<#{self.class}: size=#{@size}, top=#{top || "nil"}>"
  end

  ###########################
  ### Override Object methods

  # Return true if the queues contain equal elements.
  def ==(other)
    return size == other.size && to_a == other.to_a
  end

  private

  def initialize_copy(other)
    @gt = other.gt
    @qarray = other.qarray.dup
    @size = other.size
  end
end # class PQueue



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

=begin #test

  require 'test/unit'

  class TC_PQueue < Test::Unit::TestCase
    ARY_TEST = [2,6,1,3,8,15,0,-4,7,8,10]
    ARY_TEST_2 = [25,10,5,13,16,9,16,12]

    def test_initialize
      assert_nothing_raised { PQueue.new }
      assert_nothing_raised { PQueue.new([3]) }
      assert_nothing_raised { PQueue.new(ARY_TEST) }
      assert_nothing_raised { PQueue.new {|a,b| a<b} }
      assert_nothing_raised { PQueue.new([3]) {|a,b| a<b} }
      assert_nothing_raised { PQueue.new(ARY_TEST) {|a,b| a<b} }
    end

    def test_top
      assert_equal(ARY_TEST.max, PQueue.new(ARY_TEST).top)
      assert_nil(PQueue.new.top)
    end

    def test_pop
      sorted_ary = ARY_TEST.sort
      q = PQueue.new(ARY_TEST)
      ARY_TEST.size.times do
        assert_equal(sorted_ary.pop, q.pop)
      end
      assert_equal(0, q.size)
      assert_nil(PQueue.new.pop)
    end

    def test_insertion
      q = PQueue.new(ARY_TEST)
      assert_equal(ARY_TEST.size, q.size)

      ret = q.push(24)
      assert_equal(q, ret)
      assert_equal(ARY_TEST.size+1, q.size)

      ret = q.push_all(ARY_TEST_2)
      assert_equal(q, ret)
      assert_equal(ARY_TEST.size+1+ARY_TEST_2.size, q.size)

      q = PQueue.new(ARY_TEST)
      r = PQueue.new(ARY_TEST_2)
      q.push_all(r)
      assert_equal(ARY_TEST.size + ARY_TEST_2.size, q.size)
    end

    def test_clear
      q = PQueue.new(ARY_TEST).clear
      assert_equal(q, q.clear)
      assert_equal(0, q.size)
    end

    def test_replace
      q = PQueue.new(ARY_TEST)
      q.replace(ARY_TEST_2)
      assert_equal(ARY_TEST_2.size, q.size)

      q = PQueue.new(ARY_TEST)
      q.replace(PQueue.new(ARY_TEST_2))
      assert_equal(ARY_TEST_2.size, q.size)
    end

    def test_inspect
      assert_equal("<PQueue: size=#{ARY_TEST.size}, top=#{ARY_TEST.max}>",
                   PQueue.new(ARY_TEST).inspect)
    end

    def test_to_a
      q = PQueue.new(ARY_TEST)
      assert_equal(ARY_TEST.sort.reverse, q.sort)
      q = PQueue.new(0..4)
      assert_equal([4,3,2,1,0], q.sort)
    end

    def pop_array
      q = PQueue.new(ARY_TEST)
      assert_equal(ARY_TEST.sort.reverse[0..5], q.pop_array(5))
      q = PQueue.new(ARY_TEST)
      assert_equal(ARY_TEST.sort.reverse, q.pop_array)
    end

    def test_include
      q = PQueue.new(ARY_TEST + [21] + ARY_TEST_2)
      assert_equal(true, q.include?(21))

      q = PQueue.new(ARY_TEST - [15])
      assert_equal(false, q.include?(15))
    end

    def test_assert_equal
      assert_equal(PQueue.new, PQueue.new)
      assert_equal(PQueue.new(ARY_TEST), PQueue.new(ARY_TEST.sort_by{rand}))
    end

    def test_replace_top
      q = PQueue.new
      assert_nil(q.replace_top(6))
      assert_equal(6, q.top)

      q = PQueue.new(ARY_TEST)
      h = PQueue.new(ARY_TEST)
      q.pop; q.push(11)
      h.replace_top(11)
      assert_equal(q, h)
    end

    def test_dup
      q = PQueue.new(ARY_TEST)
      assert_equal(q, q.dup)
    end

    def test_array_copied
      ary = ARY_TEST.dup
      q = PQueue.new(ary)
      q.pop
      assert_equal(ARY_TEST, ary)

      ary = ARY_TEST.dup
      q = PQueue.new
      q.replace(ary)
      q.pop
      assert_equal(ARY_TEST, ary)

      ary = ARY_TEST.dup
      q = PQueue.new([1])
      q.push_all(ary)
      q.pop
      assert_equal(ARY_TEST, ary)

      q = PQueue.new(ARY_TEST)
      r = q.dup
      q.pop
      assert_not_equal(q, r)
    end
  end

=end

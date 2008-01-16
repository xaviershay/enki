# TITLE:
#
#   Indexable
#
# DESCRIPTION:
#
#   Mixin that works off of #index, #slice, #splice and #size.
#
#   These methods work in harmony. Where #index returns a
#   position of a given element, #slice returns elements
#   for given positions. #splice is like #slice but replaces
#   the given position with new values. This mehtod is not
#   part of ruby core, but it generally just an alias for #[]=,
#   just as #slice is an alias of #[]. #size of course simply
#   returns the total length of the indexable object.
#
# AUTHORS:
#
#   - Thomas Sawyer

# Indexable is a mixin that provides index based methods,
# working soley with four methods: #index, #slice, #splice
# and #size.
#
# These methods work in harmony. Where #index returns a
# position of a given element, #slice returns elements
# for given positions. #splice is like #slice but replaces
# the given position with new values. This mehtod is not
# part of ruby core, but it generally just an alias for #[]=,
# just as #slice is an alias of #[]. #size of course simply
# returns the total length of the indexable object.

module Indexable

  # Like #first but returns the first element
  # in a new array.
  #
  #   [1,2,3].head  #=> [1]

  def head
    slice(0,1)
  end

  # Returns an array from second element to last element.
  #
  #   [1,2,3].tail  #=> [2,3]

  def tail
    slice(1,length-1)
  end

  # Like #last, returning the last element
  # in an array.
  #
  #   [1,2,3].foot  #=> [3]

  def foot
    slice(-1,1)
  end

  # Returns an array of the first element upto,
  # but not including, the last element.
  #
  #   [1,2,3].body  #=> [1,2]
  #
  #--
  # Better name for this? (bulk, perhaps?)
  #++

  def body
    slice(0,size-1)
  end

  # Returns the middle element of an array, or the element offset
  # from middle if the parameter is given. Even-sized arrays,
  # not having an exact middle, return the middle-right element.
  #
  #   [1,2,3,4,5].mid        #=> 3
  #   [1,2,3,4,5,6].mid      #=> 4
  #   [1,2,3,4,5,6].mid(-1)  #=> 3
  #   [1,2,3,4,5,6].mid(-2)  #=> 2
  #   [1,2,3,4,5,6].mid(1)   #=> 5
  #
  # In other words, If there are an even number of elements the
  # higher-indexed of the two center elements is indexed as
  # orgin (0).

  def mid(offset=0)
    slice((size / 2) + offset)
  end

  # Returns the middle element(s) of an array. Even-sized arrays,
  # not having an exact middle, returns a two-element array
  # of the two middle elements.
  #
  #   [1,2,3,4,5].middle        #=> 3
  #   [1,2,3,4,5,6].middle      #=> [3,4]
  #
  # In contrast to #mid which utilizes an offset.

  def middle
    if size % 2 == 0
     slice( (size / 2) - 1, 2 )
     #[slice((size / 2) - 1, 1), slice(size / 2, 1)]
    else
      slice(size / 2)
    end
  end

  # Fetch values from a start index thru an end index.
  #
  #   [1,2,3,4,5].thru(0,2)  #=> [1,2,3]
  #   [1,2,3,4,5].thru(2,4)  #=> [3,4,5]

  def thru(from, to)
    a = []
    i = from
    while i <= to
      a << slice(i)
      i += 1
    end
    a
  end

  # Returns first _n_ elements.
  #
  #   "Hello World".first(3)  #=> "Hel"

  def first(n=1)
    slice(0, n.to_i)
  end

  # Returns last _n_ elements.
  #
  #   "Hello World".last(3)  #=> "rld"

  def last(n=1)
    n = n.to_i
    return self if n > size
    slice(-n, n) #slice(-n..-1)
  end

  # Change the first element.
  #
  #   a = ["a","y","z"]
  #   a.first = "x"
  #   p a           #=> ["x","y","z"]

  def first=(x)
    splice(0,x)
  end

  # Change the last element.
  #
  #   a = [1,2,5]
  #   a.last = 3
  #   p a           #=> [1,2,3]

  def last=(x)
    splice(-1,x)
  end

  # Remove and return the first element.
  #
  #   a = [1,2,3]
  #   a.first!      #=> 1
  #   a             #=> [2,3]

  def first!
    splice(0)
  end

  # Remove and return the last element.
  #
  #   a = [1,2,3]
  #   a.last!       #=> 3
  #   a             #=> [1,2]

  def last!
    splice(-1)
  end

  # A shorting of "ends at", returns the
  # last index of the indexable object.
  # Returns nil if there are no elements.
  #
  #   [1,2,3,4,5].ends  #=> 4
  #
  # This nearly equivalent to +size - 1+.

  def ends
    return nil if size == 0
    size - 1
  end

  # Returns the positive ordinal index given
  # a cardinal position, 1 to n or -n to -1.
  #
  #   [1,2,3,4,5].pos(1)   #=> 0
  #   [1,2,3,4,5].pos(-1)  #=> 4

  def pos(i)
    if i > 0
      return i - 1
    else
      size + i
    end
  end

  # Returns the index of the first element to satisfy the block
  # condition. This is simply #index with a block.
  #
  #   [1,2,3,4].index_of { |e| e == 3 }  #=> 2
  #   [1,2,3,4].index_of { |e| e > 3 }   #=> 3
  #
  # TODO: Remove Array#index_of when Ruby 1.9 adds block to #index.

  def index_of(obj=nil,&blk)
    return index(obj) unless block_given?
    i=0; i+=1 until yield(self[i])
    return i
  end

  # TODO Maybe #range could use a little error catch code (todo).

  # Returns the index range between two elements.
  # If no elements are given, returns the range
  # from first to last.
  #
  #   ['a','b','c','d'].range            #=> 0..3
  #   ['a','b','c','d'].range('b','d')   #=> 1..2

  def range(a=nil,z=nil)
    if !a
      0..(size-1)
    else
      index(a)..index(z)
    end
  end

end

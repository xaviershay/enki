class Integer
  # This is needed to allow Integer to look back to
  # its Numeric ancestor for the new definition of #succ.

  remove_method( :succ )
end

module Comparable
  # Alternate name for comparison operator #<=>.
  #
  #   3.cmp(1)   #=>  1
  #   3.cmp(3)   #=>  0
  #   3.cmp(10)  #=> -1
  #
  # This fundamental compare method is used to keep
  # comparison compatible with <tt>#succ</tt>.
  #
  #   CREDIT Peter Vanbroekhoven

  def cmp(o)
    self<=>o
  end
end

class String    # Compare method that takes length into account.

  # Compare method that takes length into account.
  # Unlike #<=>, this is compatible with #succ.
  #
  #   "abc".cmp("abc")   #=>  0
  #   "abcd".cmp("abc")  #=>  1
  #   "abc".cmp("abcd")  #=> -1
  #   "xyz".cmp("abc")   #=>  1
  #
  #   CREDIT Peter Vanbroekhoven

  def cmp(other)
    return -1 if length < other.length
    return 1 if length > other.length
    self <=> other  # alphabetic compare
  end

  # Allows #succ to take _n_ step increments.
  #
  #   "abc".succ      #=> "abd"
  #   "abc".succ(4)   #=> "abg"
  #   "abc".succ(24)  #=> "aca"
  #
  #   CREDIT Trans

  def succ(n=1)
    s = self
    n.times { s = s.next }
    s
  end
end

class Numeric
  # Returns the distance between self an another value.
  # This is the same as #- but it provides an alternative
  # for common naming between variant classes.
  #
  #   4.distance(3)  #=> 1
  #
  #   CREDIT Trans

  def distance(other)
    self - other
  end

  # Allows #succ to take _n_ increments.
  #
  #   3.succ(2)  #=> 5
  #
  #   CREDIT Trans

  def succ(n=nil)
    n ||= 1
    self + n
  end

  # Provides #pred as the opposite of #succ.
  #
  #   3.pred(2)  #=> 1
  #
  #   CREDIT Trans

  def pred(n=nil)
    n ||= 1
    self - n
  end
end

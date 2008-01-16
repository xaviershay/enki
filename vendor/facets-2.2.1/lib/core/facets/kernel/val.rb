module Kernel

  # Tests to see if something has value. An object
  # is considered to have value if it is not nil?
  # and if it responds to #empty?, is not empty.
  #
  #   nil.val?     #=> false
  #   [].val?      #=> false
  #   10.val?      #=> true
  #   [nil].val?   #=> true

  def val?
    return false if nil?
    return false if empty? if respond_to?(:empty?)
    true
  end

  # The opposite of #nil?.
  #
  #   "hello".not_nil?     # -> true
  #   nil.not_nil?         # -> false
  #
  #   CREDIT: Gavin Sinclair

  def not_nil?
    not nil?
  end

  alias_method :non_nil?, :not_nil?

  # Is self included in other?
  #
  #   5.in?(0..10)       #=> true
  #   5.in?([0,1,2,3])   #=> false
  #
  def in?(other)
    other.include?(self)
  end

end

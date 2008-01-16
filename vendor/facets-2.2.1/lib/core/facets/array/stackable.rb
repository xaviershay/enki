require 'facets/array/splice'
require 'facets/stackable'

class Array
  include Stackable

  # "Put On Top". This is an alias for unshift
  # which puts an object# on top of the stack.
  # It is the converse of push.
  #
  #  a=[1,2,3]
  #  a.poke(9)   #=> [9,1,2,3]
  #  a           #=> [9,1,2,3]
  #
  #   CREDIT: Trans

  alias_method :poke, :unshift

  # Alias for shift which removes an object
  # off first slot of an array. This is
  # the contrary of pop.
  #
  #   a=[1,2,3]
  #   a.pull  #=> 1
  #   a       #=> [2,3]
  #
  #   CREDIT: Trans

  alias_method :pull, :shift
end

# = TITLE:
#
#   Stackable
#
# = DESCRIPTION:
#
#   Stackable mixin provides #pop, #push, #pull, etc.
#   It depends on #slice, #splice and #insert.
#
# = COPYRIGHT:
#
#   Copyright (c) 2007 Thomas Sawyer
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
# = AUTHORS:
#
#   - Thomas Sawyer

# Stackable mixin provides #pop, #push, #pull, etc.
# It depends on #slice, #splice and #insert.

module Stackable

  # Pop item off stack.
  #
  #   a = [1, 2, 3]
  #   a.pop           #=> 3
  #   a               #=> [1, 2]

  def pop
    splice(-1)
  end

  # Push item onto the stack.
  #
  #   a = [1, 2]
  #   a.push(3)       #=> [1, 2, 3]

  def push(x)
    insert(-1,x)
  end

  # Pull item off the stack.
  #
  #   a = [1, 2, 3]
  #   a.pull          #=> 1
  #   a               #=> [2, 3]

  def pull
    slice(0)
  end

  alias_method :shift, :pull

  # Poke item onto the stack.
  #
  #   a = [2, 3]
  #   a.poke(1)       #=> [1, 2, 3]
  #
  #   TODO: Better name (besides unshift)?

  def poke(x)
    insert(0,x)
  end

  alias_method :unshift, :poke

  # Peek at the top of the stack.
  #
  #   a = [1, 2, 3]
  #   a.peek          #=> 3
  #   a               #=> [1, 2, 3]

  def peek
    splice(-1)
  end

end

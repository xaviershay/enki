# TITLE:
#  Functor
#
# COPYRIGHT:
#   Copyright (c) 2004 Thomas Sawyer
#
# LICENSE:
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
#   - Thomas Sawyer
#
# LOG:
#   - 2006-11-04 trans Deprecated #self. Call #self on the #binding instead.
#   - 2006-11-04 trans Deprecated #functor_function, renamed to #to_proc.
#   - 2006-11-04 trans All methods are now private except #binding and operators.
#
# TODO:
#   - Consider renaming Functor to Dispatch or Dispatcher ?

# = Functor
#
# By definition a Functor is simply a first class method, but these are common
# in the form of Method and Proc. So for Ruby a Functor is a bit more specialized
# as a 1st class _metafunction_. Essentally, a Functor can vary its behavior
# accorrding to the operation applied to it.
#
# == Synopsis
#
#   f = Functor.new { |op, x| x.send(op, x) }
#   f + 1  #=> 2
#   f + 2  #=> 4
#   f + 3  #=> 6
#   f * 1  #=> 1
#   f * 2  #=> 4
#   f * 3  #=> 9
#

class Functor

  # Privatize all methods except vital methods, #binding and operators.
  private(*instance_methods.select { |m| m !~ /(^__|^\W|^binding$)/ })

  def initialize(&function)
    @function = function
  end

  def to_proc
    @function
  end

  # Any action against the functor is processesd by the function.
  def method_missing(op, *args, &blk)
    @function.call(op, *args, &blk)
  end

end

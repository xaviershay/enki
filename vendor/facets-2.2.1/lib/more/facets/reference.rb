# TITLE:
#
#   Reference
#
# SUMMARY:
#
#   Reference provides a way to access object indirectly.
#   This allows for the object itself to be changed on the fly.
#
# COPYRIGHT:
#
#   Copyright (c) 2005 Thomas Sawyer
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


# = Reference
#
# Reference provides a way to access object indirectly.
# This allows for the object itself to be changed on the fly.
#
# == Synopsis
#
#   a = "HELLO"
#   b = ref(a)
#   puts b    #=> "HELLO"
#   c = 10
#   b.become(c)
#   puts b    #=> "10"
#

class Reference

  # Privatize most Kernel methods.

  private *instance_methods

  def self.new(obj)
    ref = allocate
    ref.become obj
    ref
  end

  def method_missing(*args, &block)
    @ref.__send__(*args, &block)
  end

  def become(obj)
    old = @ref
    @ref = obj
    old
  end

  def __value__
    @ref
  end

  alias_method :instance_delegate, :__value__
end


module Kernel

  # Shortcut reference constructor.

  def ref(x)
    Reference.new(x)
  end

end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

=begin #test

  require 'test/unit'

  # TODO

=end

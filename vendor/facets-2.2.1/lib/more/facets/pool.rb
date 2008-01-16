# TITLE:
#
#   Pool
#
# DESCRIPTION:
#
#   Generalized object pool implementation. Implemented as a thread
#   safe stack. Exclusive locking is needed both for push and pop.
#
# AUTHOR:
#
#   - George Moschovitis
#
# LICENSE:
#
#   Copyright (c) 2004 George Moschovitis
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
# TODO:
#
#   - Could use the SizedQueue/Queue ?
#


require 'thread'
require 'monitor'

# = Pool
#
# Generalized object pool implementation. Implemented as a thread
# safe stack. Exclusive locking is needed both for push and pop.

class Pool < Array

  include MonitorMixin

  def initialize
    super
    @cv = new_cond()
  end

  # Add, restore an object to the pool.

  def push(obj)
    synchronize do
      super
      @cv.signal()
    end
  end

  # Obtain an object from the pool.

  def pop
    synchronize do
      @cv.wait_while { empty? }
      super
    end
  end

  # Obtains an object, passes it to a block for processing
  # and restores it to the pool.

  def obtain
    result = nil
    begin
      obj = pop()
      result = yield(obj)
    ensure
      push(obj)
    end
    return result
  end

end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

# TODO

=begin #testing

=end

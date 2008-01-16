# TITLE:
#
#   Semaphore
#
# SUMMARY:
#
#   Technically a semaphore is simply an integer variable which
#   has an execution queue associated with it.
#
# COPYRIGHT:
#
#   Copyright (c) 2005 Fukumoto
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
#   - Fukumoto


# = Semaphore
#
# Technically a semaphore is simply an integer variable which
# has an execution queue associated with it.
class Semaphore

  def initialize(initvalue = 0)
    @counter = initvalue
    @waiting_list = []
  end

  def wait
    Thread.critical = true
    if (@counter -= 1) < 0
      @waiting_list.push(Thread.current)
      Thread.stop
    end
    self
  ensure
    Thread.critical = false
  end

  def signal
    Thread.critical = true
    begin
      if (@counter += 1) <= 0
        t = @waiting_list.shift
        t.wakeup if t
      end
    rescue ThreadError
      retry
    end
    self
  ensure
    Thread.critical = false
  end

  alias_method( :down, :wait )
  alias_method( :up,   :signal )
  alias_method( :p,    :wait )
  alias_method( :v,    :signal )

  def exclusive
    wait
    yield
  ensure
    signal
  end

  alias_method( :synchronize, :exclusive )

end


#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

# TODO

=begin #test

  require 'test/unit'

=end

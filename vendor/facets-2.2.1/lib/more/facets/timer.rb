# TITLE:
#
#   Timer
#
# SUMMARY:
#
#   Read from one object and write to another.
#
# COPYRIGHT:
#
#   Copyright (c) 2004 Thomas Sawyer
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
# HISTORY:
#
#   Thanks to Paul Brannan for TimeLimit and Minero Aoki for Timer.
#   These two libraries served as models for building this class.
#
# AUTHORS:
#
#   - Thomas Sawyer
#   - Minero Aoki
#   - Paul Brannan

require 'timeout'  # for TimeoutError

# = Timer
#
# Provides a strightforward means for controlling time critical execution.
# Can be used as a "stop watch" timer or as a "time bomb" timer.
#
# == Usage
#
#   t = Timer.new(10) { raise TimeoutError, "timeout!" }
#   t.start
#     :      # done within 10sec timeout
#   t.stop
#   t.start
#     :
#   if condition then
#     t.reset       #--> restart timer
#   end
#
# A Kernel method is also provided for easily timing the exectuion of a block.
#
#   timed { |timer|
#
#      timer.total_time.round #=> 0
#
#      sleep 1
#      timer.total_time.round #=> 1
#
#      timer.stop
#      timer.total_time.round #=> 1
#
#      sleep 2
#      timer.total_time.round #=> 1
#
#      timer.start
#      timer.total_time.round #=> 1
#
#      sleep 1
#      timer.total_time.round #=> 2
#
#   }
#

class Timer

  attr_reader :start_time, :end_time
  attr_accessor :time_limit

  def initialize( time_limit=nil, &block )
    # standard timer
    @start_time = nil
    @end_time = nil
    @total_time = 0
    @runnning = nil
    # for using time limit
    @time_limit = time_limit
    @on_timeout = block
    @current_thread = nil
    @timer_thread = nil
  end

  def on_timeout( &block )
    if block then
      @on_timeout = block
      true
    else
      false
    end
  end

  # Start the timer.

  def start
    @running = true
    @start_time = Time.now

    limit if @time_limit

    self

    #if block_given? then
    #  begin
    #    yield( self )
    #  ensure
    #    stop
    #  end
    #else
    #  @time_limit
    #end
  end

  # Establish a time limit on execution.

  def limit( time_limit=nil )
    if @time_limit || time_limit
      @current_thread = Thread.current
      @timer_thread = Thread.fork {
        sleep @time_limit
        if @on_timeout then
          @on_timeout.call @time_limit
        else
          @current_thread.raise TimeoutError, "#{@time_limit} seconds past"
        end
      }
    end
  end

  # Kill time limit thread, if any.

  def defuse
    if @timer_thread
      Thread.kill @timer_thread
      @timer_thread = nil
    end
  end

  # Stops timer and returns total time.
  # If timer was not running returns false.

  def stop
    if @running
      defuse
      # record running time
      @end_time = Time.now
      @running = false
      @total_time += (@end_time - @start_time)
    else
      nil
    end
  end

  # Stops and resets the timer. If the timer was running
  # returns the total time. If not returns 0.

  def reset
    if running?
      r = stop
    else
      r = 0
    end
    @total_time = 0
    return r
  end

  # Resets the time limit. Same as:
  #
  #   t.stop
  #   t.start
  #

  def reset_limit
    #stop
    #start
    defuse
    limit
  end

  # Queries whether the timer is still running.

  def running?
    return @running
  end

  # Queries whether the timer is still not running.

  def stopped?
    return !@running
  end

  # Queries total recorded time of timer.

  def total_time
    if running? then
      return @total_time + (Time.now - @start_time)
    else
      return @total_time
    end
  end

  #
  # Timer::Dummy - Dummy Timer (i.e. no real time limit)
  #--
  # NEEDS WORK!
  #++

  class Dummy < self
    def start
      if block_given? then
        yield
      else
        time_limit()
      end
    end

    def stop
      false
    end
  end #class Dummy

end #class Timer


module Kernel

  # Takes a block and returns the total time it took to execute.

  def timed
    yield( timer = Timer.new.start )
    return timer.total_time
  end

end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

=begin test

require 'test/unit'

class TC_Timer < Test::Unit::TestCase

  def test_timed
    timed { |timer|
      assert_equal 0, timer.total_time.round
      sleep 1
      assert_equal 1, timer.total_time.round
      timer.stop
      assert_equal 1, timer.total_time.round
      sleep 1
      assert_equal 1, timer.total_time.round
      timer.start
      assert_equal 1, timer.total_time.round
      sleep 1
      assert_equal 2, timer.total_time.round
    }
  end

  def test_outoftime
    t = Timer.new(1)
    assert_raises( TimeoutError ) {
      t.start
      sleep 2
      t.stop
    }
  end

  # This has been removed becuase it is too close to call.
  # Sometimes and error is returned sometimes it is not.
  #def test_nickoftime
  #  assert_raises( TimeoutError ) {
  #    @t.start
  #    sleep 2
  #    @t.stop
  #  }
  #end

  def test_intime
    t = Timer.new(2)
    assert_nothing_raised {
      t.start
      sleep 1
      t.stop
    }
  end

end

=end

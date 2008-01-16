# TITLE:
#
#   Coroutine
#
# SUMMARY:
#
#   This mixin solely depends on method read(n), which must be
#   defined in the class/module where you mix in this module.
#
# COPYRIGHT:
#
#   Copyright (c) 2005 Florian Frank
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
#   - Florian Frank


# = Coroutine
#
# Coroutines are program components like subroutines. Coroutines are more
# generic and flexible than subroutines, but are less widely used in
# practice. Coroutines were first introduced natively in Simula.
# Coroutines are well suited for implementing more familiar program
# components such as cooperative tasks, iterators, infinite lists, and pipes.
#
# == Usage
#
#   count = (ARGV.shift || 1000).to_i
#   input = (1..count).map { (rand * 10000).round.to_f / 100}
#
#   Producer = Coroutine.new do |me|
#     loop do
#       1.upto(6) do
#         me[:last_input] = input.shift
#         me.resume(Printer)
#       end
#       input.shift # discard every seventh input number
#     end
#   end
#   Printer = Coroutine.new do |me|
#     loop do
#       1.upto(8) do
#         me.resume(Producer)
#         if Producer[:last_input]
#           print Producer[:last_input], "\t"
#           Producer[:last_input] = nil
#         end
#         me.resume(Controller)
#       end
#       puts
#     end
#   end
#
#   Controller = Coroutine.new do |me|
#     until input.empty? do
#       me.resume(Printer)
#     end
#   end
#
#   Controller.run
#

class Coroutine

  def initialize(data = {})
    @data = data
    callcc do |@continue|
      return
    end
    yield self
    stop
  end

  attr_reader :stopped

  def run
    callcc do |@stopped|
      continue
    end
  end

  def stop
    @stopped.call
  end

  def resume(other)
    callcc do |@continue|
      other.continue(self)
    end
  end

  def continue(from = nil)
    @stopped = from.stopped if not @stopped and from
    @continue.call
  end

  def [](name)
    @data[name]
  end

  def []=(name, value)
    @data[name] = value
  end

  protected :stopped, :continue

end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

=begin testing

  require 'test/unit'

  class TC_Coroutine < Test::Unit::TestCase

    def test_run
      assert_nothing_raised {

        count = 100
        input = (1..count).map { (rand * 10000).round.to_f / 100 }

        @producer = Coroutine.new do |me|
          loop do
            1.upto(6) do
              me[:last_input] = input.shift
              me.resume(@printer)
            end
            input.shift  # discard every seventh input number
          end
        end

        @printer = Coroutine.new do |me|
          loop do
            1.upto(8) do
              me.resume(@producer)
              if @producer[:last_input]
                @producer[:last_input] = nil
              end
              me.resume(@controller)
            end
          end
        end

        @controller = Coroutine.new do |me|
          until input.empty? do
            me.resume(@printer)
          end
        end
        @controller.run

      }
    end

  end

=end

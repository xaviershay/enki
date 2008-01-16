# TITLE:
#
#  Event Hook
#
# SUMMARY:
#
#   Provides an Event Hooks system designed on top of
#   Ruby's built-in Exception system.
##
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
# AUTHORS:
#
#   - Thomas Sawyer


# =  Exception-based Event Hooks
#
# Provides an Event Hooks system designed on top of
# Ruby's built-in Exception system.
#
# == Example
#
#   def dothis2
#     puts 'pre'
#     hook :quitit
#     puts 'post'
#   end
#
#   def tryit2
#     begin
#       puts "BEFORE"
#       dothis2
#       puts "AFTER"
#     rescue EventHook
#       event :quitit do
#         puts "HERE"
#       end
#     end
#   end
#
#   tryit2
#

class EventHook < Exception
  attr_reader :name, :cc
  def initialize(name, cc)
    @name = name
    @cc = cc
  end
  def call
    @cc.call
  end
end

module Kernel
  def hook(sym)
    callcc{ |c| raise EventHook.new(sym, c) }
  end
  def event(sym)
    if $!.name == sym
      yield
      $!.call
    end
  end
end


#
# Test
#

=begin

  require 'test/unit'

  class TestEventHook < Test::Unit::TestCase

    class T
      attr_reader :a
      def dothis
        @a << '{'
        hook :here
        @a << '}'
      end
      def tryit
        @a = ''
        begin
          @a << "["
          dothis
          @a << "]"
        rescue EventHook
          event :here do
            @a << "HERE"
          end
        end
      end
    end

    def test_run
      t = T.new
      t.tryit
      assert_equal('[{HERE}]', t.a)
    end

  end

=end

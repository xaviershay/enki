# TITLE:
#
#   SyncArray
#
# SUMMARY:
#
#   A thread-safe array. We use a sync object instead of a
#   mutex, because it is re-entrant. An exclusive lock is
#   needed when writing, a shared lock IS NEEDED when reading.
#
# COPYRIGHT:
#
#   Copyright (c) 2004 George Moschovitis
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
#   - George Moschovitis


require 'sync'


# = SyncArray
#
# A thread-safe array. We use a sync object instead of a
# mutex, because it is re-entrant. An exclusive lock is
# needed when writing, a shared lock IS NEEDED when reading.

class Array

  def self.mutable_methods
    @mutable ||= %w{ << []= abbrev clear collect! compact! concat
      delete delete_at delete_if fill flatten insert map! pop push
      reject! replace reverse! shift slice! sort! transpose uniq!
      unshift
    }
  end

end

class SyncArray < Array

  attr :sync

  #
  # gmosx: delegator is not yet used.
  #
  def initialize(delegator = nil)
    @sync = ::Sync.new()
    super()
  end

  instance_methods.each do |m|
    next if Object.instance_methods.include?(m)
    if mutable_methods.include?(m)
      sync_type = "Sync::EX"
    else
      sync_type = "Sync::SH"
    end
    class_eval %{
      def #{m}(*args)
        return @sync.synchronize(#{sync_type}) { super }
      end
    }
  end

#  def << (value)
#    return @sync.synchronize(Sync::SH) { super }
#  end
#
#  def delete_if(&block)
#    return @sync.synchronize(Sync::SH) { super }
#  end
#
#  def [](key)
#    return @sync.synchronize(Sync::SH) { super }
#  end
#
#  def []=(key, value)
#    return @sync.synchronize(Sync::EX) { super }
#  end
#
#  def delete(key)
#    return @sync.synchronize(Sync::EX) { super }
#  end
#
#  def clear
#    @sync.synchronize(Sync::EX) { super }
#  end
#
#  def size
#    return @sync.synchronize(Sync::SH) { super }
#  end
#
#  def shift
#    return @sync.synchronize(::Sync::EX) { super }
#  end
#
#  def unshift(el)
#    return @sync.synchronize(::Sync::EX) { super }
#  end

end

#--
# Funniest thing, remove the :: in front of Sync.new in the initialize
# routine and uncomment the alias line below and watch the stack blow chunks.
# I'm leaving this comment here as a reminder.
### Array::Sync = SyncArray
#++



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

=begin testing

require 'test/unit'

# TODO

class TC_SyncArray < Test::Unit::TestCase

  def test_01
    assert_nothing_raised{ @s = SyncArray.new }
  end

end

=end

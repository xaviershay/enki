# TITLE:
#
#   LRUCache
#
# DESCRIPTION:
#
#   A cache utilizing a simple LRU (Least Recently Used) policy.
#
# AUTHORS:
#
#   - George Moschovitis
#   - Anastasios Koutoumanos
#
# LICENSE:
#
#   Copyright 2004 George Moschovitis, Anastasios Koutoumanos
#
#   Ruby License
#
#   This module is free software. You may use, modify, and/or redistribute this
#   software under the same terms as Ruby.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
#   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#   FOR A PARTICULAR PURPOSE.


# = LRUCache
#
# A cache utilizing a simple LRU (Least Recently Used) policy.
# The items managed by this cache must respond to the #key method.
# Attempts to optimize reads rather than inserts!
#
# LRU semantics are enforced by inserting the items in a queue.
# The lru item is always at the tail. Two special sentinels
# (head, tail) are used to simplify (?) the code.
#
class LRUCache < Hash

  # Mix this in your class to make LRU-managable.

  module Item
    attr_accessor :lru_key, :lru_prev, :lru_next
  end

  # head-tail sentinels

  class Sentinel; include Item; end

  # the maximum number of items in the cache.

  attr_accessor :max_items

  # the head sentinel and the tail sentinel, tail.prev points to the lru item.

  attr_reader :head, :tail

  def initialize(max_items)
    @max_items = max_items
    lru_clear()
  end

  # Lookup an item in the cache.

  def [](key)
    if item = super
      return lru_touch(item)
    end
  end

  # The inserted item is considered mru!

  def []=(key, item)
    item = super
    item.lru_key = key
    lru_insert(item)
  end

  # Delete an item from the cache.

  def delete(key)
    if item = super
      lru_delete(item)
    end
  end

  # Clear the cache.

  def clear
    super
    lru_clear()
  end

  # The first (mru) element in the cache.

  def first
    @head.lru_next
  end

  # The last (lru) element in the cache.

  def last
    @tail.lru_prev
  end
  alias_method :lru, :last

  private

  # Delete an item from the lru list.

  def lru_delete(item)
    lru_join(item.lru_prev, item.lru_next)
    return item
  end

  # Join two items in the lru list.
  # Return y to allow for chaining.

  def lru_join(x, y)
    x.lru_next = y
    y.lru_prev = x
    return y
  end

  # Append a child item to a parent item in the lru list
  # (Re)inserts the child in the list.

  def lru_append(parent, child)
    lru_join(child, parent.lru_next)
    lru_join(parent, child)
  end

  # Insert an item

  def lru_insert(item)
    delete(last.lru_key) if size() > @max_items
    lru_append(@head, item)
  end

  # Touch an item, make mru!
  # Returns the item.

  def lru_touch(item)
    lru_append(@head, lru_delete(item))
  end

  # Clear the lru.

  def lru_clear
    @head = Sentinel.new
    @tail = Sentinel.new
    lru_join(@head, @tail)
  end

end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

# TODO

=begin testing

  require 'test/unit'

  class TC_LRUCache < Test::Unit::TestCase

    def test_01
    end

  end

=end

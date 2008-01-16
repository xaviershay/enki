# TITLE:
#
#   LinkedList
#
# DESCRIPTION:
#
#   LinkedList implements a simple doubly linked list with efficient
#   hash-like element access.
#
# AUTHOR:
#
#   - Kirk Haines <khaines@enigo.com>.
#     LinkedList was ported from the original in Kirk Hanes IOWA web framework.
#
# LICENSE:
#
#   Copyright (C) 2006 Kirk Haines
#
#   General Public License (GPL)
#
#   Permission is hereby granted, free of charge, to any person obtaining
#   a copy of this software and associated documentation files (the
#   "Software"), to deal in the Software without restriction, including
#   without limitation the rights to use, copy, modify, merge, publish,
#   distribute, sublicense, and/or sell copies of the Software, and to
#   permit persons to whom the Software is furnished to do so, subject to
#   the following conditions:
#
#   The above copyright notice and this permission notice shall be
#   included in all copies or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#   NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
#   LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
#   OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
#   WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# TODO:
#
#   - Create an example of usage for docs.


require 'enumerator'

# == LinkedList
#
# LinkedList implements a simple doubly linked list with efficient
# hash-like element access.
#
# This is a simple linked list implementation with efficient random
# access of data elements.  It was inspired by George Moscovitis'
# LRUCache implementation found in Facets 1.7.30, but unlike the
# linked list in that cache, this one does not require the use of a
# mixin on any class to be stored.  The linked list provides the
# push, pop, shift, unshift, first, last, delete and length methods
# which work just like their namesakes in the Array class, but it
# also supports setting and retrieving values by key, just like a
# hash.

class LinkedList

        include Enumerable

        # Represents a single node of the linked list.

        class Node
                attr_accessor :key, :value, :prev_node, :next_node

                def initialize(key=nil,value=nil,prev_node=nil,next_node=nil)
                        @key = key
                        @value = value
                        @prev_node = prev_node
                        @next_node = next_node
                end
        end

        def initialize
                @head = Node.new
                @tail = Node.new
                @lookup = Hash.new
                node_join(@head,@tail)
        end

        def [](v)
                @lookup[v].value
        end

        def []=(k,v)
                if @lookup.has_key?(k)
                        @lookup[k].value = v
                else
                        n = Node.new(k,v,@head,@head.next_node)
                        node_join(n,@head.next_node)
                        node_join(@head,n)
                        @lookup[k] = n
                end
                v
        end

        def empty?
                @lookup.empty?
        end

        def delete(k)
                n = @lookup.delete(k)
                v = n ? node_purge(n) : nil
                v
        end

        def first
                @head.next_node.value
        end

        def last
                @tail.prev_node.value
        end

        def shift
                k = @head.next_node.key
                n = @lookup.delete(k)
                node_delete(n) if n
        end

        def unshift(v)
                if @lookup.has_key?(v)
                        n = @lookup[v]
                        node_delete(n)
                        node_join(n,@head.next_node)
                        node_join(@head,n)
                else
                        n = Node.new(v,v,@head,@head.next_node)
                        node_join(n,@head.next_node)
                        node_join(@head,n)
                        @lookup[v] = n
                end
                v
        end

        def pop
                k = @tail.prev_node.key
                n = @lookup.delete(k)
                node_delete(n) if n
        end

        def push(v)
                if @lookup.has_key?(v)
                        n = @lookup[v]
                        node_delete(n)
                        node_join(@tail.prev_node,n)
                        node_join(n,@tail)
                else
                        n = Node.new(v,v,@tail.prev_node,@tail)
                        node_join(@tail.prev_node,n)
                        node_join(n,@tail)
                        @lookup[v] = n
                end
                v
        end

        def queue
                r = []
                n = @head
                while (n = n.next_node) and n != @tail
                        r << n.key
                end
                r
        end

        def to_a
                r = []
                n = @head
                while (n = n.next_node) and n != @tail
                        r << n.value
                end
                r
        end

        def length
                @lookup.length
        end

        def each
                n = @head
                while (n = n.next_node) and n != @tail
                        yield(n.key,n.value)
                end
        end

        private

        def node_delete(n)
                node_join(n.prev_node,n.next_node)
                v = n.value
        end

        def node_purge(n)
                node_join(n.prev_node,n.next_node)
                v = n.value
                n.value = nil
                n.key = nil
                n.next_node = nil
                n.prev_node = nil
                v
        end

        def node_join(a,b)
                a.next_node = b
                b.prev_node = a
        end

end



=begin test

  require 'test/unit'

  class TC_LinkedList < Test::Unit::TestCase

      @cache

      def test_all
          ll = nil
          assert_nothing_raised('Failed while creating an LinkedList object.') { ll = LinkedList.new }
          assert_kind_of(LinkedList,ll,'Strangely, the created object does not appear to be an LinkedList.')

          assert_nothing_raised('Failed while pushing a value onto the linked list.') { ll.push 'a' }
          ll.push 'b'
          assert_nothing_raised('Failed while assigning a key/value to the linked list.') { ll['c'] = 3 }
          assert_equal(3,ll.first, 'First element in the linked list appears to be the wrong one.')
          assert_equal('b',ll.last, 'Last element in the linked list appears to be the wrong one.')
          assert_nothing_raised('Failed while unshifting a value onto the linked list.') { ll.unshift 'd' }
          assert_equal('d',ll.first, 'The prior unshift apparently failed.')
          assert_equal('a',ll['a'], 'Accessing an element by key failed.')
          assert_equal(4,ll.length, 'The length of the linked list appears to be incorrect.')
          d = nil
          assert_nothing_raised('Failed while deleting an element from the middle of the list.') { d = ll.delete('a') }
          assert_equal('a',d, 'The prior delete returned the wrong value for the deleted object.')
          assert_equal(3,ll.length, 'The length of the linked list appears to be incorrect following the prior deletion.')
          assert_nothing_raised('Failed while popping an element from the end of the list.') { d = ll.pop }
          assert_equal('b',d, 'The prior pop returned the wrong value.')
          assert_equal(2,ll.length, 'The length of the linked list appears to be incorrect following the prior pop.')
          assert_equal(['d','c'],ll.queue, 'The queue of keys for the list is incorrect.')
          assert_equal(['d',3],ll.to_a, 'Converting the list to an array (of values) seems to have failed.')
          expected = [['c',3],['d','d']]
          ll.each do |k,v|
              e = expected.pop
              assert_equal(e,[k,v], 'While iterates over the list via each(), the value from this iteration is not what was expected.')
          end
      end
  end

=end

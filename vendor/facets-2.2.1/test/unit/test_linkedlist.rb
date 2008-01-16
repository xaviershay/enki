# Test lib/facets/linkedlist.rb

require 'facets/linkedlist.rb'
require 'test/unit'

class TC_LinkedList < Test::Unit::TestCase

  @cache #?

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


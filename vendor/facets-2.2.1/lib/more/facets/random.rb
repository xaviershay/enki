# TITLE:
#
#   Random
#
# DESCRIPTION:
#
#   Randomization methods.
#
# COPYRIGHT:
#
#   Copyright (c) 2005 Ilmari Heikkinen, Christian Neukirchen, Thomas Sawyer
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
#   - Ilmari Heikkinen <mailto:kig@misfiring.net>
#   - Christian Neukirchen <mailto:chneukirchen@gmail.com>
#   - Thomas Sawyer

require 'facets/hash/zipnew' # for zipnew
require 'facets/string/scan' # for shatter

module Kernel

  # Random generator that returns true or false.
  # Can also take a block that has a 50/50 chance to being executed.
  #
  #   maybe  #=> true
  #   maybe  #=> false
  #
  def maybe(chance = 0.5, &block)
    if block then
      yield if rand < chance
    else
      rand < chance
    end
  end

end


class Array

  # Return a random element of the array.
  #
  #   [1, 2, 3, 4].at_rand           #=> 2
  #   [1, 2, 3, 4].at_rand           #=> 4
  #
  def at_rand
    self.at( rand( size ) )
  end

  # Same as #at_rand, but acts in place removing a
  # random element from the array.
  #
  #   a = [1,2,3,4]
  #   a.at_rand!       #=> 2
  #   a                #=> [1,3,4]
  #
  def at_rand!
    return delete_at( Kernel.rand( size ) )
  end

  # Similar to #at_rand, but will return an array of randomly
  # picked exclusive elements if given a number.
  def pick(n=nil)
    if n
      a = self.dup
      a.pick!(n)
    else
      at( Kernel.rand( size ) )
    end
  end

  # Similar to #at_rand!, but given a number will return
  # an array of exclusive elements.
  def pick!(n=nil)
    if n
      if n > self.size
        r = self.dup
        self.replace([])
        r
      else
        r = []
        n.times { r << delete_at( Kernel.rand( size ) ) }
        r
      end
    else
      delete_at( Kernel.rand( size ) )
    end
  end

  # Random index.
  #
  def rand_index
    rand( size )
  end

  # Returns a random subset of an Array. If a _number_
  # of elements is specified then returns that number of
  # elements, otherwise returns a random number of elements
  # upto the size of the Array.
  #
  # By defualt the returned values are exclusive of
  # each other, but if _exclusive_ is set to <tt>false</tt>,
  # the same values can be choosen more than once.
  #
  # When _exclusive_ is <tt>true</tt> (the default) and the
  # _number_ given is greater than the size of the array,
  # then all values are returned.
  #
  #   [1, 2, 3, 4].rand_subset(1)        #=> [2]
  #   [1, 2, 3, 4].rand_subset(4)        #=> [2, 1, 3, 4]
  #   [1, 2, 3, 4].rand_subset           #=> [1, 3, 4]
  #   [1, 2, 3, 4].rand_subset           #=> [2, 3]
  #
  def rand_subset( number=nil, exclusive=true )
    number = rand( size ) unless number
    number = number.to_int
    #return self.dup if (number >= size and exlusive)
    return sort_by{rand}.slice(0,number) if exclusive
    ri =[]; number.times { |n| ri << rand( size ) }
    return values_at(*ri)
  end

  # Randomize the order of an array.
  #
  #   [1,2,3,4].shuffle  #=> [2,4,1,3]
  #
  def shuffle
    dup.shuffle!
    #sort_by{Kernel.rand}
  end

  # CREDIT Niel Spring

  # As with #shuffle but modifies the array in place.
  # The algorithm used here is known as a Fisher-Yates shuffle.
  #
  #   a = [1,2,3,4]
  #   a.shuffle!
  #   a  #=> [2,4,1,3]
  #
  def shuffle!
    s = size
    each_index do |j|
      i = Kernel.rand(s-j)
      #self[j], self[j+i] = self[j+i], self[j]
      tmp = self[j]
      self[j] = self[j+i]
      self[j+i] = tmp
    end
    self
  end

end


class Hash

  # Returns a random key.
  #
  #   {:one => 1, :two => 2, :three => 3}.pick_key  #=> :three
  #
  def rand_key
    keys.at( rand(keys.size) )
  end

  # Delete a random key-value pair, returning the key.
  #
  #   a = {:one => 1, :two => 2, :three => 3}
  #   a.pick_key!  #=> :two
  #   a            #=> {:one => 1, :three => 3}
  #
  def rand_key!
    k,v = rand_pair
    delete( k )
    return k
  end

  alias_method( :pick_key, :rand_key! )

  # Returns a random key-value pair.
  #
  #   {:one => 1, :two => 2, :three => 3}.pick  #=> [:one, 1]
  #
  def rand_pair
    k = rand_key
    return k, fetch(k)
  end

  # Deletes a random key-value pair and returns that pair.
  #
  #   a = {:one => 1, :two => 2, :three => 3}
  #   a.rand_pair!  #=> [:two, 2]
  #   a             #=> {:one => 1, :three => 3}
  #
  def rand_pair!
    k,v = rand_pair
    delete( k )
    return k,v
  end

  alias_method( :pick_pair, :rand_pair! )

  # Returns a random hash value.
  #
  #   {:one => 1, :two => 2, :three => 3}.rand_value  #=> 2
  #   {:one => 1, :two => 2, :three => 3}.rand_value  #=> 1
  #
  def rand_value
    fetch( rand_key )
  end

  # Deletes a random key-value pair and returns the value.
  #
  #   a = {:one => 1, :two => 2, :three => 3}
  #   a.at_rand!  #=> 2
  #   a           #=> {:one => 1, :three => 3}
  #
  def rand_value!
    k,v = rand_pair
    delete( k )
    return v
  end

  alias_method( :pick, :rand_value! )

  alias_method( :at_rand, :rand_value )
  alias_method( :at_rand!, :rand_value! )

  # Returns a copy of the hash with _values_ arranged
  # in new random order.
  #
  #   h = {:a=>1, :b=>2, :c=>3}
  #   h.shuffle_hash  #=> {:b=>2, :c=>1, :a>3}
  #
  def shuffle
    Hash.zipnew( keys.sort_by{Kernel.rand}, values.sort_by{Kernel.rand} )
  end

  # Destructive shuffle_hash. Arrange the values in
  # a new random order.
  #
  #   h = {:a => 1, :b => 2, :c => 3}
  #   h.shuffle_hash!
  #   h  #=> {:b=>2, :c=>1, :a=>3}
  #
  def shuffle!
    self.replace( shuffle )
  end

end


class String

  # Returns a randomly generated string. One possible use is
  # password initialization. Takes a max legnth of characters
  # (default 8) and an optional valid char Regexp (default /\w\d/).
  #
  #--
  # CREDIT George Moschovitis
  #
  # NOTE This is not very efficient. Better way?
  #++

  def self.random(max_length = 8, char_re = /[\w\d]/)
    # gmosx: this is a nice example of input parameter checking.
    # this is NOT a real time called method so we can add this
    # check. Congrats to the author.
    raise ArgumentError.new('char_re must be a regular expression!') unless char_re.is_a?(Regexp)
    string = ""
    while string.length < max_length
        ch = rand(255).chr
        string << ch if ch =~ char_re
    end
    return string
  end

  # Module method to generate a random letter.
  #
  #   String::Random.rand_letter  #=> "q"
  #   String::Random.rand_letter  #=> "r"
  #   String::Random.rand_letter  #=> "a"
  #
  def self.rand_letter
    (rand(26) + (rand(2) == 0 ? 65 : 97) ).chr
  end

  # Return a random separation of the string.
  # Default separation is by charaacter.
  #
  #   "Ruby rules".at_rand(' ')  #=> ["Ruby"]
  #
  def at_rand( separator=// )
    #separator = self.class.patterns( separator )
    self.split(separator,-1).at_rand
  end

  # Return a random separation while removing it
  # from the string. Default separation is by character.
  #
  #   s = "Ruby rules"
  #   s = at_rand!(' ')  #=> "Ruby"
  #   s                  #=> "rules"
  #
  def at_rand!( separator=// )
    #separator = self.class.patterns( separator )
    a = self.shatter( separator )
    w = []; a.each_with_index { |s,i| i % 2 == 0 ? w << s : w.last << s }
    i = rand( w.size )
    r = w.delete_at( i )
    self.replace( w.join('') )
    return r
  end

  # Return a random byte of _self_.
  #
  #   "Ruby rules".rand_byte  #=> 121
  #
  def rand_byte
    self[rand( size )]
  end

  # Destructive rand_byte. Delete a random byte of _self_ and return it.
  #
  #   s = "Ruby rules"
  #   s.rand_byte!      #=> 121
  #   s                 #=> "Rub rules"
  #
  def rand_byte!
    i = rand( size )
    rv = self[i,1]
    self[i,1] = ''
    rv
  end

  # Return a random string index.
  #
  #   "Ruby rules".rand_index  #=> 3
  #
  def rand_index
    rand( size )
  end

  # Return the string with seperated sections arranged
  # in a random order. The default seperation is by character.
  #
  #   "Ruby rules".shuffle  #=> "e lybRsuur"
  #
  def shuffle(separator=//)
    split(separator).shuffle.join('')
  end

  # In place version of shuffle.
  #
  def shuffle!(separator=//)
    self.replace( shuffle(separator) )
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

  class TestKernelRandom < Test::Unit::TestCase

    def test_maybe
      assert_nothing_raised { maybe }
    end

  end

  class TestArrayRandom < Test::Unit::TestCase

    def test_at_rand
      a = [1,2,3,4,5]
      20.times{ assert_nothing_raised{ a.at_rand } }
      20.times{ assert( a.include?( a.at_rand ) ) }
    end

    def test_at_rand!
      a = ['a','b','c']
      assert_equal( 1, a.at_rand!.length )
      assert_equal( 2, a.length )
    end

    def test_pick
      a = ['a','b','c']
      assert_equal( 3, a.pick(3).length )
      assert_equal( 3, a.length )
      a = ['a','b','c']
      assert_equal( 3, a.pick(4).length )
      assert_equal( 3, a.length )
    end

    def test_pick!
      a = ['a','b','c']
      assert_equal( 3, a.pick!(3).length )
      assert_equal( 0, a.length )
      a = ['a','b','c']
      assert_equal( 3, a.pick!(4).length )
      assert_equal( 0, a.length )
    end

    def test_rand_index
      10.times {
        i = [1,2,3].rand_index
        assert( (0..2).include?(i) )
      }
    end

    def test_rand_subset
      10.times {
        a = [1,2,3,4].rand_subset
        assert( a.size <= 4 )
      }
    end

    def test_shuffle
      a = [1,2,3,4,5]
      b = a.shuffle
      assert_equal( a, b.sort )
    end

    def test_shuffle!
      a = [1,2,3,4,5]
      b = a.dup
      b.shuffle!
      assert_equal( a, b.sort )
    end

  end

  class TestHashRandom < Test::Unit::TestCase

    def test_rand_key
      h = { :a=>1, :b=>2, :c=>3 }
      10.times { assert( h.keys.include?( h.rand_key ) ) }
    end

    def test_rand_pair
      h = { :a=>1, :b=>2, :c=>3 }
      10.times { k,v = *h.rand_pair; assert_equal( v, h[k] ) }
    end

    def test_rand_value
      h = { :a=>1, :b=>2, :c=>3 }
      10.times { assert( h.values.include?( h.rand_value ) ) }
    end

    def test_shuffle
      h = {:a=>1, :b=>2, :c=>3 }
      assert_nothing_raised { h.shuffle }
    end

    def test_shuffle!
      h = {:a=>1, :b=>2, :c=>3 }
      assert_nothing_raised { h.shuffle! }
    end

  end

  class TestStringRandom < Test::Unit::TestCase

    def test_String_rand_letter
      100.times { |i| assert( /[a-zA-z]/ =~ String.rand_letter ) }
    end

    def test_at_rand
      a = '12345'
      20.times{ assert_nothing_raised{ a.at_rand } }
      20.times{ assert( a.include?( a.at_rand ) ) }
    end

    def test_at_rand!
      x = 'ab'
      r = x.at_rand!
      assert( r == 'a' || r == 'b' )
      assert( x == 'a' || x == 'b' )
    end

    def test_rand_index
      10.times { assert( (0..2).include?( 'abc'.rand_index ) ) }
    end

    def test_rand_byte
      s = 'ab'
      r = s.rand_byte
      assert( r == 97 || r == 98 )
    end

    def test_rand_byte
      s = 'ab'
      r = s.rand_byte
      assert( r == 97 || r == 98 )
      assert( s = 'a' || s = 'b' )
    end

    def test_shuffle
      assert_nothing_raised { "abc 123".shuffle }
      #assert_nothing_raised { "abc 123".shuffle! }
    end

  end

=end

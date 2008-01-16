# Test for lib/facets/random.rb

require 'facets/random.rb'

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




require 'test/unit'

class TestHashCollation < Test::Unit::TestCase

    def setup
      @a = { :a=>1, :b=>2, :z=>26, :all=>%w|a b z|, :stuff1=>%w|foo bar|, :whee=>%w|a b| }
      @b = { :a=>1, :b=>4, :c=>9,  :all=>%w|a b c|, :stuff2=>%w|jim jam|, :whee=>%w|a b| }
      @c = { :a=>1, :b=>8, :c=>27 }
    end

    def test_defaults
      collated = @a.collate(@b)
      assert_equal( 8, collated.keys.length, "There are 7 unique keys" )
      assert_equal( [1,1], collated[ :a ] )
      assert_equal( [2,4], collated[ :b ] )
      assert_equal( [9],   collated[ :c ] )
      assert_equal( [26],  collated[ :z ] )
      assert_equal( %w|a b z a b c|,  collated[ :all ], "Arrays are merged by default." )
      assert_equal( %w|foo bar|,  collated[ :stuff1 ] )
      assert_equal( %w|jim jam|,  collated[ :stuff2 ] )
      assert_equal( %w|a b a b|,  collated[ :whee ] )
    end

    def test_multi_collate
      collated = @a.collate(@b).collate(@c)
      assert_equal( [1,1,1], collated[ :a ] )
      assert_equal( [2,4,8], collated[ :b ] )
      assert_equal( [9,27],  collated[ :c ] )
    end

  end

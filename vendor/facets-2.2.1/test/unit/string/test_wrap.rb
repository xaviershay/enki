# Test for facets/string/format

require 'facets/string/wrap.rb'

require 'test/unit'


class TestStringFormat < Test::Unit::TestCase

  def test_fold_1
    s = "This is\na test.\n\nIt clumps\nlines of text."
    o = "This is a test.\n\nIt clumps lines of text."
    assert_equal( o, s.fold )
  end

  def test_fold_2
    s = "This is\na test.\n\n  This is pre.\n  Leave alone.\n\nIt clumps\nlines of text."
    o = "This is a test.\n\n  This is pre.\n  Leave alone.\n\nIt clumps lines of text."
    assert_equal( o, s.fold(true) )
  end

  def test_line_wrap
    assert_equal "abc\n123\n", "abc123".line_wrap(3)
    assert_equal "abcd\n123\n", "abcd123".line_wrap(4)
  end

  def test_word_wrap
    assert_equal "abcde\n12345\nxyzwu\n", "abcde 12345 xyzwu".word_wrap(5)
    assert_equal "abcd\n1234\nxyzw\n", "abcd 1234 xyzw".word_wrap(4)
    assert_equal "abc\n123\n", "abc 123".word_wrap(4)
    assert_equal "abc \n123\n", "abc  123".word_wrap(4)
    assert_equal "abc \n123\n", "abc     123".word_wrap(4)
  end

  def test_word_wrap!
    w = "abcde 12345 xyzwu" ; w.word_wrap!(5)
    assert_equal("abcde\n12345\nxyzwu\n", w)
    w = "abcd 1234 xyzw" ; w.word_wrap!(4)
    assert_equal("abcd\n1234\nxyzw\n", w)
    w = "abc 123" ; w.word_wrap!(4)
    assert_equal "abc\n123\n", w
    w = "abc  123" ; w.word_wrap!(4)
    assert_equal("abc \n123\n", w)
    w = "abc     123" ; w.word_wrap!(4)
    assert_equal("abc \n123\n", w)
  end

# def test_word_wrap
#   assert_equal "abcde-\n12345-\nxyzwu\n", "abcde12345xyzwu".word_wrap(6,2)
#   assert_equal "abcd-\n1234-\nxyzw\n", "abcd1234xyzw".word_wrap(5,2)
#   assert_equal "abc \n123\n", "abc 123".word_wrap(4,2)
#   assert_equal "abc \n123\n", "abc  123".word_wrap(4,2)
#   assert_equal "abc \n123\n", "abc     123".word_wrap(4,2)
# end

  def test_cleave_nospaces
    assert_equal [ 'whole', '' ], 'whole'.cleave
    assert_equal [ 'Supercalifragilisticexpialidocious', '' ],
                'Supercalifragilisticexpialidocious'.cleave
  end

  def test_cleave_exact_middle
    assert_equal [ 'fancy', 'split' ], 'fancy split'.cleave
    assert_equal [ 'All good Rubyists', 'know how to party' ],
                'All good Rubyists know how to party'.cleave
  end

  def test_cleave_closer_to_start
    assert_equal [ 'short', 'splitter' ], 'short splitter'.cleave
    assert_equal [ 'Four score and', 'seven years ago...' ],
                'Four score and seven years ago...'.cleave
    assert_equal [ 'abc def', 'ghijklm nop' ],
                'abc def ghijklm nop'.cleave
  end

  def test_cleave_closer_to_end
    assert_equal [ 'extended', 'split' ], 'extended split'.cleave
    assert_equal [ 'abc defghi', 'jklm nop' ],
                'abc defghi jklm nop'.cleave
  end

end

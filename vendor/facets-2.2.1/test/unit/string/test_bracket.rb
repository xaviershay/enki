# Test for facets/string/bracket

require 'facets/string/bracket.rb'

require 'test/unit'

class TestStringBracket < Test::Unit::TestCase

  def test_bracket
    assert_equal( '#X#', 'X'.bracket('#') )
    assert_equal( 'xX!', 'X'.bracket('x','!') )
    assert_equal( '{X}', 'X'.bracket('{','}') )
    assert_equal( '<X>', 'X'.bracket('<') )
    assert_equal( '(X)', 'X'.bracket('(') )
    assert_equal( '[X]', 'X'.bracket('[') )
    assert_equal( '{X}', 'X'.bracket('{') )
  end

  def test_braket!
    a = 'X' ; a.bracket!('#')
    assert_equal( '#X#', a )
    a = 'X' ; a.bracket!('x','!')
    assert_equal( 'xX!', a )
    a = 'X' ; a.bracket!('{','}')
    assert_equal( '{X}', a )
    a = 'X' ; a.bracket!('<')
    assert_equal( '<X>', a )
    a = 'X' ; a.bracket!('(')
    assert_equal( '(X)', a )
    a = 'X' ; a.bracket!('[')
    assert_equal( '[X]', a )
    a = 'X' ; a.bracket!('{')
    assert_equal( '{X}', a )
  end

  def test_quote_01
    a =  "hi"
    assert_raises( ArgumentError ) { a.quote(1,2) }
  end

  def test_quote_02
    a =  "hi"
    assert_equal( %{'hi'}, a.quote )
  end

  def test_quote_03
    a =  "hi"
    assert_equal( %{"hi"}, a.quote(:d) )
    assert_equal( %{"hi"}, a.quote(:double) )
  end

  def test_quote_04
    a =  "hi"
    assert_equal( %{'hi'}, a.quote(:s) )
    assert_equal( %{'hi'}, a.quote(:single) )
  end

  def test_quote_05
    a =  "hi"
    assert_equal( %{`hi`}, a.quote(:b) )
    assert_equal( %{`hi`}, a.quote(:back) )
  end

end

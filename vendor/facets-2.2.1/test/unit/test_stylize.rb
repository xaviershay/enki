# Test lib/facets/stylize.rb

require 'facets/stylize.rb'

require 'test/unit'


class TestStylize < Test::Unit::TestCase

  def test_basename_01
    assert_equal( "Unit", "Test::Unit".basename )
  end

  def test_basename_02
    a =  "Down::Bottom"
    assert_raises( ArgumentError ) { a.basename(1) }
  end

  def test_basename_03
    a =  "Down::Bottom"
    assert_equal( "Bottom", a.basename )
  end

  def test_basename_04
    b =  "Further::Down::Bottom"
    assert_equal( "Bottom", b.basename )
  end

  def test_camelize
    assert_equal( 'ThisIsIt', 'this_is_it'.camelize )
  end

  def test_camelcase
    assert_equal( "abcXyz", "abc_xyz".camelcase )
    assert_equal( "abcXyz", "abc xyz".camelcase )
    assert_equal( "abcXyz", "abc  xyz".camelcase )
    assert_equal( "abcXyz", "abc\txyz".camelcase )
    assert_equal( "abcXyz", "abc\nxyz".camelcase )
    assert_equal( "abcXyz", "abc____xyz".camelcase )
  end

  def test_camelcase_true
    assert_equal( "AbcXyz", "abc_xyz".camelcase(true) )
    assert_equal( "AbcXyz", "abc xyz".camelcase(true) )
    assert_equal( "AbcXyz", "abc  xyz".camelcase(true) )
    assert_equal( "AbcXyz", "abc\txyz".camelcase(true) )
    assert_equal( "AbcXyz", "abc\nxyz".camelcase(true) )
  end

  def test_humanize
    assert_equal( 'This is it', 'this_is_it'.humanize )
  end

  def test_title
    r = "try this out".title
    x = "Try This Out"
    assert_equal(x,r)
  end

  def test_demodulize_01
    a =  "Down::Bottom"
    assert_raises( ArgumentError ) { a.demodulize(1) }
  end

  def test_demodulize_02
    a =  "Down::Bottom"
    assert_equal( "Bottom", a.demodulize )
  end

  def test_demodulize_03
    b =  "Further::Down::Bottom"
    assert_equal( "Bottom", b.demodulize )
  end

  def test_demodulize_01
    a =  "Down::Bottom"
    assert_raises( ArgumentError ) { a.demodulize(1) }
  end

  def test_demodulize_02
    a =  "Down::Bottom"
    assert_equal( "Bottom", a.demodulize )
  end

  def test_demodulize_03
    b =  "Further::Down::Bottom"
    assert_equal( "Bottom", b.demodulize )
  end

  def test_methodize
    assert_equal( 'hello_world', 'HelloWorld'.methodize )
    assert_equal( '__unix_path', '/unix_path'.methodize )
  end

  def test_modulize
    assert_equal( 'MyModule::MyClass',   'my_module__my_class'.modulize   )
    assert_equal( '::MyModule::MyClass', '__my_module__my_class'.modulize )
    assert_equal( 'MyModule::MyClass',   'my_module/my_class'.modulize    )
    assert_equal( '::MyModule::MyClass', '/my_module/my_class'.modulize   )
  end

  def test_pathize
    assert_equal( 'my_module/my_class',   'MyModule::MyClass'.pathize )
    assert_equal( 'u_r_i',                'URI'.pathize )
    assert_equal( '/my_class',            '::MyClass'.pathize )
    assert_equal( '/my_module/my_class/', '/my_module/my_class/'.pathize )
  end

end


class TestClassStylize < Test::Unit::TestCase

  def test_method_name
    assert_equal( Test::Unit::TestCase.methodize, 'test__unit__test_case' )
  end

  def test_method_name
    assert_equal( Test::Unit::TestCase.pathize, '/test/unit/test_case' )
  end

end

class TestIntegerStylize < Test::Unit::TestCase

  def test_ordinalize
    assert_equal( '1st', '1'.ordinalize )
    assert_equal( '2nd', '2'.ordinalize )
    assert_equal( '3rd', '3'.ordinalize )
    assert_equal( '4th', '4'.ordinalize )
  end

  def test_ordinal
    assert_equal( '1st', 1.ordinal )
    assert_equal( '2nd', 2.ordinal )
    assert_equal( '3rd', 3.ordinal )
    assert_equal( '4th', 4.ordinal )
  end

end

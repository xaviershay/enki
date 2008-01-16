# Test for facets/string/tabs

require 'facets/string/tabs.rb'
require 'test/unit'

class TestStringTabs < Test::Unit::TestCase

  def setup
    @tabs = <<-EOF

\tOne tab
 \tOne space and one tab
    \t Six spaces, a tab, and a space
    EOF

    @poem1 = <<-EOF
    I must go down to the seas again
      The lonely sea and the sky
    And all I want is a tall ship
      And a star to steer her by
    EOF

    @poem2 = <<-EOF
       "Eek!"
    She cried
      As the mouse quietly scurried
  by.
    EOF
  end  # def setup

  def test_tab
    a = "xyz".tab(4)
    assert_equal( '    ', a[0..3] )
    # Need to expand on this
  end

  def test_expand_tabs_1
    expected = <<-EOF

        One tab
        One space and one tab
         Six spaces, a tab, and a space
    EOF
    assert_equal(expected, @tabs.expand_tabs)
    assert_equal(expected, @tabs.expand_tabs(8))
  end

  def test_expand_tabs_2
    expected = <<-EOF

    One tab
    One space and one tab
         Six spaces, a tab, and a space
    EOF
    assert_equal(expected, @tabs.expand_tabs(4))
  end

  def test_expand_tabs_3
    expected = <<-EOF

                One tab
                One space and one tab
                 Six spaces, a tab, and a space
    EOF
    assert_equal(expected, @tabs.expand_tabs(16))
  end

  def test_expand_tabs_4
    expected = <<-EOF

 One tab
  One space and one tab
      Six spaces, a tab, and a space
    EOF
    assert_equal(expected, @tabs.expand_tabs(1))
  end

  def test_expand_tabs_5
    expected = <<-EOF

One tab
 One space and one tab
     Six spaces, a tab, and a space
    EOF
    assert_equal(expected, @tabs.expand_tabs(0))
  end

  def test_tabto
    a = "xyz".tabto(4)
    assert_equal( '    ', a[0..3] )
    # Need to expand on this
  end

  def test_indent
    a = "xyz".indent(4)
    assert_equal( '    ', a[0..3] )
    # Need to expand on this
  end

  def test_outdent_0
    assert_equal("    xyz", "   xyz".outdent(-1))
    assert_equal("   xyz", "   xyz".outdent(0))
    assert_equal("  xyz", "   xyz".outdent(1))
    assert_equal(" xyz", "   xyz".outdent(2))
    assert_equal("xyz", "   xyz".outdent(3))
    assert_equal("xyz", "   xyz".outdent(4))
  end

  def test_outdent_1
    expected = <<-EOF
   I must go down to the seas again
     The lonely sea and the sky
   And all I want is a tall ship
     And a star to steer her by
    EOF
    actual = @poem1.outdent(1)
    assert_equal(expected, actual)
  end

  def test_outdent_2
    expected = <<-EOF
I must go down to the seas again
  The lonely sea and the sky
And all I want is a tall ship
  And a star to steer her by
    EOF
    actual = @poem1.outdent(4)
    assert_equal(expected, actual)
  end

  def test_outdent_3
    expected = <<-EOF
"Eek!"
She cried
As the mouse quietly scurried
by.
    EOF
    actual = @poem2.outdent(100)
    assert_equal(expected, actual)
  end

  def test_margin
    s = %q{
          |ABC
          |123
          |TEST
          }.margin
    assert_equal( "ABC\n123\nTEST", s )

    s = %q{
            |ABC
          |123
                |TEST
          }.margin
    assert_equal( "ABC\n123\nTEST", s )

    s = %q{|ABC
          |123
          |TEST
    }.margin
    assert_equal( "ABC\n123\nTEST", s )

    s = %q{
          |ABC
          |123
          |TEST}.margin
    assert_equal( "ABC\n123\nTEST", s )

    s = %q{|ABC
          |123
          |TEST}.margin
    assert_equal( "ABC\n123\nTEST", s )

    s = %q{   |ABC
          |123
          |TEST}.margin
    assert_equal( "ABC\n123\nTEST", s )

    s = %q{ABC
          |123
          |TEST
          }.margin
    assert_equal( "ABC\n123\nTEST", s )
  end

  #

  def test_spacing
    s = %q{
          | ABC
          | 123
          | TEST
          }.margin
    assert_equal( " ABC\n 123\n TEST", s )

    s = %q{
          |ABC
          |123
          |TEST
          }.margin(1)
    assert_equal( " ABC\n 123\n TEST", s )

    s = %q{
          |ABC
          |123
          |TEST
          }.margin(2)
    assert_equal( "  ABC\n  123\n  TEST", s )

    s = %q{ ABC
          - 123
          - TEST
          }.margin
    assert_equal( " ABC\n 123\n TEST", s )
  end

  #

  def test_random_placement
    @volly = {}
    100.times{ |n|
      k = []
      a = []
      5.times{ |i|
        k << ( ( ' ' * Integer(rand*10) ) + '|' + i.to_s )
        a << ( i.to_s )
      }
      @volly[k.join("\n")] = a.join("\n")
    }
    @volly.each{ |k,v|
      assert_equal( v, k.margin )
    }
  end

end


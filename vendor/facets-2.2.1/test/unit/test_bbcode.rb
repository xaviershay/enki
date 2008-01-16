# Test for facets/bbcode.rb

require 'facets/bbcode.rb'
require 'test/unit'

class TC_BBCode < Test::Unit::TestCase

  def test_to_ansi
    str = "this is [COLOR=red]red[/COLOR], this is [B]bold[/B]"
    out = "this is \e[0;31mred\e[0m, this is \e[1mbold\e[0m\n"
    assert_equal( out, BBCode.bbcode_to_ansi(str) )
  end

  def test_to_html
    str = "this is [COLOR=red]red[/COLOR], this is [B]bold[/B]"
    out = "this is <font color=\"red\">red</font>, this is <strong>bold</strong><br />\n"
    assert_equal( out, BBCode.bbcode_to_html(str) )
  end

end

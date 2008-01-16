require 'test/unit'
require 'facets/ansicode'

class TestANSICode < Test::Unit::TestCase

  include Console::ANSICode

  def test_methods
    str = red + "Hello" + blue + "World"
    out = "\e[31mHello\e[34mWorld"
    assert_equal( out, str )
  end

  def test_blocks
    str = red { "Hello" } + blue { "World" }
    out = "\e[31mHello\e[0m\e[34mWorld\e[0m"
    assert_equal( out, str )
  end

end

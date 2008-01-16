# Test facets/getoptlong.rb

require 'facets/getoptlong.rb'
require 'test/unit'

class TestGetoptShort < Test::Unit::TestCase

  def test_dsl
    ARGV.replace(['foo', '--expect', 'A', '-h', 'nothing'])

    opts = GetoptLong.new do
      reqs '--expect', '-x'
      flag '--help', '-h'
    end

    ch = {}
    opts.each { |opt, arg|
      ch[opt] = arg
    }

    assert_equal( 'A',  ch['--expect'] )
    assert_equal( '', ch['--help'] )
  end

end

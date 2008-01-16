# TITLE:
#
#   GetoptLong Revisted
#
# DESCRIPTION:
#
#   Ruby's standard GetoptLong class with an added DSL.
#
# COPYRIGHT:
#
#   Copyright (c) 2007 Thomas Sawyer
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
#   - Thomas Sawuer


require 'getoptlong'


# = GetoptLong
#
# Ruby's standard GetoptLong class with an added DSL.
#
#       opts = GetoptLong.new do
#         reqs '--expect', '-x'
#         flag '--help', '-h'
#       end
#
#       opts.each { |opt, arg|
#         ...
#       }
#
class GetoptLong

  alias :init :initialize

  def initialize(*arguments, &block)
    if block_given?
      raise ArgumentError unless arguments.empty?
      arguments = DSL.new(&block).arguments
    end
    init(*arguments)
  end

  # DSL-mode parser.

  class DSL
    attr :arguments

    def initialize(&block)
      @arguments = []
      instance_eval(&block)
    end

    def flag(*opts)
      @arguments << (opts << GetoptLong::NO_ARGUMENT)
    end

    def required(*opts)
      @arguments << (opts <<  GetoptLong::REQUIRED_ARGUMENT)
    end
    alias :reqs :required

    def optional(*opts)
      @arguments << (opts << GetoptLong::OPTIONAL_ARGUMENT)
    end
    alias :opts :optional
  end

end


# TEST

=begin test

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

=end


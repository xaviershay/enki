# TITLE:
#
#   Instantiable
#
# SUMMARY:
#
#   Initialize modules, almost as if they were classes.
#
# COPYRIGHT:
#
#   Copyright (c) 2006 Thomas Sawyer
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
#   - Thomas Sawyer


#
class Module

  module Instantiable

    # Never use a class agian! ;)

    def new(*args,&blk)
      mod = self
      klass = Class.new{include mod}
      klass.new(*args,&blk)
    end

  end

end


#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#
=begin test

  require 'test/unit'

  class TestInstantiable < Test::Unit::TestCase

    module M
      extend Module::Instantiable

      attr_reader :a
      def initialize( a )
        @a = a
      end
    end

    def test_new
      m = M.new( 1 )
      assert_equal( 1, m.a )
    end

  end

=end

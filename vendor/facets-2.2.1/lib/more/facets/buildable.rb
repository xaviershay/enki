# TITLE:
#
#   Buildable
#
# DESCRIPTION:
#
#   Mixin variation of BuildingBlock.
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


require 'facets/buildingblock'


# = Buildable
#
# Buildable is mixin variation of BuildingBlock.
#
#   require 'facets/buildable'
#   require 'xmlmarkup'  # hypothetical library
#
#   module XMLMarkup
#     include Buildable
#     alias :build :element
#   end
#
#   doc = XMLMarkup.build do
#     html do
#       head do
#         title "Test"
#       end
#       body do
#         i "Hello"
#         br
#         text "Test"
#         text "Hey"
#       end
#     end
#   end
#
# _produces_
#
#   <html><head><title>Test</title><body><i>Hello</i><br />TestHey</body></html>
#
# This is based on BuildingBlock. Refer to it for more information.

module Buildable

  def self.included(base)
    singleton = (class << base; self; end)
    singleton.send(:define_method, :builder) do
      @builder ||= BuildingBlock.new(base, :build)
    end
    base.module_eval %{
      def self.build(&block)
        builder.instance_eval(&block)
      end
    }
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

  class TestBuildable < Test::Unit::TestCase

    module M
      include Buildable

      extend self

      def m(n,*m) ; "#{n}{#{m}}"; end
      def t(n) ; "#{n}"; end

      alias :build :m
    end

    def test_01
      str = M.build do
        html do
          head do
            title "Test"
          end
          body do
            i "Hello"
            build! :not
            t "Test"
            t "Hey"
          end
        end
      end

      r = "html{head{title{Test}}body{i{Hello}not{}TestHey}}"

      assert_equal( r, M.builder.to_s )
    end

  end

=end


# Author::    Thomas Sawyer
# Copyright:: Copyright (c) 2007 Thomas Sawyer
# License::   Ruby License

# TITLE:
#
#   PathList
#
# DESCRIPTION:
#
#   A PathList is an array containing 1..n paths. It is useful to regroup paths and
#   make lookups on them.
#
# COPYRIGHT:
#
#   Copyright (c) 2005 Jonas Pfenniger
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
#   - Jonas Pfenniger


# = PathList
#
# A PathList is an array containing 1..n paths. It is useful to regroup paths and
# make lookups on them.
#
# == Usage
#
#  path = PathList.new(ENV['PATH'])
#  path.find 'env'            #=> "/usr/bin/env"
#
#  # This is already done when including the library
#  $:.class                   #=> Array
#  $:.extend PathList::Finder
#  $:.find_ext = 'rb'
#
#  $:.find 'uri'              #=> "/usr/lib/ruby/1.8/uri.rb"
#
class PathList < Array

  def initialize(paths, default_ext = nil)
    @find_ext = default_ext
    if paths.kind_of? String
      paths = paths.split(File::PATH_SEPARATOR)
    end
    super(paths)
  end

  def to_s
    join(File::PATH_SEPARATOR)
  end

  module Finder

    attr_accessor :find_ext

    def find(filename, use_ext=true)
      filename += '.' + @find_ext if @find_ext and use_ext
      to_a.each do |path|
        filepath = File.join(path, filename)
        return filepath if File.exist?( filepath )
      end
      return nil
    end
    alias :include? find

  end
  include Finder
end

$:.extend PathList::Finder
$:.find_ext = 'rb'

# Doesn't work
#ENV['PATH'] = PathList.new(ENV['PATH'])

#++


#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#
=begin #testing

  require 'test/unit'

  # Needs a Mockup
  # It is not possible to test file lookups in a platform independent manner.

  class TC_PathList < Test::Unit::TestCase

  end

=end


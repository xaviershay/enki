# TITLE:
#
#  OpenCascade
#
# DESCRIPTION:
#
#   OpenCascade is a subclass of OpenObject. It differs in a few
#   significant ways, in particular entries cascade to new entries.
#
# AUTHOR:
#
#   - Thomas Sawyer
#
# LICENSE:
#
#   Copyright (c) 2006 Thomas Sawyer
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
# TODO:
#
#   - Think about this more!
#
#   - What about parent when descending downward?
#     Should parent even be part of OpenObject?
#     Maybe that should be in a differnt class?
#
#   - Should cascading work via hash on the fly like this?
#     Or perhaps converted all at once?
#
#   - Returning nil doesn't work if assigning!


require 'facets/boolean' # bool
require 'facets/openobject'
#require 'facets/nullclass'

# = OpenCascade
#
# OpenCascade is subclass of OpenObject. It differs in a few
# significant ways.
#
# The main reason this class is labeled "cascade", every internal
# Hash is trandformed into an OpenCascade dynamically upon access.
# This makes it easy to create "cascading" references.
#
#   h = { :x => { :y => { :z => 1 } } }
#   c = OpenCascade[h]
#   c.x.y.z  #=> 1
#
#--
# Last, when an entry is not found, 'null' is returned rather then 'nil'.
# This allows for run-on entries withuot error. Eg.
#
#   o = OpenCascade.new
#   o.a.b.c  #=> null
#
# Unfortuately this requires an explict test for of nil? in 'if' conditions,
#
#   if o.a.b.c.null?  # True if null
#   if o.a.b.c.nil?   # True if nil or null
#   if o.a.b.c.not?   # True if nil or null or false
#
# So be sure to take that into account.
#++

class OpenCascade < OpenObject

  def method_missing( sym, arg=nil )
    type = sym.to_s[-1,1]
    name = sym.to_s.gsub(/[=!?]$/, '').to_sym
    if type == '='
      self[name] = arg
    elsif type == '!'
      self[name] = arg
      self
    else
      val = self[name]
      val = object_class[val] if Hash === val
      val
    end
  end

end


#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

=begin testing

  require 'test/unit'

  class TestOpenCascade1 < Test::Unit::TestCase

    def test_1_01
      o = OpenCascade[:a=>1,:b=>2]
      assert_equal( 1, o.a )
      assert_equal( 2, o.b )
    end

    def test_1_02
      o = OpenCascade[:a=>1,:b=>2,:c=>{:x=>9}]
      assert_equal( 9, o.c.x )
    end

    def test_1_03
      f0 = OpenCascade.new
      f0[:a] = 1
      assert_equal( [[:a,1]], f0.to_a )
      assert_equal( {:a=>1}, f0.to_h )
    end

    def test_1_04
      f0 = OpenCascade[:a=>1]
      f0[:b] = 2
      assert_equal( {:a=>1,:b=>2}, f0.to_h )
    end
  end

  class TestOpenCascade2 < Test::Unit::TestCase

    def test_02_001
      f0 = OpenCascade[:f0=>"f0"]
      h0 = { :h0=>"h0" }
      assert_equal( OpenCascade[:f0=>"f0", :h0=>"h0"], f0.send(:merge,h0) )
      assert_equal( {:f0=>"f0", :h0=>"h0"}, h0.merge( f0 ) )
    end

    def test_02_002
      f1 = OpenCascade[:f1=>"f1"]
      h1 = { :h1=>"h1" }
      f1.send(:update, h1)
      h1.update( f1 )
      assert_equal( OpenCascade[:f1=>"f1", :h1=>"h1"], f1 )
      assert_equal( {:f1=>"f1", :h1=>"h1"}, h1 )
    end
  end

  class TestOpenCascade3 < Test::Unit::TestCase

    def test_01_001
      fo = OpenCascade.new
      99.times{ |i| fo.__send__( "n#{i}=", 1 ) }
      99.times{ |i|
        assert_equal( 1, fo.__send__( "n#{i}" ) )
      }
    end
  end

=end

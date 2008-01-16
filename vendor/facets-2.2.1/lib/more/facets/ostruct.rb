# TITLE:
#
#   OpenStruct
#
# DESCRIPTION:
#
#   Ruby's standard OpenStruct with a few extensions added-in.
#
# AUTHOR:
#
#   - Thomas Sawyer
#
# LICENSE:
#
#   Copyright (c) 2005 Thomas Sawyer, George Moschovitis
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
# LOG:
#   - 2006-11-04 trans  Deprecate #instance in favor of #instance_delegate.
#   - 2007-04-15 trans  Filled out with actual methods, used "ostruct_" for some accessors.


require 'ostruct'

class OpenStruct

  #
  # Allows the initialization of an OpenStruct with a block:
  #
  #   person = OpenStruct.new do |p|
  #     p.name    = 'John Smith'
  #     p.gender  = :M
  #     p.age     = 71
  #   end 
  #
  # You can still provide a hash for initialization purposes, and even combine
  # the two approaches if you wish.
  #
  #   person = OpenStruct.new(:name => 'John Smith', :age => 31) do |p|
  #     p.gender = :M 
  #   end
  #
  #   CREDIT Noah Gibbs
  #   CREDIT Gavin Sinclair

  def initialize(hash=nil) # :yield: self
    @table = {}
    if hash
      for k,v in hash
        @table[k.to_sym] = v
        new_ostruct_member(k)
      end
    end
    yield self if block_given?
  end

  #
  def each(&blk)
    @table.each(&blk)
  end

  #
  def to_h
    @table
  end

  # Access a value in the OpenStruct by key, like a Hash.
  # This increases OpenStruct's "duckiness".
  #
  #   o = OpenStruct.new
  #   o.t = 4
  #   o['t']  #=> 4
  #
  def [](key)
    key = key.to_sym unless key.is_a?(Symbol)
    @table[key]
  end

  # Set a value in the OpenStruct by key, like a Hash.
  #
  #   o = OpenStruct.new
  #   o['t'] = 4
  #   o.t  #=> 4
  #
  def []=(key,val)
    raise TypeError, "can't modify frozen #{self.class}", caller(1) if self.frozen?
    key = key.to_sym unless key.is_a?(Symbol)
    @table[key]=val
  end

  # CREDIT Robert J. Berger <rberger AT ibd.com>
  # Thanks for reporting issues that this method resolved.

  # Provides access to an OpenStruct's inner table.
  #
  #   o = OpenStruct.new
  #   o.a = 1
  #   o.b = 2
  #   o.instance_delegate.each { |k, v| puts "#{k} #{v}" }
  #
  # produces
  #
  #   a 1
  #   b 2
  #
  #
  def instance_delegate
    @table
  end
  alias ostruct_delegate instance_delegate

  # Insert/update hash data on the fly.
  #
  #   o = OpenStruct.new
  #   o.ostruct_update { :a => 2 }
  #   o.a  #=> 2
  #
  def ostruct_update(other)
    #other = other.to_hash  #to_h ?
    for k,v in other
      @table[k.to_sym] = v
    end
    self
  end

  # Merge hash data creating a new OpenStruct object.
  #
  #   o = OpenStruct.new
  #   o.ostruct_merge { :a => 2 }
  #   o.a  #=> 2
  #
  def ostruct_merge(other)
    o = dup
    o.ostruct_update(other)
    o
  end

  ##
  # TO BE DEPRECATED
  # Must consider that accessing instance_delegate instead can be dangerous.
  # Might we us a Functor to ensure the table keys are always symbols?
  ##

  # Insert/update hash data on the fly.
  #
  #   o = OpenStruct.new
  #   o.ostruct_update { :a => 2 }
  #   o.a  #=> 2
  #
  def __update__(other)
    #other = other.to_hash #to_h?
    for k,v in other
      @table[k.to_sym] = v
    end
    self
  end

  # Merge hash data creating a new OpenStruct object.
  #
  #   o = OpenStruct.new
  #   o.ostruct_merge { :a => 2 }
  #   o.a  #=> 2
  #
  def __merge__(other)
    o = dup
    o.__update__(other)
    o
  end
end


class Hash

  # Turns a hash into a generic object using an OpenStruct.
  #
  #   o = { 'a' => 1 }.to_ostruct
  #   o.a  #=> 1
  #
  def to_ostruct
    OpenStruct.new(self)
  end

  # CREDIT Alison Rowland
  # CREDIT Jamie Macey
  # CREDIT Mat Schaffer

  #--
  # Special thanks to Alison Rowland, Jamie Macey and Mat Schaffer
  # for inspiring recursive improvements.
  #++

  # Like to_ostruct but recusively objectifies all hash elements as well.
  #
  #     o = { 'a' => { 'b' => 1 } }.to_ostruct_recurse
  #     o.a.b  #=> 1
  #
  # The +exclude+ parameter is used internally to prevent infinite
  # recursion and is not intended to be utilized by the end-user.
  # But for more advance use, if there is a particular subhash you
  # would like to prevent from being converted to an OpoenStruct
  # then include it in the +exclude+ hash referencing itself. Eg.
  #
  #     h = { 'a' => { 'b' => 1 } }
  #     o = h.to_ostruct_recurse( { h['a'] => h['a'] } )
  #     o.a['b']  #=> 1
  #
  def to_ostruct_recurse(exclude={})
    return exclude[self] if exclude.key?( self )
    o = exclude[self] = OpenStruct.new
    h = self.dup
    each_pair do |k,v|
      h[k] = v.to_ostruct_recurse( exclude ) if v.respond_to?(:to_ostruct_recurse)
    end
    o.__update__(h)
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

  class TestOpenStruct < Test::Unit::TestCase

    def setup
      @o = OpenStruct.new(:q => 1)
    end

    def test_update
      o = OpenStruct.new( { :a => 1 } )
      h = { :b => 2 }
      assert_nothing_raised { o.__update__( h ) }
      assert_equal( 2, o.b )
    end

    def test_merge_1
      o = OpenStruct.new( { :a => 1 } )
      h = { :b => 2 }
      q = o.__merge__( h )
      assert_equal( 1, q.a )
      assert_equal( 2, q.b )
    end

    def test_merge_2
      o1 = OpenStruct.new( { :a => 1 } )
      o2 = OpenStruct.new( { :b => 2 } )
      q = o1.__merge__( o2 )
      assert_equal( 1, q.a )
      assert_equal( 2, q.b )
    end

    def test_store
      @o.instance_delegate.store(:a,1)
      assert_equal( 1, @o.a )
    end

    def test_update
      @o.instance_delegate.update(:a=>1)
      assert_equal( 1, @o.a )
    end

    def test_op_fetch
      o = OpenStruct.new( { :a => 1 } )
      assert_equal( 1, o[:a] )
    end

    def test_op_store
      o = OpenStruct.new( { :a => 1 } )
      assert_nothing_raised { o[:b] = 2 }
      assert_equal( 2, o.b )
    end

    def test_update
      o = OpenStruct.new( { :a => 1 } )
      h = { :b => 2 }
      assert_nothing_raised { o.__update__( h ) }
      assert_equal( 2, o.b )
    end

    def test_merge_1
      o = OpenStruct.new( { :a => 1 } )
      h = { :b => 2 }
      q = o.__merge__( h )
      assert_equal( 1, q.a )
      assert_equal( 2, q.b )
    end

    def test_merge_2
      o1 = OpenStruct.new( { :a => 1 } )
      o2 = OpenStruct.new( { :b => 2 } )
      q = o1.__merge__( o2 )
      assert_equal( 1, q.a )
      assert_equal( 2, q.b )
    end

  end


  class TestHashToOpenStruct < Test::Unit::TestCase

    def test_to_ostruct
      a = { :a => 1, :b => 2, :c => 3 }
      ao = a.to_ostruct
      assert_equal( a[:a], ao.a )
      assert_equal( a[:b], ao.b )
      assert_equal( a[:c], ao.c )
    end

    def test_to_ostruct_recurse
      a = { :a => 1, :b => 2, :c => { :x => 4 } }
      ao = a.to_ostruct_recurse
      assert_equal(  a[:a], ao.a )
      assert_equal(  a[:b], ao.b )
      assert_equal(  a[:c][:x], ao.c.x )
    end

    def test_to_ostruct_recurse_with_recursion
      a = {}
      a[:a] = a
      ao = a.to_ostruct_recurse
      assert_equal( ao, ao.a )
    end

    def test_to_ostruct_advanced
      h = { 'a' => { 'b' => 1 } }
      o = h.to_ostruct_recurse( { h['a'] => h['a'] } )
      assert_equal( 1, o.a['b'] )
      assert( Hash === o.a )
    end

  end

=end

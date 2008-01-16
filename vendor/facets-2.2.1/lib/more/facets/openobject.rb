# TITLE:
#
#   OpenObject
#
# DESCRIPTION:
#
#   Similar to Ruby's own OpenStruct, but alittle more bold.
#   It will override any method, where as OpenStruct will not.
#
# AUTHOR:
#
#   - Thomas Sawyer
#   - George Moschovitis
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


require 'facets/conversion'   # to_h, to_proc
require 'facets/kernel/object' # object_class, object_hexid

# = OpenObject
#
# OpenObject is very similar to Ruby's own OpenStruct, but it offers some
# useful advantages. With OpenStruct slots with the same name's as predefined
# Object methods can not be used. With OpenObject any slot can be defined,
# OpendObject is also a bit faster becuase it is based on a Hash, not
# method signitures.
#
# Because OpenObject is a subclass of Hash, it can do just about
# everything a Hash can do, except that most public methods have been
# made protected and thus available only internally or via #send.
#
# OpenObject will also clobber any method for which a slot is defined.
# Even generally very important methods can be clobbered, like
# instance_eval. So be aware of this. OpenObject should be used in well
# controlled scenarios.
#
# If you wish to pass an OpenObject to a routine that normal takes a Hash,
# but are uncertain it can handle the distictions properly  you can convert
# easily to a Hash using #to_hash! and the result will automatically be
# converted back to an OpenObject on return.
#
#   o = OpenObject.new(:a=>1,:b=>2)
#   o.as_hash!{ |h| h.update(:a=>6) }
#   o #=> #<OpenObject {:a=>6,:b=>2}>
#
# Finally, unlike a regular Hash, all OpenObject's keys are symbols and
# all keys are converted to such using #to_sym on the fly.

class OpenObject < Hash

  PUBLIC_METHODS = /(^__|^instance_|^object_|^\W|^as$|^send$|^class$|\?$)/

  protected *public_instance_methods.select{ |m| m !~ PUBLIC_METHODS }

  def self.[](hash=nil)
    new(hash)
  end

  # Inititalizer for OpenObject is slightly differnt than that of Hash.
  # It does not take a default parameter, but an initial priming Hash
  # as with OpenStruct. The initializer can still take a default block
  # however. To set the degault value use ++#default!(value)++.
  #
  #   OpenObject(:a=>1).default!(0)

  def initialize( hash=nil, &yld )
    super( &yld )
    hash.each { |k,v| define_slot(k,v) } if hash
  end

  def initialize_copy( orig )
    orig.each { |k,v| define_slot(k,v) }
  end

  # Object inspection. (Careful, this can be clobbered!)

  def inspect
    "#<#{object_class}:#{object_hexid} #{super}>"
  end

  # Conversion methods. (Careful, these can be clobbered!)

  def to_a() super end

  def to_h() {}.update(self) end
  def to_hash() {}.update(self) end

  def to_proc() super  end

  def to_openobject() self end

  # Iterate over each key-value pair. (Careful, this can be clobbered!)

  def each(&yld) super(&yld) end

  # Merge one OpenObject with another creating a new OpenObject.

  def merge( other )
    d = dup
    d.send(:update, other)
    d
  end

  # Update this OpenObject with another.

  def update( other )
    begin
      other.each { |k,v| define_slot(k,v) }
    rescue
      other = other.to_h
      retry
    end
  end

  #

  def delete(key)
    super(key.to_sym)
  end

  # Set the default value.

  def default!(default)
    self.default = default
  end

  # Preform inplace action on OpenObject as if it were a regular Hash.
  #--
  # TODO Not so sure about #as_hash!. For starters if it doesn't return a hash it will fail.
  # TODO Replace by using #as(Hash). Perhaps as_hash and as_object shortcuts? Why?
  #++

  def as_hash!(&yld)
    replace(yld.call(to_hash))
  end

  # Check equality. (Should equal be true for Hash too?)

  def ==( other )
    return false unless OpenObject === other
    super(other) #(other.send(:table))
  end

  def []=(k,v)
    protect_slot(k)
    super(k.to_sym,v)
  end

  def [](k)
    super(k.to_sym)
  end

  protected

    def store(k,v)
      super(k.to_sym,v)
      define_slot(k)
    end

    def fetch(k,*d,&b)
      super(k.to_sym,*d,&b)
    end

    def define_slot( key, value=nil )
      protect_slot( key )
      self[key.to_sym] = value
    end

    def protect_slot( key )
      (class << self; self; end).class_eval {
        protected key rescue nil
      }
    end

    def method_missing( sym, arg=nil, &blk)
      type = sym.to_s[-1,1]
      key = sym.to_s.sub(/[=?!]$/,'').to_sym
      if type == '='
        define_slot(key,arg)
      elsif type == '!'
        define_slot(key,arg)
        self
      else
        self[key]
      end
    end

end

# Core Extensions

class NilClass
  # Nil converts to an empty OpenObject.

  def to_openobject
    OpenObject.new
  end
end

class Hash
  # Convert a Hash into an OpenObject.

  def to_openobject
    OpenObject[self]
  end
end

class Proc
  # Translates a Proc into an OpenObject. By droping an OpenObject into
  # the Proc, the resulting assignments incured as the procedure is
  # evaluated produce the OpenObject. This technique is simlar to that
  # of MethodProbe.
  #
  #   p = lambda { |x|
  #     x.word = "Hello"
  #   }
  #   o = p.to_openobject
  #   o.word #=> "Hello"
  #
  # NOTE The Proc must have an arity of one --no more and no less.

  def to_openobject
    raise ArgumentError, 'bad arity for converting Proc to openobject' if arity != 1
    o = OpenObject.new
    self.call( o )
    o
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

  class TestOpenObject1 < Test::Unit::TestCase

    def test_1_01
      o = OpenObject.new
      assert( o.respond_to?(:key?) )
    end

    def test_1_02
      assert_instance_of( OpenObject, OpenObject[{}] )
    end

    def test_1_03
      f0 = OpenObject.new
      f0[:a] = 1
      #assert_equal( [1], f0.to_a )
      assert_equal( {:a=>1}, f0.to_h )
    end

    def test_1_04
      f0 = OpenObject[:a=>1]
      f0[:b] = 2
      assert_equal( {:a=>1,:b=>2}, f0.to_h )
    end

    def test_1_05
      f0 = OpenObject[:class=>1]
      assert_equal( 1, f0.class )
    end
  end

  class TestOpenObject2 < Test::Unit::TestCase

    def test_2_01
      f0 = OpenObject[:f0=>"f0"]
      h0 = { :h0=>"h0" }
      assert_equal( OpenObject[:f0=>"f0", :h0=>"h0"], f0.send(:merge,h0) )
      assert_equal( {:f0=>"f0", :h0=>"h0"}, h0.merge( f0 ) )
    end

    def test_2_02
      f1 = OpenObject[:f1=>"f1"]
      h1 = { :h1=>"h1" }
      f1.send(:update,h1)
      h1.update( f1 )
      assert_equal( OpenObject[:f1=>"f1", :h1=>"h1"], f1 )
      assert_equal( {:f1=>"f1", :h1=>"h1"}, h1 )
    end

    def test_2_03
      o = OpenObject[:a=>1,:b=>{:x=>9}]
      assert_equal( 9, o[:b][:x] )
      assert_equal( 9, o.b[:x] )
    end

    def test_2_04
      o = OpenObject["a"=>1,"b"=>{:x=>9}]
      assert_equal( 1, o["a"] )
      assert_equal( 1, o[:a] )
      assert_equal( {:x=>9}, o["b"] )
      assert_equal( {:x=>9}, o[:b] )
      assert_equal( 9, o["b"][:x] )
      assert_equal( nil, o[:b]["x"] )
    end

  end

  class TestOpenObject3 < Test::Unit::TestCase
    def test_3_01
      fo = OpenObject.new
      9.times{ |i| fo.send( "n#{i}=", 1 ) }
      9.times{ |i|
        assert_equal( 1, fo.send( "n#{i}" ) )
      }
    end
  end

  class TestOpenObject4 < Test::Unit::TestCase

    def test_4_01
      ho = {}
      fo = OpenObject.new
      5.times{ |i| ho["n#{i}".to_sym]=1 }
      5.times{ |i| fo.send( "n#{i}=", 1 ) }
      assert_equal(ho, fo.to_h)
    end

  end

  class TestOpenObject5 < Test::Unit::TestCase

    def test_5_01
      p = lambda { |x|
        x.word = "Hello"
      }
      o = p.to_openobject
      assert_equal( "Hello", o.word )
    end

    def test_5_02
      p = lambda { |x|
        x.word = "Hello"
      }
      o = OpenObject[:a=>1,:b=>2]
      assert_instance_of( Proc, o.to_proc )
    end

  end

=end

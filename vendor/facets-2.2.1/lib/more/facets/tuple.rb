# TITLE:
#
#   Tuple
#
# DESCRIPTION:
#
#   A Tuple is essentially a immutable Array.
#
# AUTHOR:
#
#   - Thomas Sawyer
#
# LICENSE:
#
#   Copyright (c) 2005 Thomas Sawyer
#
#   Ruby License
#
#   This module is free software. You may use, modify, and/or
#   redistribute this software under the same terms as Ruby.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# TODO:
#
#   - The #hash method needs a touch-up.
#
#   - There are a few more methods yet to borrow from Array.
#     Consider how #+, #-, etc. ought to work.


require 'facets/multiton'

# = Tuple
#
# Tuple is essentially an Array, but Comaparable and Immutable.
#
# A tuple can be made using #new or #[] just as one builds an array,
# or using the #to_t method on a string or array. With a string tuple
# remembers the first non-alphanumeric character as the tuple divider.
#
# == Usage
#
#   t1 = Tuple[1,2,3]
#   t2 = Tuple[2,3,4]
#
#   t1 < t2   #=> true
#   t1 > t2   #=> false
#
#   t1 = '1.2.3'.to_t
#   t2 = '1-2-3'.to_t
#
#   puts t1  #=> 1.2.3
#   puts t2  #=> 1-2-3
#
#   t1 == t2  #=> true
#
# Keep in mind that Tuple[1,2,3] is not the same as Tuple['1','2','3'].

class ::Tuple

  include ::Multiton
  include ::Enumerable
  include ::Comparable

  def self.multiton_id(arg=0, default=0, &block)
    if block_given?
      values = []
      arg.times { |i| values << block[i] }
    elseif Integer === arg
      values = [ default ] * arg
    else
      values = arg.to_ary
    end
    values
  end

  def initialize(arg=0, default=0, &blk)
    if block_given?
      @values = []
      arg.times { |i| @values << blk[i] }
    elseif Integer === arg
      @values = [ default ] * arg
    else
      @values = arg.to_ary
    end
    @default = default
    @divider = '.'
  end

  attr_accessor :default

  def divider( set=nil )
    return @divider unless set
    @divider = set
    self
  end

protected

  def values() @values end

public

  def inspect() to_a.inspect end

  def to_t()     self end
  def to_tuple() self end

  def to_a()   Array(@values) end
  def to_ary() Array(@values) end

  def to_s( divider=nil )
    @values.join(divider||@divider)
  end

  def size()   @values.size end
  def length() @values.size end

  def empty?()
    return true if @values.empty?
    return true if @values == [ @default ] * @values.size
    false
  end

  def each( &block )
    @values.each( &block )
  end

  def each_index( &block )
    @values.each_index( &block )
  end

  def [](i)
    @values.fetch(i,@default)
  end

  def []=(i,v)
    @values[i] = v
  end

  def index()  @values.index end
  def rindex() @values.rindex end

  # Unlike Array, Tuple#<< cannot act in place
  # becuase Tuple's are immutable.
  def <<( obj )
    self.class.instance( to_a << obj )
  end

  def pop() Tuple.instance( to_a.pop ) end

  def push( obj ) Tuple.instance( to_a.push(obj) ) end

  # Pulls a value off the beginning of a tuple.
  # This method is otherwsie known as #shift.
  def pull() Tuple.instance( to_a.shift ) end

  # Stands for "Put On Top". This method is the opposite of #pull and is
  # otherwise known as #unshift.
  def pot( obj ) Tuple.instance( to_a.unshift(obj) ) end

  alias_method :unshift, :pot
  alias_method :shift, :pull

  # Returns true if two tuple references are for the
  # very same tuple.
  def eql?( other )
    return true if object_id == other.object_id
    #return true if values.eql? other.values
  end

  def <=>( other )
    other = other.to_t
    [size, other.size].max.times do |i|
      c = self[i] <=> other[i]
      return c if c != 0
    end
    0
  end

  # For pessimistic constraint (like '~>' in gems)
  def =~( other )
    other = other.to_t
    upver = other.dup
    upver[0] += 1
    self >= other and self < upver
  end

  def first() @values.first end
  def last()  @values.last end

  # These are useful for using a Tuple as a version.
  def major() @values.first end
  def minor() @values.at(1) end
  def teeny() @values.at(2) end

  # Unique hash value.
  def hash
    # TODO This needs to take into account the default
    #      and maybe the divider too.
    to_a.hash
  end

  # class-level -----------------------------------------------

  class << self

    def []( *args )
      instance( args )
    end

    # Translates a string in the form on a set of numerical and/or
    # alphanumerical characters separated by non-word characters (eg \W+)
    # into a Tuple. The values of the tuple will be converted to integers
    # if they are purely numerical.
    #
    #   Tuple.cast_from_string('1.2.3a')  #=> [1,2,"3a"]
    #
    # It you would like to control the interpretation of each value
    # as it is added to the tuple you can supply a block.
    #
    #   Tuple.cast_from_string('1.2.3a'){ |v| v.upcase }  #=> ["1","2","3A"]
    #
    # This method is called by String#to_t.

    def cast_from_string( str, &yld )
      args = str.to_s.split(/\W+/)
      div = /\W+/.match( str.to_s )[0]
      if block_given?
        args = args.collect{ |a| yld[a] }
      else
        args = args.collect { |i| /^[0-9]+$/ =~ i ? i.to_i : i }
      end
      self.instance( args ).divider( div )
    end

    #

    def cast_from_array( arr )
      self.instance( arr )
    end

    # Parses a constraint returning the operation as a lambda.

    def constraint_to_lambda( constraint, &yld )
      op, val = *parse_constraint( constraint, &yld )
      lambda { |t| t.send(op, val) }
    end

    def parse_constraint( constraint, &yld )
      constraint = constraint.strip
      re = %r{^(=~|~>|<=|>=|==|=|<|>)?\s*(\d+(:?[-.]\d+)*)$}
      if md = re.match( constraint )
        if op = md[1]
          op = '=~' if op == '~>'
          op = '==' if op == '='
          val = cast_from_string( md[2], &yld ) #instance( md[2] )
        else
          op = '=='
          val = cast_from_string( constraint, &yld ) #instance( constraint )
        end
      else
        raise ArgumentError, "invalid constraint"
      end
      return op, val
    end

  end

end


# Conveniently turn a string into a tuple.

class ::String

  # Translates a string in the form on a set of numerical and/or
  # alphanumerical characters separated by non-word characters (eg \W+)
  # into a Tuple. The values of the tuple will be converted to integers
  # if they are purely numerical.
  #
  #   '1.2.3a'.to_t  #=> [1,2,"3a"]
  #
  # It you would like to control the interpretation of each value
  # as it is added to the tuple you can supply a block.
  #
  #   '1.2.3a'.to_t { |v| v.upcase }  #=> ["1","2","3A"]
  #
  # This method calls Tuple.cast_from_string.

  def to_t( &yld )
    Tuple.cast_from_string( self, &yld )
  end

end


# Convert and array into a tuple.

class ::Array

  def to_t
    Tuple.cast_from_array( self )
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

  class TC_Tuple < Test::Unit::TestCase

    def test_01
      t1 = Tuple[1,2,3]
      t2 = Tuple[2,4,5]
      assert( t1 < t2 )
      assert( t2 > t1 )
    end

    def test_02
      t1 = Tuple[1,2,3]
      a1 = t1.to_a
      assert( Array === a1 )
    end

    def test_03
      t1 = Tuple[1,2,3]
      t2 = Tuple[1,2,3]
      assert( t1.object_id === t2.object_id )
    end

    def test_04
      t1 = Tuple[1,2,3]
      t1 = t1 << 4
      assert( Tuple === t1 )
      t2 = Tuple[1,2,3,4]
      assert( t1.object_id == t2.object_id )
    end

    def test_05
      t1 = "1.2.3".to_t
      assert( Tuple === t1 )
      t2 = Tuple[1,2,3]
      assert( t1.object_id == t2.object_id )
    end

    def test_06
      t1 = "1.2.3a".to_t
      assert( Tuple === t1 )
      t2 = Tuple[1,2,'3a']
      assert_equal( t2, t1 )
      assert( t2.object_id == t1.object_id )
    end

  end

=end

# TITLE:
#
#   Association
#
# DESCRIPTION:
#
#   General binary association allows one object to be
#   associated to another.
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
#   This module is free software. You may use, modify, and/or redistribute this
#   software under the same terms as Ruby.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
#   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#   FOR A PARTICULAR PURPOSE.


# = Association
#
# General binary association allows one object to be
# associated with another. It has a variety of uses,
# link-lists, simple ordered maps and mixed collections,
# among them.
#
# == Usage
#
# Associations can be used to draw simple relationships.
#
#   :Apple >> :Fruit
#   :Apple >> :Red
#
#   :Apple.associations #=> [ :Fruit, :Red ]
#
# It can also be used for simple lists of ordered pairs.
#
#   c = [ :a >> 1, :b >> 2 ]
#   c.each { |k,v| puts "#{k} associated with #{v} }
#
# produces
#
#   a associated with 1
#   b associated with 2
#
# == Limitations
#
# The method :>> is used to construct the association.
# It is a rarely used method so it is generally available.
# But you can't use an Association while extending
# any of the following classes becuase they use #>> for
# other things.
#
#   Bignum
#   Fixnum
#   Date
#   IPAddr
#   Process::Status
#

class Association

  include Comparable

  attr_accessor :index, :value

  def self.[](*args)
    new(*args)
  end

  def initialize(index, value=nil)
    @index = index
    @value = value
  end

  def <=>(assoc)
     return -1 if self.value < assoc.value
     return 1 if self.value > assoc.value
     return 0 if self.value == assoc.value
  end

  def invert!
    temp = @index
    @index = @value
    @value = temp
  end

  def to_s
    return "#{index.to_s}#{value.to_s}"
  end

  def inspect
    %{#{@index.inspect} >> #{@value.inspect}}
  end

  def to_ary
    [ @index, @value ]
  end

end


module Kernel

  ASSOCIATIONS = Hash.new{ |h,k,v| h[k]=[] }

  # Define an association with +self+.
  def >>(to)
    ASSOCIATIONS[self] << to
    Association.new(self, to)
  end

  def associations
    ASSOCIATIONS[self]
  end

end


#--
# Setup the >> method in classes that use it  already.
#
# This is a bad idea b/c it can cause backward compability issues.
#
# class Bignum
#   alias_method( :rshift, :>>) if method_defined?(:>>)
#   remove_method :>>
# end
#
# class Fixnum
#   alias_method( :rshift, :>>) if method_defined?(:>>)
#   remove_method :>>
# end
#
# class Date
#   alias_method( :months_later, :>>) if method_defined?(:>>)
#   remove_method :>>
# end
#
# class IPAddr
#   alias_method( :rshift, :>>) if method_defined?(:>>)
#   remove_method :>>
# end
#
# class Process::Status
#   alias_method( :rshift, :>>) if method_defined?(:>>)
#   remove_method :>>
# end
#++

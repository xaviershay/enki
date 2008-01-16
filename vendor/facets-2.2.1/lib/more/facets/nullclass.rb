# TITLE:
#
#   NullClass
#
# SUMMARY:
#
#   NullClass is essentially NilClass but it differs in one
#   important way. When a method is called against it that it
#   deoesn't have, it will simply return null value rather then
#   raise an error.
#
# COPYRIGHT:
#
#   Copyright (c) 2005 Thomas Sawyer
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


# = NullClass
#
# NullClass is essentially NilClass but it differs in one
# important way. When a method is called against it that it
# deoesn't have, it will simply return null value rather then
# raise an error.

class NullClass #< NilClass
  class << self
    def new
      @null ||= NullClass.allocate
    end
  end
  def inspect ; 'null' ; end
  def nil?  ; true ; end
  def null? ; true ; end
  def [](key); nil; end
  def method_missing(sym, *args)
    return nil if sym.to_s[-1,1] == '?'
    self
  end
end

module Kernel
  def null
    NullClass.new
  end
end

class Object
  def null?
    false
  end
end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

# TODO

=begin #testing
=end

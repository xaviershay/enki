# = TITLE:
#
#   Boolean
#
# = DESCRIPTION:
#
#   Stackable mixin provides #pop, #push, #pull, etc.
#   It depends on #slice, #splice and #insert.
#
# = COPYRIGHT:
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
#
# = AUTHORS:
#
#   - Thomas Sawyer
#
# = NOTES:
#
#   - This was suggested by Ara T. Howard

#
class String

  # Interpret common affirmative string meanings as true,
  # otherwise false. Balnk sapce and case are ignored.
  # The following strings that will return true:
  #
  #   <tt>true</tt>,<tt>yes</tt>,<tt>on</tt>,<tt>t</tt>,<tt>1</tt>,<tt>y</tt>,<tt>==</tt>
  #
  # Examples:
  #
  #   "true".to_b   #=> true
  #   "yes".to_b    #=> true
  #   "no".to_b     #=> false
  #   "123".to_b    #=> false
  #
  def to_b
    case self.downcase.strip
    when 'true', 'yes', 'on', 't', '1', 'y', '=='
      return true
    when 'nil', 'null'
      return nil
    else
      return false
    end
  end

end


class Array

  # Boolean conversion for not empty?
  def to_b
    ! self.empty?
  end

end


class Numeric

  # Provides a boolean interpretation of self.
  # If self == 0 then false else true.
  #
  #   0.to_b    #=> false
  #   1.to_b    #=> true
  #   2.3.to_b  #=> true
  #
  def to_b
    self == 0 ? false : true
  end

end


module Kernel

  # Boolean conversion for not being nil or false.
  # Other classes may redefine this to suite the
  # particular need.
  #
  #   "abc".to_b   #=> true
  #   true.to_b    #=> true
  #   false.to_b   #=> false
  #   nil.to_b     #=> false
  #
  def to_b
    self ? true : false
  end

  # Returns true is an object is class TrueClass,
  # otherwise false.
  #
  #   true.true?   #=> true
  #   false.true?  #=> false
  #   nil.true?    #=> false
  #
  def true?
    (true == self)
  end

  # Returns true is an object is class FalseClass,
  # otherwise false.
  #
  #   true.false?   #=> false
  #   false.false?  #=> true
  #   nil.false?    #=> false
  #
  def false?
    (false == self)
  end

  # Returns true is an object is class TrueClass
  # or FalseClass, otherwise false.
  #
  #   true.bool?   #=> true
  #   false.bool?  #=> true
  #   nil.bool?    #=> false
  #
  def bool?
    (true == self or false == self)
  end

end


class Object
  def to_bool
    return true
  end
end

class TrueClass
  def to_bool
    self
  end
end

class FalseClass
  def to_bool
    self
  end
end

class NilClass
  def to_bool
    false
  end
end

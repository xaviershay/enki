######################################
# WARNING! Highly expiremental code! #
######################################
# TITLE:
#
#   RWDelegator
#
# SUMMARY:
#
#   Read from one object and write to another.
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


# = RWDelegator
#
# Read from one object and write to another.
class RWDelegator

  def initialize( write, &read )
    @read = read
    @write = write

    # ensure other classes can deduce equality.
    read_class = @read.call.object_class
    unless read_class.method_defined?(:eq_with_rwdelegator?)
      read_class.class_eval %{
        def eq_with_rwdelegator?( other )
          if RWDelegator === other
            other == self
          else
            eq_without_rwdelegator?(other)
          end
        end
        alias_method :eq_without_rwdelegator?, :==
        alias_method :==, :eq_with_rwdelegator?
      }
    end
  end

  def inspect
    "#<#{object_class} #{@read.call.inspect}>"
  end

  def ==( other )
    @read.call == other
  end

  def method_missing( meth, *args, &blk )
    read = @read.call
    ditto = read.dup
    result = ditto.send( meth, *args, &blk )
    if ditto != read
      result = @write.send( meth, *args, &blk )
    end
    result
  end

end




# TITLE:
#
#   VersionNumber
#
# DESCRIPTION:
#
#   VersionNumber is a simplified form of a Tuple class
#   desgined specifically for dealing with version numbers.
#
# AUTHOR:
#
#   - Thomas Sawyer (7rans)
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
#
# TODO:
#
#   - Maybe add Kernel method #version ?
#
#   - If Tuple were standard part of Ruby this probably would
#     not be needed or at least might be simple sublcass instead.


# = VersionNumber
#
# VersionNumber is a simplified form of a Tuple class
# desgined specifically for dealing with version numbers.
#
class VersionNumber #< Tuple

  #include Enumerable
  include Comparable

  def initialize( *args )
    args = args.join('.').split(/\W+/)
    @self = args.collect { |i| i.to_i }
  end

  def to_s ; @self.join('.') ; end

  # This is here only becuase File.join calls it instead of to_s.

  def to_str ; @self.join('.') ; end

  def inspect
    @self.to_s
  end

  def [](i)
    @self.fetch(i,0)
  end

  # "Spaceship" comparsion operator.

  def <=>( other )
    #other = other.to_t
    [@self.size, other.size].max.times do |i|
      c = @self[i] <=> other[i]
      return c if c != 0
    end
    0
  end

  # For pessimistic constraint (like '~>' in gems)

  def =~( other )
    #other = other.to_t
    upver = other.dup
    upver[0] += 1
    @self >= other and @self < upver
  end

  # Major is the first number in the version series.

  def major ; @self[0] ; end

  # Minor is the second number in the version series.

  def minor ; @self[1] || 0 ; end

  # Teeny is third number in the version series.

  def teeny ; @self[2] || 0 ; end

  # Delegate to the array.

  def method_missing( sym, *args, &blk )
    @self.send(sym, *args, &blk ) rescue super
  end

  # Parses a string constraint returning the operation as a lambda.

  def self.constraint_lambda( constraint )
    op, val = *parse_constraint( constraint )
    lambda { |t| t.send(op, val) }
  end

  def self.parse_constraint( constraint )
    constraint = constraint.strip
    re = %r{^(=~|~>|<=|>=|==|=|<|>)?\s*(\d+(:?[-.]\d+)*)$}
    if md = re.match( constraint )
      if op = md[1]
        op = '=~' if op == '~>'
        op = '==' if op == '='
        val = new( *md[2].split(/\W+/) )
      else
        op = '=='
        val = new( *constraint.split(/\W+/) )
      end
    else
      raise ArgumentError, "invalid constraint"
    end
    return op, val
  end

end

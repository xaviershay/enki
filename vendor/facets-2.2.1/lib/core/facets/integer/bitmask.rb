class Integer

  # Set a bit.
  #
  #   0.bit!(4)  #=> 8
  #
  # Using an inverted bit will clear a bit.
  #
  #   10.bit!(~3)      #=> 2
  #   0xb0100.bit(~3)  #=> 0
  #
  #   CREDIT: Thomas Sawyer
  #   CREDIT: George Moschovitis

  def bit(bit)
    if bit < 0
      mask = (1 << ~bit)
      self & ~mask
    else
      mask = (1 << bit)
      self | mask
    end
  end

  # Old name. Probably will be deprecated.
  alias_method :bit!, :bit

  # Clear bit.
  #
  #   CREDIT: George Moschovitis

  def clear_bit(bit)
    mask = (1 << bit)
    self & ~mask
  end

  # Is a bit set?
  #
  #   8.bit?(3)  #=> true
  #   8.bit?(2)  #=> false
  #
  #   CREDIT: Thomas Sawyer
  #   CREDIT: George Moschovitis

  def bit?(bit)
    mask = (1 << bit)
    (self & mask) != 0
  end

  # Apply a bitmask.
  #
  #   1.bitmask(6) #=> 7
  #
  # Using a inverted bitmask clears bits.
  #
  #   7.bitmask(~2) #=> 5
  #   5.bitmask(~2) #=> 5
  #
  #   CREDIT: George Moschovitis

  def bitmask(mask)
    if mask < 0
      self & mask
    else
      self | mask
    end
  end

  # Old name. Probably will be deprecated.
  alias_method :bitmask!, :bitmask

  # Is bitmask set?
  #
  #   7.bitmask?(7) #=> true
  #   7.bitmask?(5) #=> true
  #   8.bitmask?(3) #=> false
  #
  #   CREDIT: George Moschovitis

  def bitmask?(mask)
    (self & mask) != 0
  end

end


module Kernel

  # Create a single bit bitmask.
  #
  #   Bit(0)  #=> 1
  #   Bit(1)  #=> 2
  #   Bit(2)  #=> 4
  #
  # This is equivalent to n-shift: "1 << n".
  #
  #   CREDIT: Thomas Sawyer
  #   CREDIT: George Moschovitis

  def Bit(n)
    1 << Integer(n)
  end

end

class Integer

  # Calculate the factorial of an integer.
  #
  #   2.factorial  #=> 2
  #   3.factorial  #=> 6
  #   3.factorial  #=> 24
  #
  #  CREDIT: Malte Milatz

  def factorial
    return 1 if zero?
    f = 1
    2.upto(self) { |n| f *= n }
    f
  end

  alias_method( :fac, :factorial )

  #-- OLD CODE
  #def factorial
  #  return 1 if self == 0
  #  #self == 0 ? 1 : ( self * (self-1).factorial )
  #  f = (1..self.abs).inject { |state, item| state * item }
  #  return self < 0 ? -f : f
  #end
  #++

end

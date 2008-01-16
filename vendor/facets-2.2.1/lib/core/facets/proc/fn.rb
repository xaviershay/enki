module Kernel

  # A nice shorthand for lambda.
  #
  #   adder = fn { |x,y| x + y }
  #   adder[1,2]  #=> 3
  #
  #   CREDIT: Trans

  alias_method :fn, :lambda

end

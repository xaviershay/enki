class Proc

  # Returns a new proc that is the functional
  # composition of two procs, in order.
  #
  #   a = lambda { |x| x + 4 }
  #   b = lambda { |y| y / 2 }
  #
  #   a.compose(b).call(4)  #=> 6
  #   b.compose(a).call(4)  #=> 4
  #
  #   CREDIT: Dave

  def compose(g)
    raise ArgumentError, "arity count mismatch" unless arity == g.arity
    lambda{ |*a| self[ *g[*a] ] }
  end

  # Operator for Proc#compose and Integer#times_collect/of.
  #
  #   a = lambda { |x| x + 4 }
  #   b = lambda { |y| y / 2 }
  #
  #   (a * b).call(4)  #=> 6
  #   (b * a).call(4)  #=> 4
  #
  #   CREDIT: Dave

  def *(x)
    if Integer===x
      # collect times
      c = []
      x.times{|i| c << call(i)}
      c
    else
      # compose procs
      lambda{|*a| self[x[*a]]}
    end
  end

end

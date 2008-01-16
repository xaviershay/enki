class Numeric

  # See Float#round_at.

  def round_at(*args)
    to_f.round_at(*args)
  end

  # See Float#round_to.

  def round_to(*args)
    to_f.round_to(*args)
  end

  # Determines if another number is approximately equal
  # within a given _n_th degree. Defaults to 100ths
  # if the degree is not specified.
  #
  #   CREDIT: Trans

  def approx?(x, n=0.01)
    return(self == x) if n == 0
    (self - x).abs <= n
  end

end


class Integer

  # See Float#round_at.

  def round_at(*args)
    to_f.round_at(*args)
  end

  # See Float#round_to.

  def round_to(*args)
    to_f.round_to(*args)
  end

end


class Float

  # Float#round_off is simply an alias for Float#round.
  alias_method :round_off, :round

  # Rounds to the given decimal position.
  #
  #   4.555.round_at(0)  #=> 5.0
  #   4.555.round_at(1)  #=> 4.6
  #   4.555.round_at(2)  #=> 4.56
  #   4.555.round_at(3)  #=> 4.555
  #
  #   CREDIT: Trans

  def round_at( d ) #d=0
    (self * (10.0 ** d)).round_off.to_f / (10.0 ** d)
  end

  # Rounds to the nearest _n_th degree.
  #
  #   4.555.round_to(1)     #=> 5.0
  #   4.555.round_to(0.1)   #=> 4.6
  #   4.555.round_to(0.01)  #=> 4.56
  #   4.555.round_to(0)     #=> 4.555
  #
  #   CREDIT: Trans

  def round_to( n ) #n=1
    return self if n == 0
    (self * (1.0 / n)).round_off.to_f / (1.0 / n)
  end

end

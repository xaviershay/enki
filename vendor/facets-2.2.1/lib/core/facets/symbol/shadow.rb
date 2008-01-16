class Symbol

  # Easily manipulate undercores on symbols.
  #
  #   :a.pad(2)         #=> :__a__
  #   :__a__.pad(-1)    #=> :_a_
  #
  #   CREDIT: Trans

  def shadow(i=1)
    return self if i == 0
    s = self.to_s
    if i > 0
      return ( ('_'*i) + self.to_s + ('_'*i) ).to_sym
    else
      i *= -1
      return s[i..-i-1].to_sym if s[0..i-1] == ('_'*i) and s[-i..-1] == ('_'*i)
      return self
    end
  end
  alias :pad :shadow

end

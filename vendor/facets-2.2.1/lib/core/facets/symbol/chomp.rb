class Symbol

  # Just like String#chomp.
  #
  #   :ab.chomp(:b)  #=> :a
  #
  #   CREDIT: Trans

  def chomp(seperator)
    to_s.chomp(seperator.to_s).to_sym
  end

  # Just like String#lchomp.
  #
  #   :ab.lchomp(:a)  #=> :b
  #
  #   CREDIT: Trans

  def lchomp(seperator)
    to_s.reverse.chomp(seperator.to_s).reverse.to_sym
  end

end

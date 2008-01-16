class Array

  # Alias for <tt>|</tt>.
  #
  #   [1,2].merge [2,3]  #=> [1,2,3]
  #
  #   CREDIT: Trans

  alias_method :merge, :|

  # In place #merge.
  #
  #   a = [1,2]
  #   a.merge! [2,3]
  #   a => [1,2,3]
  #
  #   CREDIT: Trans

  def merge!( other )
    self.replace( self | other )
  end

end

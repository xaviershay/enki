class Symbol

  # Does a symbol have a "not" sign?
  #
  #   "friend".to_sym.not?   #=> false
  #   "~friend".to_sym.not?  #=> true
  #
  #   CREDIT: Trans

  def not?
    self.to_s.slice(0,1) == '~'
  end

  # Add a "not" sign to the front of a symbol.
  #
  #   ~:friend    #=> :"~friend"
  #
  #   CREDIT: Trans

  def ~@
    if self.to_s.slice(0,1) == '~'
      "#{self.to_s[1..-1]}".to_sym
    else
      "~#{self}".to_sym
    end
  end

end

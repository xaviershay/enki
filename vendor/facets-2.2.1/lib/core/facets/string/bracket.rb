class String

  BRA2KET = { '['=>']', '('=>')', '{'=>'}', '<'=>'>' }

  # Return a new string embraced by given brakets.
  # If only one bracket char is given it will be placed
  # on either side.
  #
  #   "wrap me".bracket('{')        #=> "{wrap me}"
  #   "wrap me".bracket('--','!')   #=> "--wrap me!"
  #
  #   CREDIT: Trans

  def bracket(bra, ket=nil)
    #ket = String.bra2ket[$&] if ! ket && /^[\[({<]$/ =~ bra
    ket = BRA2KET[bra] unless ket
    "#{bra}#{self}#{ket ? ket : bra}"
  end

  # Inplace version of #braket.
  #
  #   CREDIT: Trans

  def bracket!(bra, ket=nil)
    self.replace(bracket(bra, ket))
  end

  # Return a new string embraced by given brakets.
  # If only one bracket char is given it will be placed
  # on either side.
  #
  #   "{unwrap me}".debracket('{')        #=> "unwrap me"
  #   "--unwrap me!".debracket('--','!')  #=> "unwrap me!"
  #
  #   CREDIT: Trans

  def unbracket(bra=nil, ket=nil)
    if bra
      ket = BRA2KET[bra] unless ket
      ket = ket ? ket : bra
      s = self.dup
      s.gsub!(%r[^#{Regexp.escape(bra)}], '')
      s.gsub!(%r[#{Regexp.escape(ket)}$], '')
      return s
    else
      if m = BRA2KET[ self[0,1] ]
        return self.slice(1...-1) if self[-1,1]  == m
      end
    end
    return self.dup  # if nothing else
  end

  # Inplace version of #debraket.
  #
  #   CREDIT: Trans

  def unbracket!(bra=nil, ket=nil)
    self.replace( unbracket(bra, ket) )
  end

  # Return a new string embraced by given quotes.
  # If no quotes are specified, then assumes single quotes.
  #
  #   "quote me".quote     #=> "'quote me'"
  #   "quote me".quote(2)  #=> "\"quote me\""
  #
  #   CREDIT: Trans

  def quote(type=:s)
    case type.to_s.downcase
    when 's', 'single'
      bracket("'")
    when 'd', 'double'
      bracket('"')
    when 'b', 'back'
      bracket('`')
    else
      bracket("'")
    end
  end

  # Remove quotes from string.
  #
  #   "'hi'".dequite    #=> "hi"
  #
  #   CREDIT: Trans

  def dequote
    s = self.dup

    case self[0,1]
    when "'", '"', '`'
      s[0] = ''
    end

    case self[-1,1]
    when "'", '"', '`'
      s[-1] = ''
    end

    return s
  end
end

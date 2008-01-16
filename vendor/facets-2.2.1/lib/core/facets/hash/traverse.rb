class Hash

  # Returns a new hash created by traversing the hash and its subhashes,
  # executing the given block on the key and value. The block should
  # return a 2-element array of the form +[key, value]+.
  #
  #   h = { "A"=>"A", "B"=>"B" }
  #   g = h.traverse { |k,v| [k.downcase, v] }
  #   g  #=> { "a"=>"A", "b"=>"B" }
  #
  #
  #   CREDIT: Trans
  #
  #--
  # TODO Testing value to see if it is a Hash also catches subclasses of Hash.
  #      This is probably not the right thing to do and should catch Hashes only (?)
  #++

  def traverse(&b)
    inject({}) do |h,(k,v)|
      v = ( Hash === v ? v.traverse(&b) : v )
      nk, nv = b[k,v]
      h[nk] = nv #( Hash === v ? v.traverse(base,&b) : nv )
      h
    end
  end

  # In place version of traverse, which traverses the hash and its
  # subhashes, executing the given block on the key and value.
  #
  #   h = { "A"=>"A", "B"=>"B" }
  #   h.traverse! { |k,v| [k.downcase, v] }
  #   h  #=> { "a"=>"A", "b"=>"B" }
  #
  #   CREDIT: Trans

  def traverse!(&b)
    self.replace( self.traverse(&b) )
  end

end

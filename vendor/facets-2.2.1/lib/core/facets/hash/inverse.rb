class Hash

  # Create a "true" inverse hash by storing mutliple values
  # in Arrays.
  #
  #   h = {"a"=>3, "b"=>3, "c"=>3, "d"=>2, "e"=>9, "f"=>3, "g"=>9}
  #
  #   h.invert                #=> {2=>"d", 3=>"f", 9=>"g"}
  #   h.inverse               #=> {2=>"d", 3=>["f", "c", "b", "a"], 9=>["g", "e"]}
  #   h.inverse.inverse       #=> {"a"=>3, "b"=>3, "c"=>3, "d"=>2, "e"=>9, "f"=>3, "g"=>9}
  #   h.inverse.inverse == h  #=> true
  #
  #   CREDIT: Tilo Sloboda

  def inverse
    i = Hash.new
    self.each_pair{ |k,v|
      if (Array === v)
        v.each{ |x| i[x] = ( i.has_key?(x) ? [k,i[x]].flatten : k ) }
      else
        i[v] = ( i.has_key?(v) ? [k,i[v]].flatten : k )
      end
    }
    return i
  end

end

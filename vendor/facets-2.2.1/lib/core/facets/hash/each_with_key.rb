class Hash

  # Each with key is like each_pair but reverses the order
  # the parameters to [value,key] instead of [key,value].
  #
  #   CREDIT: Trans

  def each_with_key( &yld )
    each_pair{ |k,v| yld.call(v,k) }
  end

end

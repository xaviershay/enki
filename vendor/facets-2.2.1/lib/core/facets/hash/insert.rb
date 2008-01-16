class Hash

  # As with #store but only if the key isn't
  # already in the hash.
  #
  # TODO: Would #store? be a better name?
  #
  #   CREDIT: Trans

  def insert(name, value)
    if key?(name)
      false
    else
      store(name,value)
      true
    end
  end

end

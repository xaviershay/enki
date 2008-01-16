class Hash

  # Returns a new hash with only the given keys.

  def slice(*keep_keys)
    h = {}
    keep_keys.each do |key|
      h[key] = fetch(key)
    end
    h
  end

  # Replaces hash with a new hash having only the given keys.
  # This return the hash of keys removed.

  def slice!(*keep_keys)
    removed = except(*keep_keys)
    replace(slice(*keep_keys))
    removed
  end

end


class Hash

  # Returns a new hash less the given keys.

  def except(*less_keys)
    slice(*keys - less_keys)
  end

  # Replaces hash with new hash less the given keys.
  # This returns the hash of keys removed.
  #
  #   h = {:a=>1, :b=>2, :c=>3}
  #   h.except!(:a)  #=> {:a=>1}
  #   h              #=> {:b=>2,:c=>3}
  #
  def except!(*less_keys)
    removed = slice(*less_keys)
    replace(except(*less_keys))
    removed
  end

end


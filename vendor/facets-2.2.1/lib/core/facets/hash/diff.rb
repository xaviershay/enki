class Hash

  # Difference comparison of two hashes.
  #
  #   CREDIT: ?
  #
  # TODO:
  #   - Rewrite #diff to be more readable.
  #   - Rename #diff to #difference or something else?

  def diff(h2)
    dup.send(:delete_if){|k,v| h2[k] == v}.send(:merge,h2.dup.send(:delete_if){ |k,v| has_key?(k) })
  end

end

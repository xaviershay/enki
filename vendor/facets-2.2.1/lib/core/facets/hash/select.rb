class Hash

  # In-place version of Hash#select.  The opposite of the built-in
  # Hash#reject!.
  #
  #   CREDIT Gavin Sinclair
  #   CREDIT Noah Gibbs

  def select!
    reject! { |k,v| not yield(k,v) }
  end

end


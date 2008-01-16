class Hash

  # Return a new hash with the specified entries.
  #
  #   {:a=>1,:b=>2}.pairs_at(:a,:c)  #=> {:a=>1, :c=>nil}
  #
  # The later form is equivalent to #pairs_at.
  #
  #   CREDIT: Trans

  def pairs_at( *keys )
    keys.inject({}) {|h,k| h[k] = self[k]; h}
  end

end

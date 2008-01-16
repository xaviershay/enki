class Hash

  # Swap the values of a pair of keys in place.
  #
  #   {:a=>1,:b=>2}.swap!(:a,:b)  #=> {:a=>2,:b=>1}
  #
  #   CREDIT: Gavin Sinclair

  def swap!( key1, key2 )
    tmp = self[key1]
    self[key1] = self[key2]
    self[key2] = tmp
    self
  end

  # Modifies the receiving Hash so that the value previously referred to by
  # _oldkey_ is referenced by _newkey_; _oldkey_ is removed from the Hash.
  # If _oldkey_ does not exist as a key in the Hash, no change is effected.
  #
  # Returns a reference to the Hash.
  #
  #   foo = { :a=>1, :b=>2 }
  #   foo.swapkey!('a',:a)       #=> { 'a'=>1, :b=>2 }
  #   foo.swapkey!('b',:b)       #=> { 'a'=>1, 'b'=>2 }
  #   foo.swapkey!('foo','bar')  #=> { 'a'=>1, 'b'=>2 }
  #
  # DEPRECATED!!! Use #rekey instead.
  #
  #   CREDIT: Gavin Sinclair

  def swapkey!( newkey, oldkey )
    self[newkey] = self.delete(oldkey) if self.has_key?(oldkey)
    self
  end

end

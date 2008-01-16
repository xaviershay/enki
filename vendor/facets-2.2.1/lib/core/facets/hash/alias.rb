class Hash

  # Modifies the receiving Hash so that the value previously referred to by
  # _oldkey_ is also referenced by _newkey_; _oldkey_ is retained in the Hash.
  # If _oldkey_ does not exist as a key in the Hash, no change is effected.
  #
  # Returns a reference to the Hash.
  #
  #   foo = { :name=>'Gavin', 'wife'=>:Lisa }
  #   foo.alias!('name',:name)     => { :name=>'Gavin', 'name'=>'Gavin', 'wife'=>:Lisa }
  #
  #   foo = { :name=>'Gavin', 'wife'=>:Lisa }
  #   foo.alias!('spouse','wife')  => { :name=>'Gavin', 'wife'=>:Lisa, 'spouse'=>:Lisa }
  #
  #   foo = { :name=>'Gavin', 'wife'=>:Lisa }
  #   foo.alias!('bar','foo')      => { :name=>'Gavin', 'wife'=>:Lisa }
  #
  # Note that if the _oldkey_ is reassigned, the reference will no longer exist,
  # and the _newkey_ will remain as it was.
  #
  #   CREDIT: Gavin Sinclair

  def alias!( newkey, oldkey )
    self[newkey] = self[oldkey] if self.has_key?(oldkey)
    self
  end

end

class Hash

  # NOTE: These methods are largely usurped by Hash#rekey.
  #       They remain available for the time being for improved
  #       intercompability with Rail's ActiveSupport library.

  # Converts all keys in the Hash accroding to the given block.
  # If the block return +nil+ for given key, then that key will be
  # left intact.
  #
  #   foo = { :name=>'Gavin', :wife=>:Lisa }
  #   foo.normalize_keys{ |k| k.to_s }  #=>  { "name"=>"Gavin", "wife"=>:Lisa }
  #   foo.inspect                       #=>  { :name =>"Gavin", :wife=>:Lisa }
  #
  #   CREDIT: Trans
  #   CREDIT: Gavin Sinclair

  def normalize_keys( &block )
    dup.send(:normalize_keys!, &block)
  end

  # Synonym for Hash#normalize_keys, but modifies the receiver in place (and returns it).
  #
  #   foo = { :name=>'Gavin', :wife=>:Lisa }
  #   foo.normalize_keys!{ |k| k.to_s }  #=>  { "name"=>"Gavin", "wife"=>:Lisa }
  #   foo.inspect                        #=>  { "name"=>"Gavin", "wife"=>:Lisa }
  #
  #   CREDIT: Trans
  #   CREDIT: Gavin Sinclair

  def normalize_keys!( &block )
    keys.each{ |k|
      nk = block[k]
      self[nk]=delete(k) if nk
    }
    self
  end

  # Converts all keys in the Hash to Strings, returning a new Hash.
  # With a +filter+ parameter, limits conversion to only a certain selection of keys.
  #
  #   foo = { :name=>'Gavin', :wife=>:Lisa }
  #   foo.stringify_keys    #=>  { "name"=>"Gavin", "wife"=>:Lisa }
  #   foo.inspect           #=>  { :name =>"Gavin", :wife=>:Lisa }
  #
  #   CREDIT: Trans
  #   CREDIT: Gavin Sinclair

  def stringify_keys( &filter )
    if filter
      normalize_keys{ |k| filter[k] ? k.to_s : nil }
    else
      normalize_keys{ |k| k.to_s }
    end
  end

  alias_method(:keys_to_s, :stringify_keys)

  # Synonym for Hash#stringify_keys, but modifies the receiver in place and returns it.
  # With a +filter+ parameter, limits conversion to only a certain selection of keys.
  #
  #   foo = { :name=>'Gavin', :wife=>:Lisa }
  #   foo.stringify_keys!    #=>  { "name"=>"Gavin", "wife"=>:Lisa }
  #   foo.inspect            #=>  { "name"=>"Gavin", "wife"=>:Lisa }
  #
  #   CREDIT: Trans
  #   CREDIT: Gavin Sinclair

  def stringify_keys!( &filter )
    if filter
      normalize_keys!{ |k| filter[k] ? k.to_s : nil }
    else
      normalize_keys!{ |k| k.to_s }
    end
  end

  alias_method( :keys_to_s!, :stringify_keys!)

  # Converts all keys in the Hash to Symbols, returning a new Hash.
  # With a +filter+, limits conversion to only a certain selection of keys.
  #
  #   foo = { :name=>'Gavin', 'wife'=>:Lisa }
  #   foo.symbolize_keys    #=>  { :name=>"Gavin", :wife=>:Lisa }
  #   foo.inspect           #=>  { "name" =>"Gavin", "wife"=>:Lisa }
  #
  #   CREDIT: Trans
  #   CREDIT: Gavin Sinclair

  def symbolize_keys( &filter )
    if filter
      normalize_keys{ |k| filter[k] ? k.to_sym : nil }
    else
      normalize_keys{ |k| k.to_sym }
    end
  end

  alias_method( :keys_to_sym, :symbolize_keys )

  #--
  # # Rails has these aliases too, but they are not very good for
  # # gerenal use, IMHO. But perhaps someone can convince me otherwise.
  # alias_method( :to_options,  :symbolize_keys )
  #++

  # Synonym for Hash#symbolize_keys, but modifies the receiver in place and returns it.
  # With a +filter+ parameter, limits conversion to only a certain selection of keys.
  #
  #   foo = { 'name'=>'Gavin', 'wife'=>:Lisa }
  #   foo.symbolize_keys!    #=>  { :name=>"Gavin", :wife=>:Lisa }
  #   foo.inspect            #=>  { :name=>"Gavin", :wife=>:Lisa }
  #
  #   CREDIT: Trans
  #   CREDIT: Gavin Sinclair

  def symbolize_keys!( &filter )
    if filter
      normalize_keys!{ |k| filter[k] ? k.to_sym : nil }
    else
      normalize_keys!{ |k| k.to_sym }
    end

  end

  alias_method( :keys_to_sym!, :symbolize_keys! )

  #--
  # # Rails has these aliases too, but they are not very good for
  # # gerenal use, IMHO. But perhaps someone can convince me otherwise.
  # alias_method( :to_options!, :symbolize_keys! )
  #++

  # Converts all keys in the Hash to be String values, returning a new Hash.
  # With a from_class parameter, limits conversion to only a certain class of keys.
  # It defaults to nil which convert any key class.
  #
  #   foo = { :name=>'Gavin', :wife=>:Lisa }
  #   foo.variablize_keys    #=>  { "@name"=>"Gavin", "@wife"=>:Lisa }
  #   foo.inspect            #=>  { :name =>"Gavin", :wife=>:Lisa }
  #
  #   CREDIT: Trans
  #   CREDIT: David Hansson


  def variablize_keys( of_class=nil )
    self.dup.variablize_keys!( of_class )
  end

  # Synonym for Hash#keys_to_string, but modifies the receiver in place (and returns it).
  # With a from_class parameter, limits conversion to only a certain class of keys.
  # It defaults to nil which convert any key class.
  #
  #   foo = { :name=>'Gavin', :wife=>:Lisa }
  #   foo.variablize_keys!   #=>  { "@name"=>"Gavin", "@wife"=>:Lisa }
  #   foo.inspect            #=>  { "@name"=>"Gavin", "@wife"=>:Lisa }
  #
  #   CREDIT: Trans
  #   CREDIT: David Hansson

  def variablize_keys!( of_class=nil )
    raise ArgumentError, "Parameter must be a class" unless of_class.kind_of?(Class) if of_class
    if of_class
      self.each_key do |k|
        if k.respond_to?(:to_s) and k.class == of_class
          k = k.to_s
          nk = k[0,1] != '@' ? k : "@#{k}"
          self[nk]=self.delete(k)
        end
      end
    else
      self.each_key do |k|
        if k.respond_to?(:to_s)
          k = k.to_s
          nk = k[0,1] != '@' ? k : "@#{k}"
          self[nk]=self.delete(k)
        end
      end
    end
    self
  end

end

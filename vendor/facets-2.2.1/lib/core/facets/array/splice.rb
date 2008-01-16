class Array

  # Store a value at a givne index.
  # Store is an alias for #[]=.

  alias_method :store, :[]=

  # Splice acts a combination of #slice! and #store.
  # If two arguments are given it calls #store.
  # If a single argument is give it calls slice!.
  #
  #   a = [1,2,3]
  #   a.splice(1)    #=> 2
  #   a              #=> [1,3]
  #
  #   a = [1,2,3]
  #   a.splice(1,4)  #=> 4
  #   a              #=>[1,4,3]
  #
  #   CREDIT: Trans

  def splice(*args)
    if args.size == 1
      slice!(*args)
    else
      store(*args)
    end
  end

end

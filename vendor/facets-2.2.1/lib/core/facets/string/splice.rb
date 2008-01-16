class String

  # Alias for []=.
  alias_method :store, :[]=

  # Like #slice, but writes rather than reads.
  # Like #store, but acts like slice!
  # when given only one argument.
  #
  #   a = "HELLO"
  #   a.splice(1)    #=> "E"
  #   a              #=> "HLLO"
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

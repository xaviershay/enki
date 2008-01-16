class Integer

  # Like #times but returns a collection of the yield results.
  #
  #   a = 3.of { |i| "#{i+1}" }
  #   a => [ "1", "2", "3" ]
  #

  def of(&block)
    Array.new(self, &block)
  end

  #def of(&yld)
  #  a = []; self.times{ |i| a << yld.call(i) }
  #  a
  #end

  # Time warn aliases for #of.
  alias_method :times_collect, :of
  alias_method :times_map, :of

end

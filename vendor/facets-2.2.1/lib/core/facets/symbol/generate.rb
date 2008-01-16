class Symbol

  # Generate a unique symbol.
  #
  #   Symbol.generate => :<1>
  #
  # If +suffix+ is given the new symbol will be suffixed with it.
  #
  #   Symbol.generate(:this) => :<2>this
  #
  #   TODO: Is the generated symbol format acceptable?
  #
  #   CREDIT: Trans

  def self.generate(suffix=nil)
    @symbol_generate_counter ||= 0
    ("<%X>#{suffix}" % @symbol_generate_counter += 1).to_sym
  end

end

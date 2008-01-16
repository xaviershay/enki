class Hash

  # Use division operator as a fetch notation.
  #
  #   h = {:a=>1}
  #   h / :a  #=> 1

  alias_method :/, :[]

end

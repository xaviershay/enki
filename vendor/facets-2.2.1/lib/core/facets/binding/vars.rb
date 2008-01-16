# TITLE:
#
#   Binding Variables
#
# SUMMARY:
#
#   Access binding variables. This requires the #eval.

require 'facets/binding/eval.rb'

#
class Binding

  # Returns the local variables defined in the binding context
  #
  #   a = 2
  #   binding.local_variables  #=> ["a"]
  #
  def local_variables()
    eval("local_variables")
  end

  # Returns the value of some variable.
  #
  #   a = 2
  #   binding["a"]  #=> 2
  #
  def []( x )
    eval( x.to_s )
  end

  # Set the value of a local variable.
  #
  #   binding["a"] = 4
  #   a  #=> 4
  #
  def []=( l, v )
    eval( "lambda {|v| #{l} = v}").call( v )
  end

end

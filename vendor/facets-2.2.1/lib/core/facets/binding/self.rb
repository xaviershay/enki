require 'facets/binding/eval'

class Binding

  # Returns self of the binding context.

  def self()
    @self ||= eval("self")
    @self
  end

end

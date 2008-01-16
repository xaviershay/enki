# TITLE:
#   Binding CallStack Extensions
#
# SUMMARY:
#   Binding methods related to current cflow.

require 'facets/binding/eval'
require 'facets/kernel/callstack'

#
class Binding

  # Returns the call stack, same format as Kernel#caller()

  def caller( skip=0 )
    eval("caller(#{skip})")
  end

  # Returns the call stack, in array format.

  def call_stack(level=1)
    eval( "call_stack( #{level} )" )
  end

  # Returns line number.

  def __LINE__
    eval("__LINE__")
  end

  # Returns file name.

  def __FILE__
    eval("__FILE__")
  end

  # Return the directory of the file.

  def __DIR__
    eval("File.dirname(__FILE__)")
  end

  # Retreive the current running method.
  #
  #   def tester; p called; end
  #   tester  #=> :tester
  #

  def __callee__
    name = /\`([^\']+)\'/.match(caller(1).first)[1]
    return name.to_sym
  end

  # Backward compatability.
  alias_method :called, :__callee__

  # There is a lot of debate on what to call this.
  # +method_name+ differs from #called only by the fact
  # that it returns a string, rather then a symbol.
  #
  #   def tester; p methodname; end
  #   tester  #=> "tester"

  def __method__
    name = /\`([^\']+)\'/.match(caller(1).first)[1]
    return name
  end

  # Backward compatability.
  alias_method :methodname, :__method__

end

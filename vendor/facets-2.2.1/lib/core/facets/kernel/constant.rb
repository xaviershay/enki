module Kernel

  # This is similar to +Module#const_get+ but is accessible at all levels,
  # and, unlike +const_get+, can handle module hierarchy.
  #
  #   constant("Fixnum")                  # -> Fixnum
  #   constant(:Fixnum)                   # -> Fixnum
  #
  #   constant("Process::Sys")            # -> Process::Sys
  #   constant("Regexp::MULTILINE")       # -> 4
  #
  #   require 'test/unit'
  #   Test.constant("Unit::Assertions")   # -> Test::Unit::Assertions
  #   Test.constant("::Test::Unit")       # -> Test::Unit
  #
  #   CREDIT: Trans

  def constant(const)
    const = const.to_s.dup
    base = const.sub!(/^::/, '') ? Object : ( self.kind_of?(Module) ? self : self.class )
    const.split(/::/).inject(base){ |mod, name| mod.const_get(name) }
  end

end

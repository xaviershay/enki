# = TITLE:
#
#   First Class Methods
#
# = SUMMARY:
#
#   Gives Ruby 1st class methods.
#
# = COPYRIGHT:
#
#   Copyright (c) 2005 Thomas Sawyer
#
#   Ruby License
#
#   This module is free software. You may use, modify, and/or redistribute this
#   software under the same terms as Ruby.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
#   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#   FOR A PARTICULAR PURPOSE.
#
# = AUTHORS:
#
#   - Thomas Sawyer
#
# = NOTES:
#
#   First Class Methods
#
#   I think the best solution would be using the notation
#   <tt>::ameth</tt>. This would require some minor changes
#   to Ruby, but with few backward incompatabilites if
#   parantheticals revert back to the actual method invocation.
#   Although this later stipulation means capitalized methods
#   would not be accessible in this way b/c they would intefere with
#   constant lookup. It's a trade off.
#
#                   Current           Proposed           Alternate
#                   ----------------- ------------------ -------------------
#     Foo.Bar()     method call       method call        method call
#     Foo.Bar       method call       method call        method call
#     Foo.bar()     method call       method call        method call
#     Foo.bar       method call       method call        method call
#     Foo::Bar()    method call       method call        1st class method
#     Foo::Bar      constant lookup   constant lookup    constant lookup
#     Foo::bar()    method call       method call        1st class method
#     Foo::bar      method call       1st class method   1st class method
#
#   Then again this dosen't address bound versus unbound.
#
#   Which do you prefer?

#
module Kernel

  # Easy access to method as objects, and they retain state!
  #
  #   def hello
  #     puts "Hello World!"
  #   end
  #
  #   m1 = method!(:hello)   #=> <Method: #hello>
  #
  #   def m1.annotate
  #     "simple example"
  #   end
  #
  #   m2 = method!(:hello)
  #   m2.annotate  #=> "simple example"

  def method!(s)
    ( @__methods__ ||= {} )[s] ||= method(s)
  end

  private

  # Returns the method object of the current method.
  #--
  # TODO Should there be a be a #this! ?
  #++
  def this
    line = nil
    caller(1).each do |line|
      line = /\`([^\']+)\'/.match(line)
      break if line
    end
    if line
      name = line[1]
      return method(name)
    else
      nil # ?
    end
  end

end

#
class Module

  # Easy access to method as objects, and they retain state!
  #
  #   module K
  #     def hello
  #       puts "Hello World!"
  #     end
  #   end
  #   p K.instance_method!(:hello)   #=> <UnboundMethod: #hello>
  #
  # CAUTION! This it is currently limited to the scope of the
  # current module/class.

  def instance_method!(s)
    #( @@__instance_methods__ ||= {} )[s] ||= instance_method(s)  # TODO when fixed
    ( @__instance_methods__ ||= {} )[s] ||= instance_method(s)
  end

end

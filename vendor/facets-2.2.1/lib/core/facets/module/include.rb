class Module

  # An alias for #include.
  #
  #   class X
  #     is Enumerable
  #   end
  #
  #   CREDIT: Trans

  #alias_method :is, :include

  def is(*mods)
    mods.each do |mod|
      if mod.const_defined?(:Self)
        extend mod::Self
        # pass it along if module
        if instance_of?(Module)
          const_set(:Self, Module.new) unless const_defined?(:Self)
          const_get(:Self).send(:include, mod::Self)
        end
      end
    end
    include(*mods)
  end

  # Expirmental idea for #is.
  #
  # If the module has #append_function_function
  # defined, this will use that instead of #include.
  #
  #   def is(*modules)
  #     module.each do { |m|
  #       if m.respond_to?(:append_feature_function)
  #         send(m.append_feature_function,m)
  #       else
  #         include m
  #       end
  #     end
  #   end

  # An alias for #extend.
  #
  #   class X
  #     can Forwardable
  #   end
  #
  # BTW, why if Forwardable an -able? It's not a mixin!

  alias_method :can, :extend

  # Is a given class or module an ancestor of this
  # class or module?
  #
  #  class X ; end
  #  class Y < X ; end
  #
  #   Y.is?(X)  #=> true
  #
  #   CREDIT: Trans

  def is?(base)
    ancestors.slice(1..-1).include?( base )
  end

  # Is a given class or module an ancestor of
  # this class or module?
  #
  #  class X ; end
  #  class Y < X ; end
  #
  #   X.ancestor?(Y)

  def ancestor?( mod )
    ancestors.include? mod
  end

  # Alias for #===. This provides a verbal method
  # for inquery.
  #
  #   s = "HELLO"
  #   s.class? String   #=> true
  #
  #   CREDIT: Trans

  alias_method :class?, :===

  # DEPRECATED
  #   # Both includes and extends a module.
  #   #
  #   #   NOTE: If #include and/or #extend returned thier modules then
  #   #         one could just do:
  #   #
  #   #             extend(*include(M1, M2, ...))
  #   #
  #   #   CREDIT: Trans
  #
  #   def include_and_extend(*mods)
  #     include *mods
  #     extend *mods
  #   end

  # Include module and apply module_fuction to the
  # included methods.
  #
  #   CREDIT: Trans

  def include_function_module *mod
    include(*mod)
    module_function(*mod.collect{|m| m.private_instance_methods & m.methods(false)}.flatten)
  end

  # NOTE: include_as is now in more library namespace.rb.

  # A macro for dynamic modules.
  #
  #    TODO: This method ecourages a bad practice, and should not be used.
  #          It's here because Nitro uses it, but eventually it will be deprecated.
  #
  #  CREDIT: George Moschovitis

  def on_included(code)
    tag = caller[0].split(' ').first.split(/\/|\\/).last.gsub(/:|\.|\(|\)/, '_')
    old = "__included_#{tag}"
    module_eval %{
      class << self
        alias_method :#{old}, :included
        def included(base)
          #{old}(base)
          #{code}
        end
      end
    }
  end

end


module Kernel

  # Convenience alias for #is_a? to go along with #is.
  #
  #   TODO: Somewhat confusing with Module#is?, should this be deprecated?

  alias_method :is?, :is_a?

end



# demonstration

=begin demo

  module T
    def t ; p self ; end
    def r ; p self ; end
    def q ; super ; end
  end

  class N
    def q ; puts "ho" ; end
  end

  class X < N
    include_as :test => T

    def n ; p test ; end
    def m ; test.t ; end
    def o ; test.r ; end
  end

  x = X.new
  x.n
  x.m
  x.o
  x.q

=end

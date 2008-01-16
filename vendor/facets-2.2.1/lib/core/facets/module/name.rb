class Module

  # <em>Note: the following documentation uses "class" because it's more common, but it
  # applies to modules as well.</em>
  #
  # Given the _name_ of a class, returns the class itself (i.e. instance of Class).  The
  # dereferencing starts at Object.  That is,
  #
  #   Class.by_name("String")
  #
  # is equivalent to
  #
  #   Object.const_get("String")
  #
  # The parameter _name_ is expected to be a Symbol or String, or at least to respond to
  # <tt>to_str</tt>.
  #
  # An ArgumentError is raised if _name_ does not correspond to an existing class.  If _name_
  # is not even a valid class name, the error you'll get is not defined.
  #
  # Examples:
  #
  #   Class.by_name("String")             # -> String
  #   Class.by_name("::String")           # -> String
  #   Class.by_name("Process::Sys")       # -> Process::Sys
  #   Class.by_name("GorillaZ")           # -> (ArgumentError)
  #
  #   Class.by_name("Enumerable")         # -> Enumerable
  #   Module.by_name("Enumerable")        # -> Enumerable
  #
  #   CREDIT: Gavin Sinclair

  def by_name(name)
    #result = Object.constant(name)
    # TODO: Does self need to be Object in the following lines?
    const  = name.to_s.dup
    base   = const.sub!(/^::/, '') ? Object : ( self.kind_of?(Module) ? self : self.class )
    result = const.split(/::/).inject(base){ |mod, subconst| mod.const_get(subconst) }

    return result if result.kind_of?( Module )
    raise ArgumentError, "#{name} is not a module or class"
  end

  # Returns the root name of the module/class.
  #
  #   module Example
  #     class Demo
  #     end
  #   end
  #
  #   Demo.name       #=> Example::Demo
  #   Demo.basename   #=> Demo
  #
  # For anonymous modules this will provide a basename
  # based on Module#inspect.
  #
  #   m = Module.new
  #   m.inspect       #=> "#<Module:0xb7bb0434>"
  #   m.basename      #=> "Module_0xb7bb0434"
  #
  #   CREDIT: Trans

  def basename
    if name and not name.empty?
      name.gsub(/^.*::/, '')
    else
      nil #inspect.gsub('#<','').gsub('>','').sub(':', '_')
    end
  end

  # Returns the name of module's container module.
  #
  #   module Example
  #     class Demo
  #     end
  #   end
  #
  #   Demo.name       #=> "Example::Demo"
  #   Demo.dirname    #=> "Example"
  #
  # See also Module#basename.
  #
  #   CREDIT: Trans

  def dirname
    name[0...(name.rindex('::') || 0)]
    #name.gsub(/::[^:]*$/, '')
  end

  # Returns the module's container module.
  #
  #   module Example
  #     class Demo
  #     end
  #   end
  #
  #   Demo.modspace    #=> Example
  #
  # See also Module#basename.
  #
  #   CREDIT: Trans

  def modspace
    space = name[ 0...(name.rindex( '::' ) || 0)]
    space.empty? ? Object : eval(space)
  end

  # Show a modules nesting in module namespaces.
  #
  #   A::B::C.nesting  #=> [ A, A::B ]
  #
  #   CREDIT: Trans

  def nesting
    n = []
    name.split(/::/).inject(self) do |mod, name|
      c = mod.const_get(name) ; n << c ; c
    end
    return n
  end

end

# TITLE:
#
#   Module Alias Extensions
#
# FILE:
#
#   module/alias.rb
#
# DESCRIPTION:
#
#   Module alias extensions.
#
# AUTHORS:
#
#   CREDIT Thomas Saywer
class Module

  private

  # As with alias_method, but alias both reader and writer.
  #
  #   attr_accessor :x
  #   self.x = 1
  #   alias_accessor :y, :x
  #   y #=> 1
  #   self.y = 2
  #   x #=> 2

  def alias_accessor(*args)
    orig = args.last
    args = args - [orig]
    args.each do |name|
      alias_method(name, orig)
      alias_method("#{name}=", "#{orig}=")
    end
  end

  # As with alias_accessor, but just for the reader.
  # This is basically the same as alias_method.

  def alias_reader(*args)
    orig = args.last
    args = args - [orig]
    args.each do |name|
      alias_method(name, orig)
    end
  end

  # As with alias_method but does the writer instead.

  def alias_writer(*args)
    orig = args.last
    args = args - [orig]
    args.each do |name|
      alias_method("#{name}=", "#{orig}=")
    end
  end

  # Like module_function but makes the instance method
  # public rather than private.
  #
  #   NOTE: This does not work as a sectional modifier.

  def module_method(*meth)
    module_function(*meth)
    public(*meth)
  end

  # Alias a module function so that the alias is also
  # a module function. The typical #alias_method
  # does not do this.
  #
  #   module Demo
  #     module_function
  #     def hello
  #       "Hello"
  #     end
  #   end
  #
  #   Demo.hello    #=> Hello
  #
  #   module Demo
  #     alias_module_function( :hi , :hello )
  #   end
  #
  #   Demo.hi       #=> Hello
  #
  def alias_module_function( new, old )
    alias_method( new, old )
    module_function( new )
  end

  # Encapsulates the common pattern of:
  #
  #   alias_method :foo_without_feature, :foo
  #   alias_method :foo, :foo_with_feature
  #
  # With this, you simply do:
  #
  #   alias_method_chain :foo, :feature
  #
  # And both aliases are set up for you.
  #
  # Query and bang methods (foo?, foo!) keep the same punctuation:
  #
  #   alias_method_chain :foo?, :feature
  #
  # is equivalent to
  #
  #   alias_method :foo_without_feature?, :foo?
  #   alias_method :foo?, :foo_with_feature?
  #
  # so you can safely chain foo, foo?, and foo! with the same feature.
  #
  #   CREDIT: Bitsweat
  #   CREDIT: Rails Team

  def alias_method_chain(target, feature)
    # Strip out punctuation on predicates or bang methods since
    # e.g. target?_without_feature is not a valid method name.
    aliased_target, punctuation = target.to_s.sub(/([?!=])$/, ''), $1
    yield(aliased_target, punctuation) if block_given?

    with_method, without_method = "#{aliased_target}_with_#{feature}#{punctuation}", "#{aliased_target}_without_#{feature}#{punctuation}"

    alias_method without_method, target
    alias_method target, with_method

    case
      when public_method_defined?(without_method)
        public target
      when protected_method_defined?(without_method)
        protected target
      when private_method_defined?(without_method)
        private target
    end
  end

end

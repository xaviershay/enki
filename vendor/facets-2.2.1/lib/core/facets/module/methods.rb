class Module

  # List all instance_methods, equivalent to
  #
  #   public_instance_methods +
  #   protected_instance_methods +
  #   private_instance_methods
  #
  #   CREDIT: Trans

  def all_instance_methods(include_super=true)
    public_instance_methods(include_super) +
    protected_instance_methods(include_super) +
    private_instance_methods(include_super)
  end

  # Query whether an instance method is defined for the module.
  #
  #   CREDIT: Gavin Sinclair
  #   CREDIT: Noah Gibbs


  def instance_method_defined?(meth)
    instance_methods(true).find { |m| m == meth.to_s }
  end

  # Query whether a normal (singleton) method is defined for the module.
  #
  #   CREDIT: Gavin Sinclair
  #   CREDIT: Noah Gibbs

  def module_method_defined?(meth)
    singleton_methods(true).find { |m| m == meth.to_s }
  end

end

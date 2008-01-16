class Class

  # List all descedents of this class.
  #
  #   class X ; end
  #   class A < X; end
  #   class B < X; end
  #   X.descendents  #=> [A,B]
  #
  # NOTE: This is a intesive operation. Do not
  # expect it to be super fast.

  def descendents
    subclass = []
    ObjectSpace.each_object( Class ) do |c|
      if c.ancestors.include?( self ) and self != c
        subclass << c
      end
    end
    return subclass
  end

  # Obvious alias for descendents.

  alias_method :subclasses, :descendents

  # Remove descendents. This simple deletes the constant
  # associated to the descendents name.

  def remove_descendents
    self.descendents.each do |subclass|
      Object.send(:remove_const, subclass.name) rescue nil
    end
    ObjectSpace.garbage_collect
  end

  # Obvious alias for remove_descendents.

  alias_method :remove_subclasses, :remove_descendents

end

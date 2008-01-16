require 'facets/class/descendents'

class Class

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

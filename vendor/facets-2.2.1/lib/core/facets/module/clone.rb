class Module

  # Returns an anonymous module with the specified methods
  # of the receiving module renamed.
  #
  #   NOTE: These is likely to be usurped by traits.rb.
  #
  #   CREDIT: Trans

  def clone_renaming( pairs )
    mod = self.dup
    pairs.each_pair{ |to_sym, from_sym|
      mod.class_eval{
        alias_method( to_sym, from_sym )
        undef_method( from_sym )
      }
    }
    return mod
  end

  # Returns an anonymous module with the specified methods
  # of the receiving module removed.
  #
  #   NOTE: These is likely to be usurped by traits.rb.
  #
  #   CREDIT: Trans

  def clone_removing( *meths )
    mod = self.dup
    methods_to_remove = meths
    methods_to_remove.each{ |m|  mod.class_eval{ remove_method m }  }
    return mod
  end

  # Returns an anonymous module with only the specified methods
  # of the receiving module intact.
  #
  #   NOTE: These is likely to be usurped by traits.rb.
  #
  #   CREDIT: Trans

  def clone_using( *methods )
    methods.collect!{ |m| m.to_s }
    methods_to_remove = instance_methods - methods
    mod = self.dup
    mod.class_eval{ methods_to_remove.each{ |m| undef_method m } }
    return mod
  end

end

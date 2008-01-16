module Kernel

  # Anything that can be marshaled can be copied in totality.
  # This is also commonly called a deep_copy.
  #
  #   "ABC".copy  #=> "ABC"
  #
  def copy
    Marshal::load(Marshal::dump(self))
  end

  alias_method :deep_copy, :copy

  # Adds deep_clone method to an object which produces deep copy of it. It means
  # if you clone a Hash, every nested items and their nested items will be cloned.
  # Moreover deep_clone checks if the object is already cloned to prevent endless recursion.
  #
  #   obj = []
  #   a = [ true, false, obj ]
  #   b = a.deep_clone
  #   obj.push( 'foo' )
  #   p obj   # >> [ 'foo' ]
  #   p b[2]  # >> []
  #
  #   CREDIT: Jan Molic

  def deep_clone( obj=self, cloned={} )
    if cloned.has_key?( obj.object_id )
      return cloned[obj.object_id]
    else
      begin
        cl = obj.clone
      rescue Exception
        # unclonnable (TrueClass, Fixnum, ...)
        cloned[obj.object_id] = obj
        return obj
      else
        cloned[obj.object_id] = cl
        cloned[cl.object_id] = cl
        if cl.is_a?( Hash )
          cl.clone.each { |k,v|
            cl[k] = deep_clone( v, cloned )
          }
        elsif cl.is_a?( Array )
          cl.collect! { |v|
                  deep_clone( v, cloned )
          }
        end
        cl.instance_variables.each do |var|
          v = cl.instance_eval( var )
          v_cl = deep_clone( v, cloned )
          cl.instance_eval( "#{var} = v_cl" )
        end
        return cl
      end
    end
  end

end

class Hash

  # Weave is a very uniqe hash operator. I is designed
  # to merge to complex hashes in according to sensible,
  # regular pattern. The effect is akin to inheritance.
  #
  # Two hashes are weaved together to produce a new hash.
  # The two hashes need to be compatible according to the
  # following rules for each node:
  #
  #   <tt>
  #   hash,   hash    => hash (recursive +)
  #   hash,   array   => error
  #   hash,   value   => error
  #   array,  hash    => error
  #   array,  array   => array + array
  #   array,  value   => array << value
  #   value,  hash    => error
  #   value,  array   => array.unshift(valueB)
  #   value1, value2  => value2
  #   </tt>
  #
  # Here is a basic example:
  #
  #   h1 = { :a => 1, :b => [ 1 ], :c => { :x => 1 } }
  #   => {:b=>[1], :c=>{:x=>1}, :a=>1}
  #
  #   h2 = { :a => 2, :b => [ 2 ], :c => { :x => 2 } }
  #   => {:b=>[2], :c=>{:x=>2}, :a=>2}
  #
  #   h1.weave(h2)
  #   => {:b=>[1, 2], :c=>{:x=>2}, :a=>2}
  #
  # Weave follows the most expected pattern of unifying two complex
  # hashes. It is especially useful for implementing overridable
  # configuration schemes.
  #
  #   CREDIT: Thomas Sawyer

  def weave(h)
    raise ArgumentError, "Hash expected" unless h.kind_of?(Hash)
    s = self.clone
    h.each { |k,node|
      node_is_hash = node.kind_of?(Hash)
      node_is_array = node.kind_of?(Array)
      if s.has_key?(k)
        self_node_is_hash = s[k].kind_of?(Hash)
        self_node_is_array = s[k].kind_of?(Array)
        if self_node_is_hash
          if node_is_hash
            s[k] = s[k].weave(node)
          elsif node_is_array
            raise ArgumentError, 'Incompatible hash addition' #self[k] = node
          else
            raise ArgumentError, 'Incompatible hash addition' #self[k] = node
          end
        elsif self_node_is_array
          if node_is_hash
            raise ArgumentError, 'Incompatible hash addition' #self[k] = node
          elsif node_is_array
            s[k] += node
          else
            s[k] << node
          end
        else
          if node_is_hash
            raise ArgumentError, 'Incompatible hash addition' #self[k] = node
          elsif node_is_array
            s[k].unshift( node )
          else
            s[k] = node
          end
        end
      else
        s[k] = node
      end
    }
    s
  end

end

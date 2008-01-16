
class Array

  def recursively(&block)
    yield map do |item|
      if item.is_a?(self.class)
        item.recursively(&block)
      else
        item
      end
    end
  end

  def recursively!(&block)
    replace(recursively(&block))
  end

end


class Hash

  def recursively(&block)
    yeild inject({}) do |hash, (key, value)|
      if value.is_a?(Hash)
        hash[key] = value.recursively(&block)
      else
        hash[key] = value
      end
      hash
    end
  end

  def recursively!(&block)
    replace(recursively(&block))
  end

  # Same as Hash#merge but recursively merges sub-hashes.

  def recursive_merge(other)
    hash = self.dup
    other.each do |key, value|
      myval = self[key]
      if value.is_a?(Hash) && myval.is_a?(Hash)
        hash[key] = myval.recursive_merge(value)
      else
        hash[key] = value
      end
    end
    hash
  end

  # Same as Hash#merge! but recursively merges sub-hashes.

  def recursive_merge!(other)
    other.each do |key, value|
      myval = self[key]
      if value.is_a?(Hash) && myval.is_a?(Hash)
        myval.recursive_merge!(value)
      else
        self[key] = value
      end
    end
    self
  end

end

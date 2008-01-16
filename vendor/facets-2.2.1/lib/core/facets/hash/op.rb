class Hash

  # Can be used like update, or passed
  # as two-element [key,value] array.
  #
  #   CREDIT: Trans

  def <<(other)
    if other.respond_to?(:to_ary)
      self.store(*other)
    else
      update(other)
    end
  end

  # Hash intersection. Two hashes intersect
  # when their pairs are equal.
  #
  #   {:a=>1,:b=>2} & {:a=>1,:c=>3}  #=> {:a=>1}
  #
  # A hash can also be intersected with an array
  # to intersect keys only.
  #
  #   {:a=>1,:b=>2} & [:a,:c]  #=> {:a=>1}
  #
  # The later form is similar to #pairs_at. The differ only
  # in that #pairs_at will return a nil value for a key
  # not in the hash, but #& will not.
  #
  #   CREDIT: Trans

  def &(other)
    case other
    when Array
      k = (keys & other)
      Hash[*(k.zip(values_at(*k)).flatten)]
    else
      x = (to_a & other.to_a).inject([]) do |a, kv|
        a.concat kv; a
      end
      Hash[*x]
    end
  end

  # Operator for #reverse_merge.
  #
  #   CREDIT: Trans

  def |(other)
    other.merge(self)
  end

  # Operator for #merge.
  #
  #   CREDIT: Trans

  def +(other)
    merge(other)
  end

  # Operator for remove hash paris. If another hash is given
  # the pairs are only removed if both key and value are equal.
  # If an array is given then mathcing keys are removed.
  #
  #   CREDIT: Trans

  def -(other)
    h = self.dup
    if other.respond_to?(:to_ary)
      other.to_ary.each do |k|
        h.delete(k)
      end
    else
      other.each do |k,v|
        if h.key?(k)
          h.delete(k) if v == h[k]
        end
      end
    end
    h
  end

  # Like merge operator '+' but merges in reverse order.
  #
  #   h1 = { :a=>1 }
  #   h2 = { :a=>2, :b=>3 }
  #
  #   h1 + h2  #=> { :a=>2, :b=>3 }
  #   h1 * h2  #=> { :a=>1, :b=>3 }
  #
  #   CREDIT: Trans

  def *(other)
    other.merge(self)
  end

end

module Enumerable

  unless (RUBY_VERSION[0,3] == '1.9')

    # Count the number of items in an enumerable
    # equal (==) to the given object.
    #
    #   e = [ 'a', '1', 'a' ]
    #   e.count('1')    #=> 1
    #   e.count('a')    #=> 2
    #
    # Count can also handle multiple-valued blocks.
    #
    #   e = { 'a' => 2, 'a' => 2, 'b' => 1 }
    #   e.count('a',2)  #=> 1
    #
    #   CREDIT: Trans

    def count(*c)
      self.select{ |*i| i == c }.length
    end

    # Enumerable#one? returns +true+ if and only if <em>exactly one</em>
    # element in the collection satisfies the given predicate.
    #
    # If no predicate is provided, Enumerable#one? returns +true+ if
    # and only if <em>exactly one</em> element has a true value
    # (i.e. not +nil+ or +false+).
    #
    #   [].one?                      # false
    #   [nil].one?                   # false
    #   [5].one?                     # true
    #   [5,8,9].one?                 # false
    #   (1...10).one? { |n| n == 5 } # true
    #   (1...10).one? { |n| n < 5 }  # false
    #
    #   CREDIT: Gavin Sinclair

    def one?  # :yield: e
      matches = 0
      if block_given?
        self.each do |e|
          if yield(e)
            matches += 1
            return false if matches > 1
          end
        end
        return (matches == 1)
      else
        one? { |e| e }
      end
    end

    # Enumerable#none? is the logical opposite of the builtin method
    # Enumerable#any?.  It returns +true+ if and only if _none_ of
    # the elements in the collection satisfy the predicate.
    #
    # If no predicate is provided, Enumerable#none? returns +true+
    # if and only if _none_ of the elements have a true value
    # (i.e. not +nil+ or +false+).
    #
    #   [].none?                      # true
    #   [nil].none?                   # true
    #   [5,8,9].none?                 # false
    #   (1...10).none? { |n| n < 0 }  # true
    #   (1...10).none? { |n| n > 0 }  # false
    #
    #   CREDIT: Gavin Sinclair

    def none?  # :yield: e
      if block_given?
        not self.any? { |e| yield e }
      else
        not self.any?
      end
    end

  end

  # Returns an array of elements for the elements that occur n times.
  # Or according to the results of a given block.
  #
  #   [1,1,2,3,3,4,5,5].occur(1)             #=> [2,4]
  #   [1,1,2,3,3,4,5,5].occur(2)             #=> [1,3,5]
  #   [1,1,2,3,3,4,5,5].occur(3)             #=> []
  #
  #   [1,2,2,3,3,3].occur(1..1)              #=> [1]
  #   [1,2,2,3,3,3].occur(2..3)              #=> [2,3]
  #
  #   [1,1,2,3,3,4,5,5].occur { |n| n == 1 } #=> [2,4]
  #   [1,1,2,3,3,4,5,5].occur { |n| n > 1 }  #=> [1,3,5]
  #
  #   CREDIT: ?

  def occur(n=nil) #:yield:
    result = Hash.new { |hash, key| hash[key] = Array.new }
    self.each do |item|
      key = item
      result[key] << item
    end
    if block_given?
      result.reject! { |key, values| ! yield(values.size) }
    else
      raise ArgumentError unless n
      if Range === n
        result.reject! { |key, values| ! n.include?(values.size) }
      else
        result.reject! { |key, values| values.size != n }
      end
    end
    return result.values.flatten.uniq
  end

  # Uses #+ to sum the enumerated elements.
  #
  #   [1,2,3].sum  #=> 6
  #   [3,3,3].sum  #=> 9
  #
  #   CREDIT: Gavin Kistner

  def sum
    v = 0
    each{ |n| v+=n }
    v
  end

  # Returns a list on non-unique,
  #
  #   [1,1,2,2,3,4,5].nonuniq  #=> [1,2]
  #
  #   CREDIT: Martin DeMello

  def nonuniq
    h1 = {}
    h2 = {}
    each {|i|
      h2[i] = true if h1[i]
      h1[i] = true
    }
    h2.keys
  end

  #   #
  #   def nonuniq!
  #     raise unless respond_to?(:replace)
  #     h1 = {}
  #     h2 = {}
  #     each {|i|
  #       h2[i] = true if h1[i]
  #       h1[i] = true
  #     }
  #     self.replace(h2.keys)
  #   end

  # Return list of dulicate elements.
  #
  #   CREDIT: Thibaut Barrère

  alias_method :duplicates, :nonuniq

  # Like #uniq, but determines uniqueness based on a given block.
  #
  #   (-5..5).to_a.uniq_by {|i| i*i }
  #
  # produces
  #
  #   [-5, -4, -3, -2, -1, 0]
  #
  #   CREDIT: ?

  def uniq_by #:yield:
    h = {}; inject([]) {|a,x| h[yield(x)] ||= a << x}
  end

end

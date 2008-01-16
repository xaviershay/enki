require 'facets/integer/factorial'

module Enumerable

  # Produces an array of arrays of all possible combinations
  # of the given arrays in the positions given. (Imagine
  # it like a slot machine dial. This gives every combination
  # that could come up.)
  #
  #   a = %w|a b|
  #   b = %w|a x|
  #   c = %w|x y|
  #   Array.combinations(a, b, c).each { |x| p x }
  #
  # produces
  #
  #   ["a", "a", "x"]
  #   ["a", "a", "y"]
  #   ["a", "x", "x"]
  #   ["a", "x", "y"]
  #   ["b", "a", "x"]
  #   ["b", "a", "y"]
  #   ["b", "x", "x"]
  #   ["b", "x", "y"]
  #
  #   CREDIT: Florian Gross

  def self.combinations(head, *rest)
    crest = rest.empty? ? [[]] : combinations(*rest)
    head.inject([]) { |combs, item|
      combs + crest.map { |comb| [item] + comb }
    }
  end

  # Yields the block to each unique combination of _n_ elements.
  #
  #   a = %w|a b c d|
  #   a.each_combination(3) do |c|
  #     p c
  #   end
  #
  # produces
  #
  #   ["a", "b", "c"]
  #   ["a", "b", "d"]
  #   ["a", "c", "d"]
  #   ["b", "c", "d"]
  #
  #   CREDIT: Florian Gross

  def each_combination(k=2)
    s = to_a
    n = s.size
    return unless (1..n) === k
    idx = (0...k).to_a
    loop do
      yield s.values_at(*idx)
      i = k - 1
      i -= 1 while idx[i] == n - k + i
      break if i < 0
      idx[i] += 1
      (i + 1 ... k).each {|j| idx[j] = idx[i] + j - i}
    end
  end

  # NOTE: Deprecated #each_uniq_pair, just use #each_combination instead.
  #
  #   # Processes each unique pair (of indices, not value)
  #   # in the array by yielding them to the supplied block.
  #   #
  #   #   a = [1,2,3,4]
  #   #   a.each_unique_pair{ |a,b| puts a+','+b }
  #   #
  #   # produces
  #   #
  #   #   1,2
  #   #   1,3
  #   #   1,4
  #   #   2,3
  #   #   2,4
  #   #   3,4
  #   #
  #   # This does not guarantee the uniqueness of values.
  #   # For example:
  #   #
  #   #   a = [1,2,1]
  #   #   a.each_unique_pair{ |a,b| puts a+','+b }
  #   #
  #   # prduces
  #   #
  #   #   1,2
  #   #   1,1
  #   #   2,1
  #   #
  #   # This is equivalent to <tt>each_combination(2){ ... }</tt>.
  #
  #   def each_unique_pair(&yld)
  #     self.each_combination(2,&yld)
  #     #s = self.to_a
  #     #self.each_with_index{ |a,i|
  #     #  self[(i+1)..-1].each{ |b| yield a,b }
  #     #}
  #   end

end


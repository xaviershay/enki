class Range

  # Combine intervals.
  #
  #   Range.combine(1..2, 2..4)   #=> [1..4]
  #   Range.combine(1..2, 3..4)   #=> [1..2, 3..4]
  #
  #   CREDIT: Trans

  def self.combine(*intervals)
    intype = intervals.first.class
    result = []

    intervals = intervals.collect do |i|
      [i.first, i.last]
    end

    intervals.sort.each do |(from, to)|  #inject([]) do |result,
      if result.empty? or from > result.last[1]
        result << [from, to]
      elsif to > result.last[1]
        result.last[1] = to
      end
      #result
    end

    if intype <= Range
      result.collect{ |i| ((i.first)..(i.last)) }
    else
      result
    end
  end

  # Combine ranges.
  #
  #   (1..2).combine(2..4)   #=> [1..4]
  #   (1..2).combine(3..4)   #=> [1..2, 3..4]
  #
  #   TODO: Incorporate end-sentinal inclusion vs. exclusion.
  #
  #   CREDIT: Trans

  def combine(*intervals)
    Range.combine(self, *intervals)
  end

end

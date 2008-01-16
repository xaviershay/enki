class String

  # Apply a set of rules (regular expression matches) to the string.
  #
  # === Requirements:
  # The rules must be applied in order! So we cannot use a
  # hash because the ordering is not guaranteed! we use an
  # array instead.
  #
  # === Input:
  # The array containing rule-pairs (match, write).
  #
  # === Output:
  # The rewritten string.
  #
  #   CREDIT: George Moschovitis

  def rewrite(string, rules)
    return nil unless string
    # gmosx: helps to find bugs
    raise ArgumentError.new('The rules parameter is nil') unless rules
    rewritten_string = string.dup
    rules.each do |match,write|
      rewritten_string.gsub!(match,write)
    end
    return (rewritten_string or string)
  end

  # Filters out words from a string based on block test.
  #
  #   "a string".word_filter { |word| word =~ /^a/ }  #=> "string"
  #
  #   CREDIT: George Moschovitis

  def word_filter( &blk )
    s = self.dup
    s.word_filter!( &blk )
  end

  # In place version of #word_filter.
  #
  #   "a string".word_filter { |word| ... }
  #
  #   CREDIT: George Moschovitis

  def word_filter! #:yield:
    rest_of_string = self
    wordfind = /(\w+)/
    offset = 0
    while wmatch = wordfind.match(rest_of_string)
      word = wmatch[0]
      range = offset+wmatch.begin(0) ... offset+wmatch.end(0)
      rest_of_string = wmatch.post_match
      self[range] = yield( word ).to_s
      offset = self.length - rest_of_string.length
    end
    self
  end

end

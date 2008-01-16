class Array

  # This is more advnaced form of #join. It allows for a different
  # terminating separator, and even a different starting terminator.
  #
  # The default separator is ", " and default terminating separator
  # is " and ".
  #
  #   [1,2,3].conjoin
  #   => "1, 2 and 3
  #
  #   [1,2,3].conjoin(:last => ' or ')
  #   => "1, 2 or 3
  #
  #   [1,2,3].conjoin('.', :last => '-')
  #   => "1.2-3
  #
  #   [2,4,2,3].conjoin(' == ', :first => " x ", :last => " ** ")
  #   => "2 x 4 == 2 ** 3"
  #
  #   CREDIT: Trans

  def conjoin(*args)
    options   = (Hash===args.last) ? args.pop : {}
    separator = args.unshift || ", "

    first = options[:first] || separator
    last  = options[:last]  || " and "

    case length
    when 0
      ""
    when 1
      self[0]
    else
      [self[0], first, self[1..-2].join("#{separator}"), last, self[-1]].join
      #[self[0..-2].join("#{separator}"), self[-1]].join("#{last}")
    end
  end

  # Alias for #conjoin.
  #
  #   NOTE: This will be deprecated.

  alias_method :join_sentence, :conjoin
end


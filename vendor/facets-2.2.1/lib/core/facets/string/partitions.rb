class String

  unless (RUBY_VERSION[0,3] == '1.9')

    # Upacks string into bytes.
    #
    #

    def bytes
      self.unpack('C*')
    end

    # Returns an array of characters.
    #
    #   "abc\n123".lines  #=> ["abc","123"]

    def lines
      self.split(/\n/)
    end

    # Iterates through each character. This is a little faster than
    # using #chars b/c it does not create the intermediate array.
    #
    #    a = ''
    #   "HELLO".each_character{ |c| a << #{c.downcase} }
    #    a  #=> 'hello'

    def each_char  # :yield:
      size.times do |i|
        yield(self[i,1])
      end
    end

  end

  # Alias for each_char.

  alias_method :each_character, :each_char

  # Returns an array of characters.
  #
  #   "abc".chars  #=> ["a","b","c"]

  def chars
    self.split(//)
  end

  # Returns an array of characters.
  #
  #   "abc 123".words  #=> ["abc","123"]

  def words
    self.split(/\s+/)
  end

  # Iterate through each word of a string.
  #
  #   "a string".each_word { |word, range| ... }

  def each_word( &yld )
    rest_of_string = self
    wordfind = /([-'\w]+)/
    arity = yld.arity
    offset = 0
    while wmatch = wordfind.match(rest_of_string)
      word = wmatch[0]
      range = offset+wmatch.begin(0) ... offset+wmatch.end(0)
      rest_of_string = wmatch.post_match
      if arity == 1
        yld.call(word)
      else
        yld.call(word, range)
      end
      offset = self.length - rest_of_string.length
    end
  end

end

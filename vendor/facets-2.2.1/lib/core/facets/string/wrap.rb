class String

  # Returns short abstract of long strings; not exceeding +range+
  # characters. If range is an integer then the minimum is 20%
  # of the maximum. The string is chopped at the nearest word
  # if possible, and appended by +ellipsis+, which defaults
  # to '...'.
  #
  #   CREDIT: George Moschovitis
  #   CREDIT: Trans

  def brief(range=76, ellipsis="...")
    if Range===range
      min = range.first
      max = range.last
    else
      max = range
      min = max - (max/5).to_i
      range = min..max
    end

    if size > max
      cut_at = rindex(/\b/, max) || max
      cut_at = max if cut_at < min
      xstring = slice(0, cut_at)
      xstring.chomp(" ") + ellipsis
    else
      self
    end
  end

  # Cleave a string. Break a string in two parts at
  # the nearest whitespace.
  #
  #   CREDIT: Trans

  def cleave(threshold=nil, len=nil)
    l = (len || size / 2)
    t = threshold || size

    h1 = self[0...l]
    h2 = self[l..-1]

    i1 = h1.rindex(/\s/) || 0
    d1 = (i1 - l).abs

    d2 = h2.index(/\s/) || l
    i2 = d2 + l

    d1 = (i1-l).abs
    d2 = (i2-l).abs

    if [d1, d2].min > t
      i = t
    elsif d1 < d2
      i = i1
    else
      i = i2
    end

    #dup.insert(l, "\n").gsub(/^\s+|\s+$/, '')
    return self[0..i].to_s.strip, self[i+1..-1].to_s.strip
  end

  # Returns a new string with all new lines removed from
  # adjacent lines of text.
  #
  #   s = "This is\na test.\n\nIt clumps\nlines of text."
  #   s.fold
  #
  # _produces_
  #
  #   "This is a test.\n\nIt clumps lines of text. "
  #
  # One arguable flaw with this, that might need a fix:
  # if the given string ends in a newline, it is replaced with
  # a single space.
  #
  #   CREDIT: Trans

  def fold(ignore_indented=false)
    ns = ''
    i = 0
    br = self.scan(/(\n\s*\n|\Z)/m) do |m|
      b = $~.begin(1)
      e = $~.end(1)
      nl = $&
      tx = slice(i...b)
      if ignore_indented and slice(i...b) =~ /^[ ]+/
        ns << tx
      else
        ns << tx.gsub(/[ ]*\n+/,' ')
      end
      ns << nl
      i = e
    end
    ns
  end

  # Line wrap at width.
  #
  #   puts "1234567890".line_wrap(5)
  #
  # _produces_
  #
  #   12345
  #   67890
  #
  #  CREDIT: Trans

  def line_wrap(width, tabs=4)
    s = gsub(/\t/,' ' * tabs) # tabs default to 4 spaces
    s = s.gsub(/\n/,' ')
    r = s.scan( /.{1,#{width}}/ )
    r.join("\n") << "\n"
  end

  # TODO: This is alternateive from glue: worth providing?
  #
  # Enforces a maximum width of a string inside an
  # html container. If the string exceeds this maximum width
  # the string gets wraped.
  #
  # Not really useful, better use the CSS overflow: hidden
  # functionality.
  #
  # === Input:
  # the string to be wrapped
  # the enforced width
  # the separator used for wrapping
  #
  # === Output:
  # the wrapped string
  #
  # === Example:
  #  text = "1111111111111111111111111111111111111111111"
  #  text = wrap(text, 10, " ")
  #  p text # => "1111111111 1111111111 1111111111"
  #
  # See the test cases to better understand the behaviour!

  #   def wrap(width = 20, separator = " ")
  #     re = /([^#{separator}]{1,#{width}})/
  #     scan(re).join(separator)
  #   end

  # Word wrap a string not exceeding max width.
  #
  #   puts "this is a test".word_wrap(4)
  #
  # _produces_
  #
  #   this
  #   is a
  #   test
  #
  #   CREDIT: Gavin Kistner
  #   CREDIT: Dayne Broderson

  def word_wrap( col_width=80 )
    self.dup.word_wrap!( col_width )
  end

  # As with #word_wrap, but modifies the string in place.
  #
  #   CREDIT: Gavin Kistner
  #   CREDIT: Dayne Broderson

  def word_wrap!( col_width=80 )
    self.gsub!( /(\S{#{col_width}})(?=\S)/, '\1 ' )
    self.gsub!( /(.{1,#{col_width}})(?:\s+|$)/, "\\1\n" )
    self
  end

  # old def

  #def word_wrap(max=80)
  #  c = dup
  #  c.word_wrap!(max)
  #  c
  #end

  #def word_wrap!(max=80)
  #  raise ArgumentError, "Wrap margin too low: #{n}" if max <= 2
  #  #gsub!( Regexp.new( "(.{1,#{max-1}}\\w)\\b\\s*" ), "\\1\n")
  #  gsub!( /(.{1,#{max-1}}\S)([ ]|\n)/, "\\1\n")
  #end

end

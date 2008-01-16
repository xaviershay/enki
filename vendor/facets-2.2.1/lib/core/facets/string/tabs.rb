class String

  # Aligns each line n spaces.
  #
  #   CREDIT: Gavin Sinclair

  def tab(n)
    gsub(/^ */, ' ' * n)
  end

  # Alias will be deprecated.
  alias_method :taballto, :tab

  # Expands tabs to +n+ spaces.  Non-destructive.  If +n+ is 0, then tabs are
  # simply removed.  Raises an exception if +n+ is negative.
  #
  # Thanks to GGaramuno for a more efficient algorithm.  Very nice.
  #
  #   CREDIT: Gavin Sinclair
  #   CREDIT: Noah Gibbs
  #   CREDIT: GGaramuno

  def expand_tabs(n=8)
    n = n.to_int
    raise ArgumentError, "n must be >= 0" if n < 0
    return gsub(/\t/, "") if n == 0
    return gsub(/\t/, " ") if n == 1
    str = self.dup
    while
      str.gsub!(/^([^\t\n]*)(\t+)/) { |f|
        val = ( n * $2.size - ($1.size % n) )
        $1 << (' ' * val)
      }
    end
    str
  end

  # Preserves relative tabbing.
  # The first non-empty line ends up with n spaces before nonspace.
  #
  #   CREDIT: Gavin Sinclair

  def tabto(n)
    if self =~ /^( *)\S/
      indent(n - $1.length)
    else
      self
    end
  end

  # Indent left or right by n spaces.
  # (This used to be called #tab and aliased as #indent.)
  #
  #   CREDIT: Gavin Sinclair
  #   CREDIT: Trans

  def indent(n)
    if n >= 0
      gsub(/^/, ' ' * n)
    else
      gsub(/^ {0,#{-n}}/, "")
    end
  end

  # Outdent just indents a negative number of spaces.
  #
  # CREDIT: Noah Gibbs

  def outdent(n)
    indent(-n)
  end

  # Provides a margin controlled string.
  #
  #   x = %Q{
  #         | This
  #         |   is
  #         |     margin controlled!
  #         }.margin
  #
  #
  #   NOTE: This may still need a bit of tweaking.
  #
  #   CREDIT: Trans

  def margin(n=0)
    #d = /\A.*\n\s*(.)/.match( self )[1]
    #d = /\A\s*(.)/.match( self)[1] unless d
    d = ((/\A.*\n\s*(.)/.match(self)) ||
        (/\A\s*(.)/.match(self)))[1]
    return '' unless d
    if n == 0
      gsub(/\n\s*\Z/,'').gsub(/^\s*[#{d}]/, '')
    else
      gsub(/\n\s*\Z/,'').gsub(/^\s*[#{d}]/, ' ' * n)
    end
  end

end

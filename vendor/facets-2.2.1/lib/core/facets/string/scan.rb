class String

  # Breaks a string up into an array based on a regular expression.
  # Similar to scan, but includes the matches.
  #
  #   s = "<p>This<b>is</b>a test.</p>"
  #   s.divide( /\<.*?\>/ )
  #
  # _produces_
  #
  #   ["<p>This", "<b>is", "</b>a test.", "</p>"]
  #
  #   CREDIT: Trans

  def divide( re )
    re2 = /#{re}.*?(?=#{re}|\Z)/
    scan(re2) #{re}(?=#{re})/)
  end

  # Like #scan but returns MatchData ($~) rather
  # then matched string ($&).
  #
  #   CREDIT: Trans

  def mscan(re) #:yield:
    if block_given?
      scan(re) { yield($~) }
    else
      m = []
      scan(re) { m << $~ }
      m
    end
  end

  # Breaks a string up into an array based on a regular expression.
  # Similar to scan, but includes the matches.
  #
  #   s = "<p>This<b>is</b>a test.</p>"
  #   s.shatter( /\<.*?\>/ )
  #
  # _produces_
  #
  #   ["<p>", "This", "<b>", "is", "</b>", "a test.", "</p>"]
  #
  #   CREDIT: Trans

  def shatter( re )
    r = self.gsub( re ){ |s| "\1" + s + "\1" }
    while r[0,1] == "\1" ; r[0] = '' ; end
    while r[-1,1] == "\1" ; r[-1] = '' ; end
    r.split("\1")
  end

end

class Regexp

  # Returns the number of backreferencing subexpressions.
  #
  #   /(a)(b)(c)/.arity  #=> 3
  #   /(a(b(c)))/.arity  #=> 3
  #
  # Note that this is not perfect, especially with regards to \x
  # and embedded comments.
  #
  #   CREDIT: Trans

  def arity
    source.scan( /(?!\\)[(](?!\?[#=:!>-imx])/ ).length
  end

end

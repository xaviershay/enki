class String

  # Align a string to the right.
  # The defualt alignment seperation is a new line ("/n")
  # This can be changes as can be the padding string which
  # defaults to a single space (' ').
  #
  #   s = <<-EOS
  #   This is a test
  #     and
  #     so on
  #   EOS
  #
  #   puts s.align_right(2)
  #
  # _produces_
  #
  #     This is a test
  #                and
  #              so on
  #
  #   CREDIT: Trans

  def align_right(n, sep="\n", c=' ')
    return rjust(n.to_i,c.to_s) if sep==nil
    q = split(sep.to_s).collect { |line|
      line.rjust(n.to_i,c.to_s)
    }
    q.join(sep.to_s)
  end

  # Align a string to the left.
  #
  # The defualt alignment seperation is a new line ("/n")
  # This can be changes as can be the padding string which
  # defaults to a single space (' ').
  #
  #   s = <<-EOS
  #   This is a test
  #     and
  #     so on
  #   EOS
  #
  #   puts s.align_left(2)
  #
  # _produces_
  #
  #     This is a test
  #     and
  #     so on
  #
  #   CREDIT: Trans

  def align_left(n, sep="\n", c=' ')
    return ljust(n.to_i,c.to_s) if sep==nil
    q = split(sep.to_s).collect { |line|
      line.ljust(n.to_i,c.to_s)
    }
    q.join(sep.to_s)
  end

  # Centers each line of a string.
  #
  # The defualt alignment seperation is a new line ("/n")
  # This can be changed as can be the padding string which
  # defaults to a single space (' ').
  #
  #   s = <<-EOS
  #     This is a test
  #     and
  #     so on
  #   EOS
  #
  #   puts s.align_center(14)
  #
  # _produces_
  #
  #   This is a test
  #        and
  #       so on
  #
  #   CREDIT: Trans

  def align_center(n, sep="\n", c=' ')
    return center(n.to_i,c.to_s) if sep==nil
    q = split(sep.to_s).collect { |line|
      line.center(n.to_i,c.to_s)
    }
    q.join(sep.to_s)
  end

end

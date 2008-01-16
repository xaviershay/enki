class Hash

  # Like Array#join but specialized to Hash.
  #
  #   CREDIT: Mauricio Fernandez

  def join(pair_divider='', elem_divider='')
    s = []
    each_pair { |k,v| s << "#{k}#{pair_divider}#{v}" }
    s.join(elem_divider)
  end

end


class File

  # Splits a file path into an array of individual path components.
  # This differs from <tt>File.split</tt>, which divides the path into
  # only two parts, directory path and basename.
  #
  #   File.split_all("a/b/c") =>  ['a', 'b', 'c']
  #
  #   CREDIT: Trans

  def self.split_all(path)
    head, tail = File.split(path)
    return [tail] if head == '.' || tail == '/'
    return [head, tail] if head == '/'
    return split_all(head) + [tail]
  end

end


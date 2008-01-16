class File

  # Append to a file.
  #
  #   CREDIT: George Moschovitis

  def self.append( file, str )
    File.open( file, 'ab' ) { |f|
      f << str
    }
  end

  # Creates a new file, or overwrites an existing file,
  # and writes a string into it. Can also take a block
  # just like File#open, which is yielded _after_ the
  # string is writ.
  #
  #   str = 'The content for the file'
  #   File.create('myfile.txt', str)
  #
  #   CREDIT: George Moschovitis

  def self.create(path, str='', &blk)
    File.open(path, 'wb') do |f|
      f << str
      blk.call(f) if blk
    end
  end

  # Writes the given data to the given path and closes the file.  This is
  # done in binary mode, complementing <tt>IO.read</tt> in standard Ruby.
  #
  # Returns the number of bytes written.
  #
  #   CREDIT: Gavin Sinclair

  def self.write(path, data)
    File.open(path, "wb") do |file|
      return file.write(data)
    end
  end

  # Writes the given array of data to the given path and closes the file.
  # This is done in binary mode, complementing <tt>IO.readlines</tt> in
  # standard Ruby.
  #
  # Note that +readlines+ (the standard Ruby method) returns an array of lines
  # <em>with newlines intact</em>, whereas +writelines+ uses +puts+, and so
  # appends newlines if necessary.  In this small way, +readlines+ and
  # +writelines+ are not exact opposites.
  #
  # Returns +nil+.
  #
  #   CREDIT: Noah Gibbs
  #   CREDIT: Gavin Sinclair

  def self.writelines(path, data)
    File.open(path, "wb") do |file|
      file.puts(data)
    end
  end

  # Opens a file as a string and writes back the string to the file at
  # the end of the block.
  #
  # Returns the number of written bytes or +nil+ if the file wasn't
  # modified.
  #
  # Note that the file will even be written back in case the block
  # raises an exception.
  #
  # Mode can either be "b" or "+" and specifies to open the file in
  # binary mode (no mapping of the plattform's newlines to "\n" is
  # done) or to append to it.
  #
  #   # Reverse contents of "message"
  #   File.rewrite("message") { |str| str.reverse! }
  #
  #   # Replace "foo" by "bar" in "binary"
  #   File.rewrite("binary", "b") { |str| str.gsub!("foo", "bar") }
  #
  #   CREDIT: George Moschovitis
  #--
  # TODO Should it be in-place modification like this? Or would it be better
  # if whatever the block returns is written to the file instead?
  #++

  def self.rewrite(name, mode = "") #:yield:
    unless block_given?
      raise(ArgumentError, "Need to supply block to File.open_as_string")
    end

    if mode.is_a?(Numeric) then
      flag, mode = mode, ""
      mode += "b" if flag & File::Constants::BINARY != 0
      mode += "+" if flag & File::Constants::APPEND != 0
    else
      mode.delete!("^b+")
    end

    str = File.open(name, "r#{mode}") { |file| file.read } #rescue ""
    old_str = str.clone

    begin
      yield str
    ensure
      if old_str != str then
        File.open(name, "w#{mode}") { |file| file.write(str) }
      end
    end
  end

end

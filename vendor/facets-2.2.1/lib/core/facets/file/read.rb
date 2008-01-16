class File

  # Read in a file as binary data.
  #
  #  CREDIT: George Moschovitis

  def self.read_binary(fname)
    open(fname, 'rb') {|f|
      return f.read
    }
  end

  # Reads in a file, removes blank lines and remarks
  # (lines starting with '#') and then returns
  # an array of all the remaining lines.
  #
  #   CREDIT: Trans

  def self.read_list(filepath, chomp_string='')
    farr = nil
    farr = read(filepath).split("\n")
    farr.collect! { |line|
      l = line.strip.chomp(chomp_string)
      (l.empty? or l[0,1] == '#') ? nil : l
    }
    farr.compact
  end

end

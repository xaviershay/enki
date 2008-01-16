class Dir

  # Recursively scan a directory and pass each file
  # to the given block.
  #
  #   CREDIT: George Moschovitis

  def self.recurse(path='.', &block)
    list = []
    stoplist = ['.', '..']
    Dir.foreach(path) do |f|
      next if stoplist.include?(f)
      filename = path + '/' + f
      list << filename
      block.call(filename) if block
      if FileTest.directory?(filename) and not FileTest.symlink?(filename)
        list.concat( Dir.recurse(filename, &block) )
      end
    end
    list
  end

  class << self
    # Alias for Dir#recurse.
    alias_method :ls_r, :recurse
  end

end
class Dir

  # TODO: Make instance method versions ?

  # Ascend a directory path.
  #
  #   Dir.ascend("/var/log") do |path|
  #     p path
  #   end
  #
  # _produces_
  #
  #   /var/log
  #   /var
  #   /
  #
  #   CREDIT: Daniel Berger
  #   CREDIT: Jeffrey Schwab

  def self.ascend(dir, inclusive=true, &blk)
    dir = dir.dup
    blk.call(dir) if inclusive
    ri = dir.rindex('/')
    while ri
      dir = dir.slice(0...ri)
      if dir == ""
        blk.call('/') ; break
      end
      blk.call( dir )
      ri = dir.rindex('/')
    end
  end

  # Descend a directory path.
  #
  #   Dir.descend("/var/log") do |path|
  #     p path
  #   end
  #
  # _produces_
  #
  #   /
  #   /var
  #   /var/log
  #
  #   CREDIT: Daniel Berger
  #   CREDIT: Jeffrey Schwab

  def self.descend(path) #:yield:
    paths = path.split('/')
    paths.size.times do |n|
      yield File.join(*paths[0..n])
    end
  end

end

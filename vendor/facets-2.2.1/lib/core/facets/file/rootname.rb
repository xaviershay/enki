class File

  # Returns onlt the first portion of the directory of
  # a file path name.
  #
  #   File.rootname('lib/jump.rb')  #=> 'lib'
  #   File.rootname('/jump.rb')     #=> '/'
  #   File.rootname('jump.rb')      #=> '.'
  #
  #   CREDIT: Trans

  def self.rootname( file_name )
    i = file_name.index('/')
    if i
      r = file_name[0...i]
      r == '' ? '/' : r
    else
      '.'
    end
  end

end

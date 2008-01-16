module FileTest

  module_function

  # Is the specified directory the root directory?
  #
  #   CREDIT: Jeffrey Schwab

  def root?(dir=nil)
    pth = File.expand_path(dir||Dir.pwd)
    return true if pth == '/'
    return true if pth =~ /^(\w:)?\/$/
    false
  end

end

module Kernel
  private

  # Similar to __FILE__ and __LINE__, __DIR__ provides
  # the directory path to the current executing script.
  #
  #  CREDIT: Trans

  def __DIR__
    (/^(.+)?:\d+/ =~ caller[0]) ? File.dirname($1) : nil
  end

end


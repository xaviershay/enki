class File

  # Cleans up a filename to ensure it will work on filesystem.
  #
  #   CREDIT: George Moschovitis

  def self.sanitize(filename)
    filename = File.basename(filename.gsub("\\", "/")) # work-around for IE
    filename.gsub!(/[^a-zA-Z0-9\.\-\+_]/,"_")
    filename = "_#{filename}" if filename =~ /^\.+$/
    filename
  end

end

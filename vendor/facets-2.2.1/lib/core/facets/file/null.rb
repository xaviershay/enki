class File

  # Platform dependent null device.
  #
  #   CREDIT: Daniel Burger

  def self.null
    case RUBY_PLATFORM
    when /mswin/i
      'NUL'
    when /amiga/i
      'NIL:'
    when /openvms/i
      'NL:'
    else
      '/dev/null'
    end
  end

end

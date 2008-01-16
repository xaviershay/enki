# Title:
#   Console Utilities
#
# Author:
#   - Thomas Sawyer
#
# License:
#   Copyright (c) 2006,2007 Thomas Sawyer
#   Ruby/GPL

# ConsoleUtils provides methods that are
# generally useful in the context of
# creating console output.

module ConsoleUtils

  module_function

  def println

  end

  # Convenient method to get simple console reply.

  def ask(question, answers=nil)
    print "#{question}"
    print " [#{answers}] " if answers
    until inp = $stdin.gets ; sleep 1 ; end
    inp
  end

  # Convenience method for puts. Use this instead of
  # puts when the output should be supressed if the
  # global $QUIET option is set.

  def say(statement)
    puts statement #unless quiet? $QUIET
  end

  # Ask for a password. (FIXME: only for unix so far)

  def password(msg=nil)
    msg ||= "Enter Password: "
    inp = ''

    $stdout << msg

    begin
      system "stty -echo"
      inp = gets.chomp
    ensure
      system "stty echo"
    end

    return inp
  end

  # Console screen width (taken from progress bar)

  def screen_width(out=STDERR)
    # FIXME: I don't know how portable it is.
    default_width = ENV['COLUMNS'] || 80
    begin
      tiocgwinsz = 0x5413
      data = [0, 0, 0, 0].pack("SSSS")
      if out.ioctl(tiocgwinsz, data) >= 0 then
        rows, cols, xpixels, ypixels = data.unpack("SSSS")
        if cols >= 0 then cols else default_width end
      else
        default_width
      end
    rescue Exception
      default_width
    end
  end

  # Print a justified line with left and right entries.
  #
  # A fill option can be given to fill in any empty space
  # between the two. And a ratio option can be given which defaults
  # to 0.8 (eg. 80/20)

  def print_justified(left, right, options={})
    fill  = options[:fill] || '.'
    fill  = ' ' if fill == ''
    fill  = fill[0,1]

    ratio = options[:ratio] || 0.8
    ratio = 1 + ratio if ratio < 0

    width = (@screen_width ||= screen_width) - 1

    #l = (width * ratio).to_i
    r = (width * (1 - ratio)).to_i
    l = width - r

    left  = left[0,l]
    right = right[0,r]

    str = fill * width
    str[0,left.size] = left
    str[width-right.size,right.size] = right

    print str
  end

end

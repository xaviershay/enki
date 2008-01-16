# = ansicode.rb
#
# == Copyright (c) 2004 Florian Frank, Thomas Sawyer
#
#   Ruby License
#
#   This module is free software. You may use, modify, and/or redistribute this
#   software under the same terms as Ruby.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
#   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#   FOR A PARTICULAR PURPOSE.
#
# == Authors & Contributors
#
# * Florian Frank
# * Thomas Sawyer
#
# == Speical Thanks
#
# Special thanks to Florian Frank. ANSICode is a partial adaptation
# of ANSIColor, Copyright (c) 2002 Florian Frank, LGPL.
#
# == Developer Notes
#
#   TODO Need to add rest of ANSI codes. Include modes?
#
#   TODO Re-evaluate how color/yielding methods are defined.
#
#   TODO Maybe up, down, right, left should have yielding
#        methods too?

# Author::    Florian Frank, Thomas Sawyer
# Copyright:: Copyright (c) 2006 Florian Frank, Thomas Sawyer
# License::   Ruby License

# = Console ANSICode
#
# Module provide methods for inserting ansicodes into strings.

module Console

  # = ANSICode
  #
  # Module which makes it very easy to use ANSI codes.
  # These are esspecially nice for beautifying shell output.
  #
  # == Synopsis
  #
  #   include Console::ANSICode
  #
  #   p red, "Hello", blue, "World"
  #   => "\e[31mHello\e[34mWorld"
  #
  #   p red { "Hello" } + blue { "World" }
  #   => "\e[31mHello\e[0m\e[34mWorld\e[0m"
  #
  # == Supported ANSI Commands
  #
  #     save
  #     restore
  #     clear_screen
  #     cls             # synonym for :clear_screen
  #     clear_line
  #     clr             # synonym for :clear_line
  #     move
  #     up
  #     down
  #     left
  #     right
  #     display
  #
  #     clear
  #     reset           # synonym for :clear
  #     bold
  #     dark
  #     italic          # not widely implemented
  #     underline
  #     underscore      # synonym for :underline
  #     blink
  #     rapid_blink     # not widely implemented
  #     negative        # no reverse because of String#reverse
  #     concealed
  #     strikethrough   # not widely implemented
  #
  #     black
  #     red
  #     green
  #     yellow
  #     blue
  #     magenta
  #     cyan
  #     white
  #
  #     on_black
  #     on_red
  #     on_green
  #     on_yellow
  #     on_blue
  #     on_magenta
  #     on_cyan
  #     on_white
  #

  module ANSICode

    extend self

    # Save current cursor positon.

    def save
      "\e[s"
    end

    # Restore saved cursor positon.

    def restore
      "\e[u"
    end

    # Clear the screen and move cursor to home.

    def clear_screen
      "\e[2J"
    end
    alias_method :cls, :clear_screen

    # Clear to the end of the current line.

    def clear_line
      "\e[K"
    end
    alias_method :clr, :clear_line

    #--
    #def position
    #  "\e[#;#R"
    #end
    #++

    # Move curose to line and column.

    def move( line, column=0 )
      "\e[#{line.to_i};#{column.to_i}H"
    end

    # Move cursor up a specificed number of spaces.

    def up( spaces=1 )
      "\e[#{spaces.to_i}A"
    end

    # Move cursor down a specificed number of spaces.

    def down( spaces=1 )
      "\e[#{spaces.to_i}B"
    end

    # Move cursor left a specificed number of spaces.

    def left( spaces=1 )
      "\e[#{spaces.to_i}D"
    end

    # Move cursor right a specificed number of spaces.

    def right( spaces=1 )
      "\e[#{spaces.to_i}C"
    end

    # Like +move+ but returns to original positon
    # after yielding block or adding string argument.

    def display( line, column=0, string=nil ) #:yield:
      result = "\e[s"
      result << "\e[#{line.to_i};#{column.to_i}H"
      if block_given?
        result << yield
        result << "\e[u"
      elsif string
        result << string
        result << "\e[u"
      elsif respond_to?(:to_str)
        result << self
        result << "\e[u"
      end
      return result
    end

    # Define color codes.

    def self.define_ansicolor_method(name,code)
      class_eval <<-HERE
        def #{name.to_s}(string = nil)
            result = "\e[#{code}m"
            if block_given?
                result << yield
                result << "\e[0m"
            elsif string
                result << string
                result << "\e[0m"
            elsif respond_to?(:to_str)
                result << self
                result << "\e[0m"
            end
            return result
        end
      HERE
    end

    @@colors = [
      [ :clear        ,   0 ],
      [ :reset        ,   0 ],     # synonym for :clear
      [ :bold         ,   1 ],
      [ :dark         ,   2 ],
      [ :italic       ,   3 ],     # not widely implemented
      [ :underline    ,   4 ],
      [ :underscore   ,   4 ],     # synonym for :underline
      [ :blink        ,   5 ],
      [ :rapid_blink  ,   6 ],     # not widely implemented
      [ :negative     ,   7 ],     # no reverse because of String#reverse
      [ :concealed    ,   8 ],
      [ :strikethrough,   9 ],     # not widely implemented
      [ :black        ,  30 ],
      [ :red          ,  31 ],
      [ :green        ,  32 ],
      [ :yellow       ,  33 ],
      [ :blue         ,  34 ],
      [ :magenta      ,  35 ],
      [ :cyan         ,  36 ],
      [ :white        ,  37 ],
      [ :on_black     ,  40 ],
      [ :on_red       ,  41 ],
      [ :on_green     ,  42 ],
      [ :on_yellow    ,  43 ],
      [ :on_blue      ,  44 ],
      [ :on_magenta   ,  45 ],
      [ :on_cyan      ,  46 ],
      [ :on_white     ,  47 ],
    ]

    @@colors.each do |c, v|
      define_ansicolor_method(c, v)
    end

    ColoredRegexp = /\e\[([34][0-7]|[0-9])m/

    def uncolored(string = nil)
      if block_given?
        yield.gsub(ColoredRegexp, '')
      elsif string
        string.gsub(ColoredRegexp, '')
      elsif respond_to?(:to_str)
        gsub(ColoredRegexp, '')
      else
        ''
      end
    end

    module_function

    def colors
      @@colors.map { |c| c[0] }
    end

  end

end

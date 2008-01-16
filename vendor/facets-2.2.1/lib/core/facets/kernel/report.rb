module Kernel

  module_function

  unless (RUBY_VERSION[0,3] == '1.9')

    # Alternate to standard #p method that outputs
    # Kernel#inspect to stdout, but also passes through
    # the orginal argument(s).
    #
    #   x = 1
    #   r = 4 + q(1)
    #   p r
    #
    # produces
    #
    #   1
    #   5
    #
    # DEPRECATE AS OF 1.9, _if_ #p will then do this too.

    def p(*x)
      x.each{ |e| puts e.inspect } #p(*x)
      x.size > 1 ? x : x.last #x.last
    end

  end

  # Like #p but gives file and line number.
  #
  #   d("hi")
  #
  # produces
  #
  #   /home/dave/projects/foo.rb, 38
  #   "hi"

  def d(*x)
    puts "#{__FILE__}, #{__LINE__}"
    x.each{ |e| puts e.inspect } #p(*x)
    x.size > 1 ? x : x.last #x.last
  end

  # Pretty prints an exception/error object,
  # useful for helpfull debug messages.
  #
  # Input:
  # The Exception/StandardError object
  #
  # Output:
  # The pretty printed string.
  #
  #   TODO: Deprecate in favor of Exception#detail.
  #
  #   CREDIT: George Moschovitis

  def pp_exception(ex)
    return %{#{ex.message}\n  #{ex.backtrace.join("\n  ")}\n  LOGGED FROM: #{caller[0]}}
  end

  # For debugging and showing examples. Currently this
  # takes an argument of a string in a block.
  #
  #   demo {%{ a = [1,2,3] }}
  #   demo {%{ a.slice(1,2) }}
  #   demo {%{ a.map { |x| x**3 } }}
  #
  # Produces:
  #
  #   a = [1,2,3]             #=>  [1, 2, 3]
  #   a.slice(1,2)            #=>  [2, 3]
  #   a.map { |x| x**3 }      #=>  [1, 8, 27]
  #
  #   TODO: Is there a way to do this without the eval string in block?
  #         Preferably just a block and no string.

  def demo(out=$stdout,&block)
    out << sprintf("%-25s#=>  %s\n", expr = block.call, eval(expr, block.binding).inspect)
  end

  # Like #warn produces the current line number as well.
  #
  #   warn_with_line("You have been warned.")
  #
  # _produces_
  #
  #   3: Warning: You have been warned.
  #
  # Note that this method depends on the output of #caller.

  def warn_with_line(msg="", fulltrace=nil)
    trace = caller(1)
    where = trace[0].sub(/:in.*/,'')
    STDERR.puts "#{where}: Warning: #{msg}"
    STDERR.puts trace.map { |t| "\tfrom #{t}" } if fulltrace
  end

end

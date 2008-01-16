# TITLE:
#   FileUtils
#
# SUMMARY:
#   General extensions for FileUtils.
#
# COPYRIGHT
#   Copyright (C) 2005 Thomas Saywer
#
# LICENSE:
#   Ruby License
#
# AUTHORS:
#   - Thomas Sawyer
#   - Jim Weirich
#   - Daniel Burger
#
# TODOs:
#   - Deprecate #safe_ln, if #ln has been fixed to do this.


require 'fileutils'


module FileUtils

  module_function

  # CREDIT Jim Weirich

  LINKING_SUPPORTED = [true]

  # Attempt to do a normal file link, but fall back
  # to a copy if the link fails.
  #--
  #++
  def safe_ln(*args)
    unless LINKING_SUPPORTED[0]
      cp(*args)
    else
      begin
        ln(*args)
      rescue Errno::EOPNOTSUPP
        LINKING_SUPPORTED[0] = false
        cp(*args)
      end
    end
  end

  # In block form, yields the first number of ((*lines*)) of file ((*filename*)).
  # In non-block form, it returns an array of the first number of ((*lines*)).
  #
  #   # Returns first 10 lines of 'myfile'
  #   FileUtils.head("myfile")
  #
  def head(filename,lines=10) #:yield:
    a = []
    IO.foreach(filename){|line|
        break if lines <= 0
        lines -= 1
        if block_given?
          yield line
        else
          a << line
        end
    }
    return a.empty? ? nil : a
  end

  # In block form, yields the last number of ((*lines*)) of file ((*filename*)).
  # In non-block form, it returns the lines as an array.
  #
  # Note that this method slurps the entire file, so I don't recommend it
  # for very large files.  If you want an advanced form of ((*tail*)), I
  # suggest using file-tail, by Florian Frank (available on the RAA).
  # And no tail -f.
  #
  #   # Returns last 3 lines of 'myfile'
  #   FileUtils.tail("myfile",3)
  #
  def tail(filename,lines=10) #:yield
    IO.readlines(filename).reverse[0..lines-1].reverse
  end

  # In block form, yields lines ((*from*))-((*to*)).  In non-block form,
  # returns an array of lines ((*from*))-((*to*)).
  #
  #   # Returns lines 8-12 of 'myfile'
  #   FileUtils.body("myfile",8,12)
  #
  #--
  # Credit goes to Shashank Date, via Daniel Berger.
  #++
  def slice(filename,from,to) #:yield:
    IO.readlines(filename)[from-1..to-1]
  end

  # CREDIT Daniel J. Berger

  # With no arguments, returns a four element array consisting of the number
  # of bytes, characters, words and lines in _filename_, respectively.
  #
  # Valid options are <tt>bytes</tt>, <tt>characters</tt> (or just 'chars'),
  # <tt>words</tt> and <tt>lines</tt>.
  #
  #   # Return the number of words in 'myfile'
  #   FileUtils.wc("myfile",'words')
  #
  def wc(filename,option='all')
    option.downcase!
    valid = %w/all bytes characters chars lines words/

    unless valid.include?(option)
        raise "Invalid option: '#{option}'"
    end

    n = 0
    if option == 'lines'
        IO.foreach(filename){ n += 1 }
        return n
    elsif option == 'bytes'
        File.open(filename){ |f|
          f.each_byte{ n += 1 }
        }
        return n
    elsif option == 'characters' || option == 'chars'
        File.open(filename){ |f|
          while f.getc
              n += 1
          end
        }
        return n
    elsif option == 'words'
        IO.foreach(filename){ |line|
          n += line.split.length
        }
        return n
    else
        bytes,chars,lines,words = 0,0,0,0
        IO.foreach(filename){ |line|
          lines += 1
          words += line.split.length
          chars += line.split('').length
        }
        File.open(filename){ |f|
          while f.getc
              bytes += 1
          end
        }
        return [bytes,chars,words,lines]
    end
  end # def


  if defined?(Win32Exts)
    Win32Exts |= %w{.exe .com .bat .cmd}
  else
    Win32Exts = %w{.exe .com .bat .cmd}
  end

  # In block form, yields each ((*program*)) within ((*path*)).  In non-block
  # form, returns an array of each ((*program*)) within ((*path*)).  Returns
  # (({nil})) if not found.
  #
  # On the MS Windows platform, it looks for executables ending with .exe,
  # .bat and .com, which you may optionally include in the program name.
  #
  #    File.whereis("ruby") -> ['/usr/local/bin/ruby','/opt/bin/ruby']
  #
  def whereis(prog, path=ENV['PATH']) #:yield:
    dirs = []
    path.split(File::PATH_SEPARATOR).each{|dir|
        # Windows checks against specific extensions
        if File::ALT_SEPARATOR
          if prog.include?('.')
              f = File.join(dir,prog)
              if File.executable?(f) && !File.directory?(f)
                if block_given?
                    yield f.gsub(/\//,'\\')
                else
                    dirs << f.gsub(/\//,'\\')
                end
              end
          else
              Win32Exts.find_all{|ext|
                f = File.join(dir,prog+ext)
                if File.executable?(f) && !File.directory?(f)
                    if block_given?
                      yield f.gsub(/\//,'\\')
                    else
                      dirs << f.gsub(/\//,'\\')
                    end
                end
              }
          end
        else
          f = File.join(dir,prog)
          # Avoid /usr/lib/ruby, for example
          if File.executable?(f) && !File.directory?(f)
              if block_given?
                yield f
              else
                dirs << f
              end
          end
        end
    }
    dirs.empty? ? nil : dirs
  end

  # Looks for the first occurrence of _program_ within _path_.
  #
  # On the MS Windows platform, it looks for executables ending with .exe,
  # .bat and .com, which you may optionally include in the program name.
  # Returns <tt>nil</tt> if not found.
  #
  #--
  # The which() method was adopted from Daniel J. Berger, via PTools
  # which in in turn was adopted fromt the FileWhich code posted by
  # Michael Granger on http://www.rubygarden.org.
  #++
  def which(prog, path=ENV['PATH'])
    path.split(File::PATH_SEPARATOR).each {|dir|
      # Windows checks against specific extensions
      if File::ALT_SEPARATOR
        ext = Win32Exts.find{|ext|
          if prog.include?('.') # Assume extension already included
            f = File.join(dir,prog)
          else
            f = File.join(dir,prog+ext)
          end
          File.executable?(f) && !File.directory?(f)
        }
        if ext
          # Use backslashes, not forward slashes
          if prog.include?('.') # Assume extension already included
            f = File.join( dir, prog ).gsub(/\//,'\\')
          else
            f = File.join( dir, prog + ext ).gsub(/\//,'\\')
          end
          return f
        end
      else
        f = File.join(dir,prog)
        # Avoid /usr/lib/ruby, for example
        if File.executable?(f) && !File.directory?(f)
          return File::join( dir, prog )
        end
      end
    }
    nil
  end

end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

# TODO This test have been remarked out until such time
#      as a mock FileSystem can be used to test it against.

=begin #test

  require 'test/unit'

  # FIND TEST DIRECTORY
  paths = File.expand_path(File.dirname(__FILE__)).split('/')
  paths.size.downto(1) do |i|
    f = (paths.slice(0..i)+['test']).join('/')
    $TESTDIR = File.join(f,'FIXTURE') if File.directory?(f)
  end
  raise unless $TESTDIR

  class TC_FileUtils_HeadTail < Test::Unit::TestCase

    def setup
      @workdir = Dir.getwd
      @thisdir = $TESTDIR

      @tfile = 'test_file.txt'

      @expected_head1 = ["line1\n","line2\n","line3\n","line4\n","line5\n"]
      @expected_head1.push("line6\n","line7\n","line8\n","line9\n","line10\n")
      @expected_head2 = ["line1\n","line2\n","line3\n","line4\n","line5\n"]

      @expected_tail1 = ["line16\n","line17\n","line18\n","line19\n","line20\n"]
      @expected_tail1.push("line21\n","line22\n","line23\n","line24\n","line25\n")
      @expected_tail2 = ["line21\n","line22\n","line23\n","line24\n","line25\n"]

      @expected_body1 = ["line10\n", "line11\n", "line12\n", "line13\n", "line14\n"]
      @expected_body1.push("line15\n","line16\n", "line17\n", "line18\n", "line19\n","line20\n")
      @expected_body2 = ["line14\n","line15\n","line16\n","line17\n","line18\n","line19\n","line20\n"]
      @expected_body3 = ["line5\n","line6\n","line7\n","line8\n","line9\n","line10\n"]
    end

    def test_method
      assert_respond_to( FileUtils, :head )
      assert_respond_to( FileUtils, :tail )
      assert_respond_to( FileUtils, :slice )
    end

    # head

    def test_head
      Dir.chdir @thisdir
      begin
      assert_nothing_raised{ FileUtils.head(@tfile) }
      assert_nothing_raised{ FileUtils.head(@tfile,5) }
      assert_equal(@expected_head1,FileUtils.head(@tfile))
      assert_equal(@expected_head2,FileUtils.head(@tfile,5))
      ensure
        Dir.chdir @workdir
      end
    end

    # slice

    def test_slice
      Dir.chdir @thisdir
      begin
        assert_nothing_raised{ FileUtils.slice(@tfile,5,10) }
        assert_equal(@expected_body3,FileUtils.slice(@tfile,5,10))
      ensure
        Dir.chdir @workdir
      end
    end

    # tail

    def test_tail
      Dir.chdir @thisdir
      begin
        assert_nothing_raised{ FileUtils.tail(@tfile) }
        assert_nothing_raised{ FileUtils.tail(@tfile,5) }
        assert_equal(@expected_tail1,FileUtils.tail(@tfile))
        assert_equal(@expected_tail2,FileUtils.tail(@tfile,5))
      ensure
        Dir.chdir @workdir
      end
    end

  end

=end

# TODO This test needs a Mock File.

=begin #no test yet

  require 'test/unit'

  class TC_FileUtils_WC < Test::Unit::TestCase

    def setup
      @workdir = Dir.getwd
      @thisdir = $TESTDIR

      @file = 'test_file.txt'
    end

    def test_method
      assert_respond_to( FileUtils, :wc )
    end

    def test_wc
      Dir.chdir @thisdir
      begin
        assert_nothing_raised{ FileUtils.wc(@file) }
        assert_nothing_raised{ FileUtils.wc(@file,'bytes') }
        assert_nothing_raised{ FileUtils.wc(@file,'chars') }
        assert_nothing_raised{ FileUtils.wc(@file,'words') }
        assert_nothing_raised{ FileUtils.wc(@file,'lines') }
        assert_raises(RuntimeError){ FileUtils.wc(@file,'bogus') }
      ensure
        Dir.chdir @workdir
      end
    end

    def test_wc_results
      Dir.chdir @thisdir
      begin
        assert_equal([166,166,25,25],FileUtils.wc(@file))
        assert_equal(166,FileUtils.wc(@file,'bytes'),"Wrong number of bytes")
        assert_equal(166,FileUtils.wc(@file,'chars'),"Wrong number of chars")
        assert_equal(25,FileUtils.wc(@file,'words'),"Wrong number of words")
        assert_equal(25,FileUtils.wc(@file,'lines'),"Wrong number of lines")
      ensure
        Dir.chdir @workdir
      end
    end

  end

=end

# TODO This test needs a mock File.

=begin #no test yet

  require 'test/unit'
  require 'rbconfig'

  class TC_FileUtils_Which < Test::Unit::TestCase
    include Config

    def setup
      @workdir = Dir.getwd
      @thisdir = $TESTDIR

      @expected_ruby_exe = File.join( CONFIG['bindir'], CONFIG['ruby_install_name'] )
      if File::ALT_SEPARATOR
          @expected_ruby_exe.gsub!(/\//,'\\')
          @expected_ruby_exe += ".exe"
      end
    end

    def test_method
      assert_respond_to( FileUtils, :which )
    end

    # which

    def test_which
      Dir.chdir @thisdir
      begin
        ruby_exe = nil
        assert_nothing_raised { ruby_exe = FileUtils.which(CONFIG['ruby_install_name']) }
        assert_equal(@expected_ruby_exe, ruby_exe)
        assert_equal(nil, FileUtils.which("blahblah"))
      ensure
        Dir.chdir @workdir
      end
    end

  end

=end

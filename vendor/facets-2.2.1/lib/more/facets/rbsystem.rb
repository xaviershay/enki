# = TITLE:
#
#   System
#
# = SYNOPSIS:
#
#   The System module provides Platform and Ruby system information.
#   The module should also be able to stand in for rbconfig.
#   It is intended for use as a service module although it
#   can be mixed-in too.
#
# = COPYING:
#
#   Copyright (c) 2005 Thomas Sawyer, Minero Aoki
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
# = HISTORY:
#
#   Adapted from RubyParams module by Minero Aoki
#   Copyright (c) 1999-2002 Minero Aoki <aamine@loveruby.net>
#
# = AUTHORS:
#
#   - Thomas Sawyer
#   - Minero Aoki
#
# TODO:
#
#   - Consider renaming module to "Ruby" ?

require 'rbconfig'


# = System
#
# The System module provides Platform and Ruby system information.
# The module should also be able to stand in for rbconfig.
# It is intended for use as a service module although it
# can be mixed-in too.
#
# Note: This library is still being worked on a good bit.

module System

  extend self  # or module_function ?

  # Execution Environment -------------------------------------

  def program_name; $0 ; end
  def program_name=(x); $0=x ; end

  def argv; $* ; end
  alias options argv

  # these won't work here
  #def file; __FILE__ ; end
  #def filepath; File.expand_path(__FILE__) ; end
  #def lineno; __LINE__ ; end

  def process_id; $$ ; end
  alias_method :pid, :process_id

  def child_status; $? ; end
  alias exit_status child_status

  def error_info; $! ; end
  def error_position; $@ ; end

  def debug; $DEBUG; end

  def safe; $SAFE; end

  def verbose; $VERBOSE; end
  def verbose=(x); $VERBOSE=x; end

  def coding; $-K ; end
  def coding=(x); $-K=x ; end

  def line_end_processing; $-l ; end

  def program_loop; $-p ; end

  def environment; ENV ; end
  def env; ENV ; end

  # Input/Ouput Variables -------------------------------------

  def stdin; $stdin ; end
  def stdin=(x); $stdin=x ; end

  def stdout ; $stdout ; end
  def stdout=(x); $stdout=x ; end

  def stderr ; $stderr ; end
  def stderr=(x); $stderr=x ; end

  def default_input ; $< ; end
  alias_method :defin, :default_input
  alias_method :argf, :default_input

  def default_output ; $> ; end
  def default_output=(x); $defout=x ; end
  alias_method :defout, :default_output
  alias_method :defout=, :default_output=

  def output_record_separator ; $\ ; end
  def output_record_separator=(x) ; $\=x ; end
  alias_method :ors, :output_record_separator
  alias_method :ors=, :output_record_separator=

  def output_field_separator ; $-F ; end
  def output_field_separator=(x) ; $-F=x ; end
  alias_method :ofs, :output_field_separator
  alias_method :ofs=, :output_field_separator=

  def input_record_separator ; $/ ; end
  def input_record_separator=(x) ; $/=x ; end
  alias_method :rs, :input_record_separator
  alias_method :rs=, :input_record_separator=

  def input_field_separator ; $/ ; end
  def input_field_separator=(x) ; $/=x ; end
  alias_method :fs, :input_field_separator
  alias_method :fs=, :input_field_separator=

  def input_line_number ; $. ; end
  alias_method :input_lineno, :input_line_number

  # Miscellaneous ---------------------------------------------

  def data; DATA ; end

  # Ruby Config -----------------------------------------------

  ::Config::CONFIG.each do |k,v|
    define_method( k.downcase ) { v }
  end

  alias_method :ruby, :ruby_install_name

  def rubypath
    File.join( bindir, ruby_install_name )
  end

  def platform
    RUBY_PLATFORM
  end

  def version
    RUBY_VERSION
  end

  def release
    RUBY_RELEASE_DATE
  end

  def extentions
    [ 'rb', DLEXT ]
  end

  def rubylibdir
    File.join( libdir, 'ruby'  )
  end

  #def sitelibdir
  #  File.join( rubylibdir, 'site_ruby', version )
  #end
  #
  #STDLIBDIR  = File.join( LIBDIR, VERSION )
  #RBDIR      = File.join( STDLIBDIR )
  #SODIR      = File.join( STDLIBDIR, ARCH )
  #
  #SITE_RB    = File.join( SITELIBDIR )
  #SITE_SO    = File.join( SITELIBDIR, ARCH )

  # load path ----------------------------------------------------

  def load_path; $: ; end

  def loaded_features; $" ; end
  alias_method :required, :loaded_features

  # platform -----------------------------------------------------

  def current_platform
    arch = Config::CONFIG['arch']
    #cpu, os = arch.split '-', 2
    return match_platform(arch)
  end

  #

  def match_platform(arch)
    cpu, os = arch.split '-', 2
    cpu, os = nil, cpu if os.nil? # java

    cpu = case cpu
          when /i\d86/ then 'x86'
          else cpu
          end

    os  = case os
          when /cygwin/ then            [ 'cygwin',  nil ]
          when /darwin(\d+)?/ then      [ 'darwin',  $1  ]
          when /freebsd(\d+)/ then      [ 'freebsd', $1  ]
          when /^java$/ then            [ 'java',    nil ]
          when /^java([\d.]*)/ then     [ 'java',    $1  ]
          when /linux/ then             [ 'linux',   $1  ]
          when /mingw32/ then           [ 'mingw32', nil ]
          when /mswin32/ then           [ 'mswin32', nil ]
          when /openbsd(\d+\.\d+)/ then [ 'openbsd', $1  ]
          when /solaris(\d+\.\d+)/ then [ 'solaris', $1  ]
          else                          [ 'unknown', nil ]
          end

    [cpu, os].flatten.compact.join("-")
  end

end

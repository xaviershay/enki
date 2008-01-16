# = TITLE:
#   Verbosity Reporting Extensions
#
# = DESCRIPTION:
#   Kernel extensions dealing with verbosity of warnings
#   and error messages.
#
# = AUTHORS:
#   - David Heinemeier Hansson
#   - TransSilentNight
#
# = LOG:
#   - trans 07.09.01 Deprecated #silently as alias of slience_warnings.

module Kernel
  module_function

  # Silences any stream for the duration of the block.
  #
  #   silence_stream(STDOUT) do
  #     puts 'This will never be seen'
  #   end
  #
  #   puts 'But this will'
  #
  #   CREDIT: David Heinemeier Hansson

  def silence_stream(stream)
    old_stream = stream.dup
    stream.reopen(RUBY_PLATFORM =~ /mswin/ ? 'NUL:' : '/dev/null')
    stream.sync = true
    yield
  ensure
    stream.reopen(old_stream)
  end
  #alias_method :silently, :silence_stream

  # For compatibility.
  def silence_stderr #:nodoc:
    silence_stream(STDERR) { yield }
  end

  # Sets $VERBOSE to nil for the duration of the block
  # and back to its original value afterwards.
  #
  #   silence_warnings do
  #     value = noisy_call # no warning voiced
  #   end
  #
  #   noisy_call  # no warning is voiced

  def silence_warnings
    old_verbose, $VERBOSE = $VERBOSE, nil
    yield
  ensure
    $VERBOSE = old_verbose
  end

  # Sets $VERBOSE to true for the duration of the block
  # and back to its original value afterwards.
  def enable_warnings
    old_verbose, $VERBOSE = $VERBOSE, true
    yield
  ensure
    $VERBOSE = old_verbose
  end

  # Supress errors while executing a block, with execptions.
  #
  #   CREDIT: David Heinemeier Hansson

  def suppress(*exception_classes)
    begin yield
    rescue Exception => e
      raise unless exception_classes.any? { |cls| e.kind_of?(cls) }
    end
  end

end

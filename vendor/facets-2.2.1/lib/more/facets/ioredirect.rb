# TITLE:
#
#   IORedirect
#
# SUMMARY:
#
#   A class to redirect $stdout, or other IO object, to a StringIO object,
#   or any other object with a write() method.
#
# COPYRIGHT:
#
#   Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
#
# LICENSE:
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
# HISTORY:
#
#   IORedirect was ported from Paul Brannan's Ruby Treasures.
#
# AUTHORS:
#
#   - Paul Brannan <paul@atdesk.com>


# = IORedirect
#
# A class to redirect $stdout, or other IO object, to a StringIO object,
# or any other object with a write() method.
#
# == Synopsis
#
#   s = StringIO.new
#   r = Redirector.redirect($stdout, s) do
#     $stdout.puts "this is a test"
#   end
#
class IORedirect

  # Start redirection from one IO object to any other object with a
  # write() method. +from+ is the IO object to redirect from,
  # and +to+ is the object to redirect to.
  def initialize(from, to)
    @from = from
    @to = to
    start()
  end

  # Start redirection, if it has not already been started.
  def start
    raise "Redirection already in progress" if @t
    tmp = @from.dup
    r, w = IO.pipe
    @from.reopen(w)
    @t = Thread.new do
      begin
        loop do
          s = r.read(1) # TODO: can I make this buffered?
          @to.write(s)
        end
      ensure
        @from.reopen(tmp)
        @t = nil
      end
    end
  end

  # Stop redirection, if it is occurring
  def stop
    raise "Redirection already stopped" if not @t
    @t.kill
  end

  # An exception-safe class method for redirection
  def self.redirect(from, to)
    s = self.new(from, to)
    begin
      yield
    ensure
      s.stop
    end
  end
end


# --- test ---

if __FILE__ == $0 then

  class SimpleStringIO
    attr_reader :str
    def initialize; @str = ''; end
    def write(str); @str << str; end
  end

  Thread.abort_on_exception = true
  s = SimpleStringIO.new
  r = Redirector.redirect($stdout, s) do
    $stdout.puts "this is a test"
    $stdout.puts "of the StringIO redirection system"
  end
  puts "Done redirecting."
  puts "Result:\n#{s.str}"

end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

# TODO

=begin #testing

  require 'test/unit'

=end




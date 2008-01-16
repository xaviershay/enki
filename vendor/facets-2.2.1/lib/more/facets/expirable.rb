# TITLE:
#
#   Expirable
#
# SUMMARY:
#
#   Generic expirability mixin.
#
# COPYRIGHT:
#
#   Copyright (c) 2004 George Moschovitis
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
# AUTHORS:
#
#   - George Moschovitis


# = Expirable
#
# Generic expirability mixin.
#
module Expirable

  attr_accessor :expires

  # Set the expires timeout for this entry.

  def expires_after(timeout = (60*60*24))
    @expires = Time.now + timeout
  end

  # Set the expire timeout for this entry. The timeout happens
  # after (base + rand(spread)) seconds.

  def expires_spread(base, spread)
    @expires = Time.now + base + rand(spread)
  end

  # Is this entry expired?

  def expired?
    if @expires.nil? or (Time.now > @expires)
      return true
    else
      return false
    end
  end

  # Update the expiration period. Override in your application.

  def touch!
  end

end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

# TODO

=begin #test

  require 'test/unit'

  class TC_Expirable < Test::Unit::TestCase

    def test_01
    end

  end

=end

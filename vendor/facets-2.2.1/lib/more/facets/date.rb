# TITLE:
#
#   Date Extended
#
# SUMMARY:
#
#   Ruby's standard Date class with a few extensions.
#
# COPYRIGHT:
#
#   Copyright (c) 2004 Thomas Sawyer
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
#   - Thomas Sawyer

require 'date'

# = Date
#
# Ruby's standard Date class with a few extensions.
class Date

  # To be able to keep Dates and Times
  # interchangeable on conversions.
  def to_date
    self
  end

  # Convert Date to Time.
  #
  def to_time(form = :local)
    ::Time.send(form, year, month, day)
  end

  # An enhanched #to_s method that cane take an optional
  # format flag of :short or :long.
  def stamp(format = nil)
    case format
    when :short
      strftime("%e %b").strip
    when :long
      strftime("%B %e, %Y").strip
    else
      strftime("%Y-%m-%d")  # standard to_s
    end
  end

  # Enhance #to_s by aliasing to #stamp.
  alias_method( :to_s, :stamp )

  # Returns the number of days in the date's month.
  #
  #   Date.new(2004,2).days_in_month #=> 28
  #
  #--
  # Credit goes to Ken Kunz.
  #++
  def days_in_month
     Date.civil(year, month, -1).day
  end

  def days_of_month
    (1..days_in_month).to_a
  end

end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#
=begin test

  require 'test/unit'

  class TCDate < Test::Unit::TestCase

    def setup
      @d = Date.civil( 2005, 04, 20 )
    end

    def test_to_date
      assert_instance_of( ::Date, @d.to_date )
    end

    def test_to_time
      assert_instance_of( ::Time, @d.to_time )
    end

    def test_to_s
      assert_equal( "2005-04-20", @d.to_s )
    end


    def test_stamp_1
      assert_equal( "2005-04-20", @d.stamp )
    end

    def test_stamp_2
      assert_equal( "20 Apr", @d.stamp(:short) )
    end

    def test_stamp_3
      assert_equal( "April 20, 2005", @d.stamp(:long) )
    end

    def test_days_in_month
      assert_equal( 31, Date.new(2004,1,1).days_in_month )
    end

    def test_days_of_month
      assert_equal( (1..@d.days_in_month).to_a, @d.days_of_month )
    end

  end

=end

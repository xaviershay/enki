# TITLE:
#
#   Multipliers
#
# DESCRIPTION:
#
#   Adds methods to Numeric to make working with
#   magnitudes (kilo, mega, giga, milli, micro, etc.)
#   as well as bits and bytes easier.
#
# COPYRIGHT:
#
#   Copyright (c) 2005 Thomas Sawyer
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
#   Thanks to Rich Kilmer and bytes.rb which inspired this library.
#
# AUTHORS:
#
#   - Thomas Sawyer
#
# NOTES:
#
#   - This library is not compatible with STICK's units.rb (an spin-off
#     of Facets old units.rb library). Do not attempt to use both at the same time.


# = Multipliers
#
# Adds methods to Numeric to make working with
# magnitudes (kilo, mega, giga, milli, micro, etc.)
# as well as bits and bytes easier.
#
#   1.kilo               #=> 1000
#   1.milli              #=> 0.001
#   1.kibi               #=> 1024
#
# To display a value in a certain denomination, simply
# perform the inverse operation by placing the
# multiplier called on unit (1) in the denominator.
#
#   1000 / 1.kilo        #=> 1
#   1024 / 1.kibi        #=> 1
#

class Numeric

  # SI Multipliers

  def deka  ; self * 10 ; end
  def hecto ; self * 100 ; end
  def kilo  ; self * 1000 ; end
  def mega  ; self * 1000000 ; end
  def giga  ; self * 1000000000 ; end
  def tera  ; self * 1000000000000 ; end
  def peta  ; self * 1000000000000000 ; end
  def exa   ; self * 1000000000000000000 ; end

  # SI Fractional

  def deci  ; self.to_f / 10 ; end
  def centi ; self.to_f / 100 ; end
  def milli ; self.to_f / 1000 ; end
  def micro ; self.to_f / 1000000 ; end
  def nano  ; self.to_f / 1000000000 ; end
  def pico  ; self.to_f / 1000000000000 ; end
  def femto ; self.to_f / 1000000000000000 ; end
  def atto  ; self.to_f / 1000000000000000000 ; end

  # SI Binary

  def kibi ; self * 1024 ; end
  def mebi ; self * 1024**2 ; end
  def gibi ; self * 1024**3 ; end
  def tebi ; self * 1024**4 ; end
  def pebi ; self * 1024**5 ; end
  def exbi ; self * 1024**6 ; end

  # Bits and Bytes

  def bit   ; self ; end
  def bits  ; self ; end
  def byte  ; self * 8 ; end
  def bytes ; self * 8 ; end

end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

=begin testing

  require 'test/unit'

  class TC_Multipliers < Test::Unit::TestCase

    def test_deka
      assert_equal( 10, 1.deka )
    end

    def test_hecto
      assert_equal( 100, 1.hecto )
    end

    def test_kilo
      assert_equal( 1000, 1.kilo )
    end

    def test_mega
      assert_equal( 1000000, 1.mega )
    end

    def test_giga
      assert_equal( 1000000000, 1.giga )
    end

    def test_tera
      assert_equal( 1000000000000, 1.tera )
    end

    def test_peta
      assert_equal( 1000000000000000, 1.peta )
    end

    def test_exa
      assert_equal( 1000000000000000000, 1.exa )
    end

    # Fractional

    def test_deci
      assert_equal( 0.1, 1.deci )
    end

    def test_centi
      assert_equal( 0.01, 1.centi )
    end

    def test_milli
      assert_equal( 0.001, 1.milli )
    end

    def test_milli
      assert_equal( 0.000001, 1.micro )
    end

    def test_nano
      assert_equal( 0.000000001, 1.nano )
    end

    def test_pico
      assert_equal( 0.000000000001, 1.pico )
    end

    def test_femto
      assert_equal( 0.000000000000001, 1.femto )
    end

    def test_atto
      assert_equal( 0.000000000000000001, 1.atto )
    end

    # SI Binary

    def test_kibi
      assert_equal( 1024, 1.kibi )
    end

    def test_mebi
      assert_equal( 1024**2, 1.mebi )
    end

    def test_gibi
      assert_equal( 1024**3, 1.gibi )
    end

    def test_tebi
      assert_equal( 1024**4, 1.tebi )
    end

    def test_pebi
      assert_equal( 1024**5, 1.pebi )
    end

    def test_exbi
      assert_equal( 1024**6, 1.exbi )
    end

  end

=end

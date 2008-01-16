# Test facets/multipliers.rb

require 'facets/multipliers.rb'

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

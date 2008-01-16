# Test facets/buildingblock.rb

require 'facets/buildingblock.rb'
require 'test/unit'

class TestBuildingBlock < Test::Unit::TestCase

  module M
    extend self
    def m(n,*m) ; "#{n}{#{m}}"; end
    def t(n) ; "#{n}"; end
  end

  def test_01
    build = BuildingBlock.new(M, :m)

    build.html do
      head do
        title "Test"
      end

      body do
        i "Hello"
        build! :not
        t "Test"
        t "Hey"
      end
    end

    r = "html{head{title{Test}}body{i{Hello}not{}TestHey}}"

    assert_equal( r, build.to_s )
  end

end

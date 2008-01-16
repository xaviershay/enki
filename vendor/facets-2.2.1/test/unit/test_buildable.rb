# Test facets/buildable.rb

require 'facets/buildable.rb'
require 'test/unit'

class TestBuildable < Test::Unit::TestCase

  module M
    include Buildable

    extend self

    def m(n,*m) ; "#{n}{#{m}}"; end
    def t(n) ; "#{n}"; end

    alias :build :m
  end

  def test_01
    str = M.build do
      html do
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
    end

    r = "html{head{title{Test}}body{i{Hello}not{}TestHey}}"

    assert_equal( r, M.builder.to_s )
  end

end

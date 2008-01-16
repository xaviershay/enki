# Test for facets/arguments.rb.

require 'test/unit'
require 'facets/arguments.rb'

class TestArguments < Test::Unit::TestCase

  include Console

  def test_parameters
    line = "-x baz --foo=8 bar"
    cargs = Arguments.new(line)
    args, keys = cargs.parameters
    assert_equal(['baz','bar'], args)
    assert_equal({'foo'=>'8','x'=>true}, keys)
  end

  def test_parameters_with_arity
    line = "-g a -x b -x c"
    cargs = Arguments.new(line, :g=>1, :x=>1)
    args, keys = cargs.parameters
    assert_equal({'g'=>'a','x'=>['b','c']}, keys)
    assert_equal([], args)
  end

  def test_flags
    line = "-x baz --foo=8 bar"
    cargs = Arguments.new(line)
    flags = cargs.flags
    assert_equal(['x'], flags)
  end

  def test_repeat
    line = "-x baz --foo=1 --foo=2 bar"
    cargs = Arguments.new(line)
    args, keys = cargs.parameters
    assert_equal(['baz','bar'], args)
    assert_equal({'x'=>true,'foo'=>['1','2']}, keys)
  end

  def test_preoptions
    line = "-x --foo=7 baz -y bar"
    cargs = Arguments.new(line)
    flags = cargs.preoptions
    assert_equal({'x'=>true,'foo'=>'7'}, flags)
  end

  def test_with_arity
    line = "-q baz --aq 5 bar"
    cargs = Arguments.new(line,'aq'=>1)
    words, flags = cargs.parameters
    assert_equal(['baz','bar'],words)
    assert_equal({'q'=>true,'aq'=>'5'},flags)
  end
end

# Test facets/coroutine.rb

require 'facets/coroutine.rb'
require 'test/unit'

class TC_Coroutine < Test::Unit::TestCase

  def test_run
    assert_nothing_raised {

      count = 100
      input = (1..count).map { (rand * 10000).round.to_f / 100 }

      @producer = Coroutine.new do |me|
        loop do
          1.upto(6) do
            me[:last_input] = input.shift
            me.resume(@printer)
          end
          input.shift  # discard every seventh input number
        end
      end

      @printer = Coroutine.new do |me|
        loop do
          1.upto(8) do
            me.resume(@producer)
            if @producer[:last_input]
              @producer[:last_input] = nil
            end
            me.resume(@controller)
          end
        end
      end

      @controller = Coroutine.new do |me|
        until input.empty? do
          me.resume(@printer)
        end
      end
      @controller.run

    }
  end

end

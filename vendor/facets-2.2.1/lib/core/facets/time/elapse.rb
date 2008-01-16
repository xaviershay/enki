class Time

  # Tracks the elapse time of a code block.
  #
  #   Time.elapse { sleep 1 }  #=> 0.999188899993896
  #
  #   CREDIT: Hal Fulton

  def self.elapse
    raise "Need block" unless block_given?
    t0 = Time.now.to_f
    yield
    Time.now.to_f - t0
  end

end

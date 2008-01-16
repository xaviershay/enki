class Time

  # Returns a new Time where one or more of the elements
  # have been changed according to the +options+ parameter.
  # The time options (hour, minute, sec, usec) reset
  # cascadingly, so if only the hour is passed, then
  # minute, sec, and usec is set to 0. If the hour and
  # minute is passed, then sec and usec is set to 0.
  #
  #  t = Time.now            #=> Sat Dec 01 14:10:15 -0500 2007
  #  t.change(:hour => 11)   #=> Sat Dec 01 11:00:00 -0500 2007
  #
  #  CREDIT: David Hansson (?)

  def change(options)
    opts={}; options.each_pair{ |k,v| opts[k] = v.to_i }
    self.class.send( self.utc? ? :utc : :local,
      opts[:year]  || self.year,
      opts[:month] || self.month,
      opts[:day]   || self.day,
      opts[:hour]  || self.hour,
      opts[:min]   || (opts[:hour] ? 0 : self.min),
      opts[:sec]   || ((opts[:hour] || opts[:min]) ? 0 : self.sec),
      opts[:usec]  || ((opts[:hour] || opts[:min] || opts[:usec]) ? 0 : self.usec)
    )
  end

end

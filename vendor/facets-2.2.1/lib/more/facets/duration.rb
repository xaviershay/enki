# = Title:
#
#   Duration
#
# = Synopsis:
#
#   Duration is a simple class that provides ways of easily manipulating durations
#   (timespans) and formatting them as well.
#
# = Copying:
#
#   Copyright (c) 2006 Matthew Harris <shugotenshi at gmail.com>
#
# = Author:
#
#   Matthew Harris (mailto:shugotenshi@gmail.com)
#
# = Notes:
#
#   - This library comes from the orginal Duration project.
#     See: http://www.rubyforge.org/projects/duration
#

# = Duration
#
#   Duration is a simple class that provides ways of easily manipulating durations
#   (timespans) and formatting them as well.
#
# == Usage:
#
#     require 'duration'
#     => true
#     d = Duration.new(60 * 60 * 24 * 10 + 120 + 30)
#     => #<Duration: 1 week, 3 days, 2 minutes and 30 seconds>
#     d.to_s
#     => "1 week, 3 days, 2 minutes and 30 seconds"
#     [d.weeks, d.days]
#     => [1, 3]
#     d.days = 7; d
#     => #<Duration: 2 weeks, 2 minutes and 30 seconds>
#     d.strftime('%w w, %d d, %h h, %m m, %s s')
#     => "2 w, 0 d, 0 h, 2 m, 30 s"

class Duration
    include Comparable
    include Enumerable

    attr_reader :total, :weeks, :days, :hours, :minutes

    WEEK    =  60 * 60 * 24 * 7
    DAY     =  60 * 60 * 24
    HOUR    =  60 * 60
    MINUTE  =  60
    SECOND  =  1

    # Initialize Duration class.
    #
    # *Example*
    #
    #     d = Duration.new(60 * 60 * 24 * 10 + 120 + 30)
    #     => #<Duration: 1 week, 3 days, 2 minutes and 30 seconds>
    #     d = Duration.new(:weeks => 1, :days => 3, :minutes => 2, :seconds => 30)
    #     => #<Duration: 1 week, 3 days, 2 minutes and 30 seconds>
    #
    def initialize(seconds_or_attr = 0)
        if seconds_or_attr.kind_of? Hash
            # Part->time map table.
            h = {:weeks => WEEK, :days => DAY, :hours => HOUR, :minutes => MINUTE, :seconds => SECOND}

            # Loop through each valid part, ignore all others.
            seconds = seconds_or_attr.inject(0) do |sec, args|
                # Grab the part of the duration (week, day, whatever) and the number of seconds for it.
                part, time = args

                # Map each part to their number of seconds and the given value.
                # {:weeks => 2} maps to h[:weeks] -- so... weeks = WEEK * 2
                if h.key?(prt = part.to_s.to_sym) then sec + time * h[prt] else 0 end
            end
        else
            seconds = seconds_or_attr
        end

        @total, array = seconds.to_f.round, []
        @seconds = [WEEK, DAY, HOUR, MINUTE].inject(@total) do |left, part|
            array << left / part; left % part
        end

        @weeks, @days, @hours, @minutes = array
    end

    # Format duration.
    #
    # *Identifiers*
    #
    #     %w -- Number of weeks
    #     %d -- Number of days
    #     %h -- Number of hours
    #     %m -- Number of minutes
    #     %s -- Number of seconds
    #     %t -- Total number of seconds
    #     %x -- Duration#to_s
    #     %% -- Literal `%' character
    #
    # *Example*
    #
    #     d = Duration.new(:weeks => 10, :days => 7)
    #     => #<Duration: 11 weeks>
    #     d.strftime("It's been %w weeks!")
    #     => "It's been 11 weeks!"
    #
    def strftime(fmt)
        h =\
        {'w' => @weeks  ,
         'd' => @days   ,
         'h' => @hours  ,
         'm' => @minutes,
         's' => @seconds,
         't' => @total  ,
         'x' => to_s}

        fmt.gsub(/%?%(w|d|h|m|s|t|x)/) do |match|
            match.size == 3 ? match : h[match[1..1]]
        end.gsub('%%', '%')
    end

    # Get the number of seconds of a given part, or simply just get the number of
    # seconds.
    #
    # *Example*
    #
    #     d = Duration.new(:weeks => 1, :days => 1, :hours => 1, :seconds => 30)
    #     => #<Duration: 1 week, 1 day, 1 hour and 30 seconds>
    #     d.seconds(:weeks)
    #     => 604800
    #     d.seconds(:days)
    #     => 86400
    #     d.seconds(:hours)
    #     => 3600
    #     d.seconds
    #     => 30
    #
    def seconds(part = nil)
        # Table mapping
        h = {:weeks => WEEK, :days => DAY, :hours => HOUR, :minutes => MINUTE}

        if [:weeks, :days, :hours, :minutes].include? part
            __send__(part) * h[part]
        else
            @seconds
        end
    end

    # For iterating through the duration set of weeks, days, hours, minutes, and
    # seconds.
    #
    # *Example*
    #
    #     Duration.new(:weeks => 1, :seconds => 30).each do |part, time|
    #         puts "part: #{part}, time: #{time}"
    #     end
    #
    # _Output_
    #
    #     part: weeks, time: 1
    #     part: days, time: 0
    #     part: hours, time: 0
    #     part: minutes, time: 0
    #     part: seconds, time: 30
    #
    def each
        [['weeks'   ,  @weeks  ],
         ['days'    ,  @days   ],
         ['hours'   ,  @hours  ],
         ['minutes' ,  @minutes],
         ['seconds' ,  @seconds]].each do |part, time|
             # Yield to block
            yield part, time
        end
    end

    # Calls `<=>' on Duration#total.
    #
    # *Example*
    #
    #     5.days == 24.hours * 5
    #     => true
    #
    def <=>(other)
        @total <=> other.to_i
    end

    # Set the number of weeks.
    #
    # *Example*
    #
    #     d = Duration.new(0)
    #     => #<Duration: ...>
    #     d.weeks = 2; d
    #     => #<Duration: 2 weeks>
    #
    def weeks=(n)
        initialize(:weeks => n, :seconds => @total - seconds(:weeks))
    end

    # Set the number of days.
    #
    # *Example*
    #
    #     d = Duration.new(0)
    #     => #<Duration: ...>
    #     d.days = 5; d
    #     => #<Duration: 5 days>
    #
    def days=(n)
        initialize(:days => n, :seconds => @total - seconds(:days))
    end

    # Set the number of hours.
    #
    # *Example*
    #
    #     d = Duration.new(0)
    #     => #<Duration: ...>
    #     d.hours = 5; d
    #     => #<Duration: 5 hours>
    #
    def hours=(n)
        initialize(:hours => n, :seconds => @total - seconds(:hours))
    end

    # Set the number of minutes.
    #
    # *Example*
    #
    #     d = Duration.new(0)
    #     => #<Duration: ...>
    #     d.minutes = 30; d
    #     => #<Duration: 30 minutes>
    #
    def minutes=(n)
        initialize(:minutes => n, :seconds => @total - seconds(:minutes))
    end

    # Set the number of minutes.
    #
    # *Example*
    #
    #     d = Duration.new(0)
    #     => #<Duration: ...>
    #     d.seconds = 30; d
    #     => #<Duration: 30 seconds>
    #
    def seconds=(n)
        initialize(:seconds => (@total + n) - @seconds)
    end

    # Friendly, human-readable string representation of the duration.
    #
    # *Example*
    #
    #     d = Duration.new(:seconds => 140)
    #     => #<Duration: 2 minutes and 20 seconds>
    #     d.to_s
    #     => "2 minutes and 20 seconds"
    #
    def to_s
        str = ''

        each do |part, time|
            # Skip any zero times.
            next if time.zero?

            # Concatenate the part of the time and the time itself.
            str << "#{time} #{time == 1 ? part[0..-2] : part}, "
        end

        str.chomp(', ').sub(/(.+), (.+)/, '\1 and \2')
    end

    # Inspection string--Similar to #to_s except that it has the class name.
    #
    # *Example*
    #
    #     Duration.new(:seconds => 140)
    #     => #<Duration: 2 minutes and 20 seconds>
    #
    def inspect
        "#<#{self.class}: #{(s = to_s).empty? ? '...' : s}>"
    end

    # Add to Duration.
    #
    # *Example*
    #
    #     d = Duration.new(30)
    #     => #<Duration: 30 seconds>
    #     d + 30
    #     => #<Duration: 1 minute>
    #
    def +(other)
        self.class.new(@total + other.to_i)
    end

    # Subtract from Duration.
    #
    # *Example*
    #
    #     d = Duration.new(30)
    #     => #<Duration: 30 seconds>
    #     d - 15
    #     => #<Duration: 15 seconds>
    #
    def -(other)
        self.class.new(@total - other.to_i)
    end

    # Multiply two Durations.
    #
    # *Example*
    #
    #     d = Duration.new(30)
    #     => #<Duration: 30 seconds>
    #     d * 2
    #     => #<Duration: 1 minute>
    #
    def *(other)
        self.class.new(@total * other.to_i)
    end

    # Divide two Durations.
    #
    # *Example*
    #
    #     d = Duration.new(30)
    #     => #<Duration: 30 seconds>
    #     d / 2
    #     => #<Duration: 15 seconds>
    #
    def /(other)
        self.class.new(@total / other.to_i)
    end

    alias to_i total
end

# BigDuration is a variant of Duration that supports years and months. Support
# for months is not accurate, as a month is assumed to be 30 days so use at your
# own risk.
#
class BigDuration < Duration
    attr_reader :years, :months

    YEAR   =  60 * 60 * 24 * 30 * 12
    MONTH  =  60 * 60 * 24 * 30

    # Similar to Duration.new except that BigDuration.new supports `:years' and
    # `:months' and will also handle years and months correctly when breaking down
    # the seconds.
    #
    def initialize(seconds_or_attr = 0)
        if seconds_or_attr.kind_of? Hash
            # Part->time map table.
            h =\
            {:years    =>  YEAR  ,
             :months   =>  MONTH ,
             :weeks    =>  WEEK  ,
             :days     =>  DAY   ,
             :hours    =>  HOUR  ,
             :minutes  =>  MINUTE,
             :seconds  =>  SECOND}

            # Loop through each valid part, ignore all others.
            seconds = seconds_or_attr.inject(0) do |sec, args|
                # Grab the part of the duration (week, day, whatever) and the number of seconds for it.
                part, time = args

                # Map each part to their number of seconds and the given value.
                # {:weeks => 2} maps to h[:weeks] -- so... weeks = WEEK * 2
                if h.key?(prt = part.to_s.to_sym) then sec + time * h[prt] else 0 end
            end
        else
            seconds = seconds_or_attr
        end

        @total, array = seconds.to_f.round, []
        @seconds = [YEAR, MONTH, WEEK, DAY, HOUR, MINUTE].inject(@total) do |left, part|
            array << left / part; left % part
        end

        @years, @months, @weeks, @days, @hours, @minutes = array
    end

    # BigDuration variant of Duration#strftime.
    #
    # *Identifiers: BigDuration*
    #
    #     %y -- Number of years
    #     %m -- Number of months
    #
    def strftime(fmt)
        h = {'y' => @years, 'M' => @months}
        super(fmt.gsub(/%?%(y|M)/) { |match| match.size == 3 ? match : h[match[1..1]] })
    end

    # Similar to Duration#each except includes years and months in the interation.
    #
    def each
        [['years'   ,  @years  ],
         ['months'  ,  @months ],
         ['weeks'   ,  @weeks  ],
         ['days'    ,  @days   ],
         ['hours'   ,  @hours  ],
         ['minutes' ,  @minutes],
         ['seconds' ,  @seconds]].each do |part, time|
             # Yield to block
            yield part, time
        end
    end

    # Derived from Duration#seconds, but supports `:years' and `:months' as well.
    #
    def seconds(part = nil)
        h = {:years => YEAR, :months => MONTH}
        if [:years, :months].include? part
            __send__(part) * h[part]
        else
            super(part)
        end
    end

    # Set the number of years in the BigDuration.
    #
    def years=(n)
        initialize(:years => n, :seconds => @total - seconds(:years))
    end

    # Set the number of months in the BigDuration.
    #
    def months=(n)
        initialize(:months => n, :seconds => @total - seconds(:months))
    end
end

# The following important additions are made to Numeric:
#
#     Numeric#weeks   -- Create a Duration object with given weeks
#     Numeric#days    -- Create a Duration object with given days
#     Numeric#hours   -- Create a Duration object with given hours
#     Numeric#minutes -- Create a Duration object with given minutes
#     Numeric#seconds -- Create a Duration object with given seconds
#
# BigDuration support:
#
#     Numeric#years   -- Create a BigDuration object with given years
#     Numeric#months  -- Create a BigDuration object with given months
#
# BigDuration objects can be created from regular weeks, days, hours, etc by
# providing `:big' as an argument to the above Numeric methods.

#
class Numeric
    # Create a Duration object using self where self could represent weeks, days,
    # hours, minutes, and seconds.
    #
    # *Example*
    #
    #     10.duration(:weeks)
    #     => #<Duration: 10 weeks>
    #     10.duration
    #     => #<Duration: 10 seconds>
    #
    def duration(part = nil, klass = Duration)
        if [:years, :months, :weeks, :days, :hours, :minutes, :seconds].include? part
            klass.new(part => self)
        else
            klass.new(self)
        end
    end

    # TODO: IF WE WANT TO DO THIS IT NEEDS TO BE ADDED TO times.rb ???
    #
    #     alias __numeric_old_method_missing method_missing
    #
    #     # Intercept calls to .weeks, .days, .hours, .minutes and .seconds because
    #     # Rails defines its own methods, so I'd like to prevent any redefining of
    #     # Rails' methods. If these methods don't get captured, then alternatively
    #     # Numeric#duration can be used.
    #     #
    #     # BigDuration methods include .years and .months, also BigDuration objects
    #     # can be created from any time such as weeks or minutes and even seconds.
    #     #
    #     # *Example: BigDuration*
    #     #
    #     #     5.years
    #     #     => #<BigDuration: 5 years>
    #     #     10.minutes(:big)
    #     #     => #<BigDuration: 10 minutes>
    #     #
    #     # *Example*
    #     #
    #     #     140.seconds
    #     #     => #<Duration: 2 minutes and 20 seconds>
    #     #
    #     def method_missing(method, *args)
    #         if [:weeks, :days, :hours, :minutes, :seconds].include? method
    #             if args.size > 0 && args[0] == :big
    #                 duration(method, BigDuration)
    #             else
    #                 duration(method)
    #             end
    #         elsif [:years, :months].include? method
    #             duration(method, BigDuration)
    #         else
    #             __numeric_old_method_missing(method, *args)
    #         end
    #     end

end

# Time#duration has been added to convert the UNIX timestamp into a Duration.
# See Time#duration for an example.
#
class Time
    # Create a Duration object from the UNIX timestamp.
    #
    # *Example*
    #
    #     Time.now.duration
    #     => #<Duration: 1898 weeks, 6 days, 1 hour, 12 minutes and 1 second>
    #
    def duration(type = nil)
        if type == :big then BigDuration.new(to_i) else Duration.new(to_i) end
    end
end
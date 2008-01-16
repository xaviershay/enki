require 'benchmark'

class Integer
  def fact1
    return 1 if zero?
    f = 1
    2.upto(self) { |n| f *= n }
    f
  end

  def fact2
    (2..self).inject(1){|fact,i| fact*i}
  end
end

Benchmark.bm do |b|
  n = 1000

  b.report("current") do
    n.times do
      (0..20).each {|i| i.fact1}
    end
  end

  b.report("inject") do
    n.times do
      (0..20).each {|i| i.fact2}
    end
  end
end


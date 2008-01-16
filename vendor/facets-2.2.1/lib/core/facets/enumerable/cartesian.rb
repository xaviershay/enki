module Enumerable

  # Provides the cross-product of two or more Enumerables.
  # This is the class-level method. The instance method
  # calls on this.
  #
  #   Enumerable.cart([1,2], [4], ["apple", "banana"])
  #   #=> [[1, 4, "apple"], [1, 4, "banana"], [2, 4, "apple"], [2, 4, "banana"]]
  #
  #   Enumerable.cart([1,2], [3,4])
  #   #=> [[1, 3], [1, 4], [2, 3], [2, 4]]
  #
  #   CREDIT: Thomas Hafner

  def self.cartesian_product(*enums, &block)
    result = [[]]
    while [] != enums
      t, result = result, []
      b, *enums = enums
      t.each do |a|
        b.each do |n|
          result << a + [n]
        end
      end
    end
    if block_given?
      result.each{ |e| block.call(e) }
    else
      result
    end
  end

  class << self
    alias_method :cart, :cartesian_product
  end

  # The instance level version of <tt>Enumerable::cartesian_product</tt>.
  #
  #   a = []
  #   [1,2].cart([4,5]){|elem| a << elem }
  #   a  #=> [[1, 4],[1, 5],[2, 4],[2, 5]]
  #
  #   CREDIT: Thomas Hafner

  def cartesian_product(*enums, &block)
    Enumerable.cartesian_product(self, *enums, &block)
  end

  alias_method :cart, :cartesian_product

  # Operator alias for cross-product.
  #
  #   a = [1,2] ** [4,5]
  #   a  #=> [[1, 4],[1, 5],[2, 4],[2, 5]]
  #
  #   CREDIT: Trans

  def **(enum)
    Enumerable.cartesian_product(self, enum)
  end

end

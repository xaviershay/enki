# There is no continuation in Ruby 1.9.

raise "Ruby 1.9+ does not support continuations." unless Continuation

# Creates a continuation in a way that is easier to use than callcc.
# On the initial call this will return the created Continuation and
# the arguments you gave to Continuation.create in an Array. If you
# then issue .call() on the Continuation execution will jump back to
# the point of time where you initially invoked Continuation.create,
# but this time it will return the Continuation and the arguments
# you supplied in an Array.
#
# You can supply a block instead of default arguments which will
# cause that block to be executed once and its result to be returned
# along side the created Continuation, but this form is confusing
# and does only rarely make sense.
#
#   # Count from 0 to 10
#   cc, counter = Continuation.create(0)
#   puts counter
#   cc.call(counter + 1) if counter < 10
#
#   # Implement something similar to Array#inject using Continuations.
#   # For simplicity's sake, this is not fully compatible with the real
#   # inject. Make sure that you understand Array#inject before you try
#   # to understand this.
#   class Array
#     def cc_inject(value = nil)
#       copy = self.clone
#       cc, result, item = Continuation.create(value, nil)
#       next_item = copy.shift
#       if result and item
#         # Aggregate the result using the block.
#         cc.call(yield(result, item), next_item)
#       elsif next_item
#         # item not yet set and Array is not empty:
#         # This means we did not get a value and thus need to use the
#         # first item from the Array before we can start using the
#         # block to aggregate the result.
#         cc.call(next_item, result)
#       end
#
#       return result
#    end
#  end
#  [1,2,3,4,5].cc_inject { |acc, n| acc + n } # => 15
#

def Continuation.create(*args, &block)
  args = [args] if not args.nil? and not args.is_a? Array # 1.6.8 compatibility
  cc = nil; result = callcc {|c| cc = c; block.call(cc) if block and args.empty?}
  result ||= args
  return *[cc, *result]
end

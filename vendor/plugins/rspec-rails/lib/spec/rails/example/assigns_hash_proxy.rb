module Spec
  module Rails
    module Example
      class AssignsHashProxy #:nodoc:
        def initialize(example_group, &block)
          @block = block
          @example_group = example_group
        end

        def [](ivar)
          if assigns.include?(ivar.to_s)
            assigns[ivar.to_s]
          elsif assigns.include?(ivar)
            assigns[ivar]
          else
            nil
          end
        end

        def []=(ivar, val)
          @block.call.instance_variable_set("@#{ivar}", val)
        end

        def delete(name)
          assigns.delete(name.to_s)
        end

        def each(&block)
          assigns.each &block
        end

        def has_key?(key)
          assigns.key?(key.to_s)
        end

        protected
        def assigns
          @example_group.orig_assigns
        end
      end
    end
  end
end

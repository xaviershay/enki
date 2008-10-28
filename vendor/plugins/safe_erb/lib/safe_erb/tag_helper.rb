module ActionView
  module Helpers
    module TagHelper
      def escape_once_with_untaint(html)
        escape_once_without_untaint(html).untaint
      end
      
      alias_method_chain :escape_once, :untaint
    end
  end
end

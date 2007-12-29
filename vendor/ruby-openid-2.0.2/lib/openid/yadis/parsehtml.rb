require "openid/yadis/htmltokenizer"
require 'cgi'

module OpenID
  module Yadis
    def Yadis.html_yadis_location(html)
      parser = HTMLTokenizer.new(html)

      # to keep track of whether or not we are in the head element
      in_head = false

      while el = parser.getTag('head', '/head', 'meta', 'body', '/body', 'html')

        # we are leaving head or have reached body, so we bail
        return nil if ['/head', 'body', '/body'].member?(el.tag_name)

        if el.tag_name == 'head'
          unless el.to_s[-2] == 47 # tag ends with a /: a short tag
            in_head = true
          end
        end
        next unless in_head

        return nil if el.tag_name == 'html'

        if el.tag_name == 'meta' and (equiv = el.attr_hash['http-equiv'])
          if ['x-xrds-location','x-yadis-location'].member?(equiv.downcase)
            return CGI::unescapeHTML(el.attr_hash['content'])
          end
        end
      
      end
    end
  end
end


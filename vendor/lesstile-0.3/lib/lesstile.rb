require 'cgi'
require 'uri'

class Lesstile
  VERSION = '0.3'

  class << self
    # Returns lesstile formatted text as valid XHTML
    #
    # options (all optional):
    # * <tt>text_formatter</tt>: A callback function used to format text.
    # * <tt>code_formatter</tt>: A callback function used to format code. Typically used for syntax highlighting.
    def format_as_xhtml(text, options = {})
      options = default_options.merge(options)

      text += "\n" unless ends_with?(text, "\n")
      text.gsub!(/\r\n/, "\n")
      text = CGI::escapeHTML(text)

      code_regex = /---\s*?(\w*?)\s*?\n(.*?)---\n/m
      output = ""

      while match = text.match(code_regex)
        captures = match.captures
        code = captures[1]
        lang = blank?(captures[0]) ? nil : captures[0].downcase.intern

        output += options[:text_formatter][match.pre_match] + options[:code_formatter][code, lang]
        text = match.post_match
      end
      
      output += options[:text_formatter][text.chomp]
      output
    end
  
    def default_options
      {
        :code_formatter => lambda {|code, lang| "<pre><code>#{code}</code></pre>" },
        :text_formatter => lambda {|text| 
          text = text.gsub(/\n/, "<br />\n")
          uris = URI.extract(text)

          buffer = ""
          uris.each do |uri|
            pivot = text.index(uri)
            pre = text[0..pivot-1]
            m = pre.match(/&quot;(.*)&quot;:$/)
            link = m ? m.captures.first : nil
            if link
              buffer += m.pre_match + "<a href='#{uri.to_s}'>#{link}</a>"
            else
              buffer += pre + uri
            end  
            text = text[pivot+uri.length..-1]
          end
          buffer += text
          buffer
        }
      }
    end

    private

    # From http://facets.rubyforge.org/
    # Don't add to String since we don't need them that much so why reopen the class

    def ends_with?(string, suffix)
      string.rindex(suffix) == string.size - suffix.size
    end

    def blank?(string)
      string !~ /\S/
    end
  end

  # A formatter that syntax highlights code using CodeRay
  CodeRayFormatter = lambda {|code, lang| CodeRay.scan(CGI::unescapeHTML(code), lang).html(:line_numbers => :table).div }
end

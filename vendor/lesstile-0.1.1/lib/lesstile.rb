require 'facets/string/nchar'
require 'facets/string/blank'
require 'cgi'

class Lesstile
  VERSION = '0.1.1'

  class << self
    # Returns lesstile formatted text as valid XHTML
    #
    # options (all optional):
    # * <tt>text_formatter</tt>: A callback function used to format text.
    # * <tt>code_formatter</tt>: A callback function used to format code. Typically used for syntax highlighting.
    def format_as_xhtml(text, options = {})
      options = default_options.merge(options)

      text += "\n" unless text.ends_with?("\n")
      text.gsub!(/\r\n/, "\n")
      text = CGI::escapeHTML(text)

      code_regex = /---\s*?(\w*?)\s*?\n(.*?)---\n/m
      output = ""

      while match = text.match(code_regex)
        captures = match.captures
        code = captures[1]
        lang = captures[0].blank? ? nil : captures[0].downcase.intern

        output += options[:text_formatter][match.pre_match] + options[:code_formatter][code, lang]
        text = match.post_match
      end
      
      output += options[:text_formatter][text.chomp]
      output
    end
  
    def default_options
      {
        :code_formatter => lambda {|code, lang| "<pre><code>#{code}</code></pre>" },
        :text_formatter => lambda {|text| text.gsub(/\n/, "<br />\n") }
      }
    end
  end

  # A formatter that syntax highlights code using CodeRay
  CodeRayFormatter = lambda {|code, lang| CodeRay.scan(CGI::unescapeHTML(code), lang).html(:line_numbers => :table).div }
end

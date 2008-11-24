# Paste me into spec_helper.rb, or save me somewhere else and require me in.

class BeValidXhtml
  # require 'action_controller/test_process'
  # require 'test/unit'
  require 'net/http'
  require 'md5'
  require 'ftools'
  
  def initialize(options)
    @fragment = options[:fragment]
  end
  
  # Assert that markup (html/xhtml) is valid according the W3C validator web service.
  # By default, it validates the contents of @response.body, which is set after calling
  # one of the get/post/etc helper methods. You can also pass it a string to be validated.
  # Validation errors, if any, will be included in the output. The input fragment and 
  # response from the validator service will be cached in the $RAILS_ROOT/tmp directory to 
  # minimize network calls.
  #
  # For example, if you have a FooController with an action Bar, put this in foo_controller_test.rb:
  #
  #   def test_bar_valid_markup
  #     get :bar
  #     assert_valid_markup
  #   end
  #
  MARKUP_VALIDATOR_HOST = ENV['MARKUP_VALIDATOR_HOST'] || 'validator.w3.org'
  MARKUP_VALIDATOR_PATH = ENV['MARKUP_VALIDATOR_PATH'] || '/check'
  CSS_VALIDATOR_HOST = ENV['CSS_VALIDATOR_HOST'] || 'jigsaw.w3.org'
  CSS_VALIDATOR_PATH = ENV['CSS_VALIDATOR_PATH'] || '/css-validator/validator'
  
  @@display_invalid_content = false
  cattr_accessor :display_invalid_content

  @@auto_validate = false
  cattr_accessor :auto_validate

  class_inheritable_accessor :auto_validate_excludes
  class_inheritable_accessor :auto_validate_includes
  
  
  def matches?(response)
    fn = response.rendered_template.to_s
    fragment = response.body
    fragment = wrap_with_xhtml_header(fragment) if @fragment
    return true if validity_checks_disabled?
    base_filename = cache_resource('markup',fragment,'html',fn)
    
    return false unless base_filename
    results_filename =  base_filename + '-results.yml'

    begin
      response = File.open(results_filename) do |f| Marshal.load(f) end
    rescue
      response = http.start(MARKUP_VALIDATOR_HOST).post2(MARKUP_VALIDATOR_PATH, "fragment=#{CGI.escape(fragment)}&output=xml")
      File.open(results_filename, 'w+') do |f| Marshal.dump(response, f) end
    end
    markup_is_valid = response['x-w3c-validator-status'] == 'Valid'
    @message = ''
    unless markup_is_valid
      fragment.split($/).each_with_index{|line, index| message << "#{'%04i' % (index+1)} : #{line}#{$/}"} if @@display_invalid_content
      @message << XmlSimple.xml_in(response.body)['messages'][0]['msg'].collect{ |m| "Invalid markup: line #{m['line']}: #{CGI.unescapeHTML(m['content'])}" }.join("\n")
    end
    if markup_is_valid
      return true
    else
      return false
    end
  end

  def wrap_with_xhtml_header(fragment)
    ret = <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC
    "-//W3C//DTD XHTML 1.1 plus MathML 2.0 plus SVG 1.1//EN"
    "http://www.w3.org/2002/04/xhtml-math-svg/xhtml-math-svg-flat.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
  <title>Test</title>
</head>
<body>
  #{fragment}
</body>
</html>
    EOS
  end
  
  def description
    "be valid xhtml"
  end
  
  def failure_message
   " expected xhtml to be valid, but validation produced these errors:\n #{@message}"
  end
  
  def negative_failure_message
    " expected to not be valid, but was (missing validation?)"
  end
  
  private
    def validity_checks_disabled?
      ENV["NET"] != 'true'
    end

    def text_to_multipart(key,value)
      return "Content-Disposition: form-data; name=\"#{CGI::escape(key)}\"\r\n\r\n#{value}\r\n"
    end

    def file_to_multipart(key,filename,mime_type,content)
      return "Content-Disposition: form-data; name=\"#{CGI::escape(key)}\"; filename=\"#{filename}\"\r\n" +
                "Content-Transfer-Encoding: binary\r\nContent-Type: #{mime_type}\r\n\r\n#{content}\r\n"
    end

    def cache_resource(base,resource,extension,fn)
      resource_md5 = MD5.md5(resource).to_s
      file_md5 = nil

      output_dir = "#{RAILS_ROOT}/tmp/#{base}"
      base_filename = File.join(output_dir, fn)
      filename = base_filename + extension

      parent_dir = File.dirname(filename) 
      File.makedirs(parent_dir) unless File.exists?(parent_dir)

      File.open(filename, 'r') do |f| 
        file_md5 = MD5.md5(f.read(f.stat.size)).to_s
      end if File.exists?(filename)

      if file_md5 != resource_md5
        Dir["#{base_filename}[^.]*"] .each {|f| File.delete(f)}
        File.open(filename, 'w+') do |f| f.write(resource); end
      end  
      base_filename
    end

    def http
      if Module.constants.include?("ApplicationConfig") && ApplicationConfig.respond_to?(:proxy_config)
        Net::HTTP::Proxy(ApplicationConfig.proxy_config['host'], ApplicationConfig.proxy_config['port'])
      else
        Net::HTTP
      end
    end
  
end

def be_valid_xhtml
  BeValidXhtml.new
end

def be_valid_xhtml_fragment
  BeValidXhtml.new(:fragment => true)
end

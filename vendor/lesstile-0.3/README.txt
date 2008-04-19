= lesstile
by Xavier Shay (http://rhnh.net)

== DESCRIPTION:
  
Converts text formatted with an exceedingly simple markup language into XHTML (iron clad guarantee!) - perfect for comments on your blog. Textile isn't good for this because not only does it do too much (do commenters really need subscript?), but it can also output invalid HTML (try a <b> tag over multiple lines...). Whitelisting HTML is another option, but you still need some sort of parsing if you want syntax highlighting.

Integrates with CodeRay for sexy syntax highlighting.

== SYNOPSIS:

  comment = <<-EOS
  "Ego Link":http://rhnh.net
  Wow, this post is awesome. I'd implement it like this:

  --- Ruby
  def hello_world
    puts "hello world!"
  end
  ---

  --- HTML
  <strong>Look, HTML code</strong>
  ---

  ---
  just some normal code
  ---
  EOS

  Lesstile.format_as_xhtml(comment)
  Lesstile.format_as_xhtml(comment, :code_formatter => Lesstile::CodeRayFormatter) # Requires code ray
  Lesstile.format_as_xhtml(comment, :code_formatter => lambda {|code, lang| "Code in #{lang}: #{code}" })

== REQUIREMENTS:

* CodeRay (optional)

== INSTALL (pick one):

  sudo gem install lesstile                          # gem install
  git clone git://github.com/xaviershay/lesstile.git # go from source

== LICENSE:

(The MIT License)

Copyright (c) 2007 Xavier Shay

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

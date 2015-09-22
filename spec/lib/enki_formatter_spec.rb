require 'spec_helper'

describe EnkiFormatter, '#format_as_xhtml' do
  it "should format code blocks" do
    expect(EnkiFormatter.format_as_xhtml("--- ruby\n"+
                                  "puts 'hi'\n"+
                                  "---\n")).
                                  to match(/puts.*hi/)
  end
end


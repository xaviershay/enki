require 'spec_helper'

describe EnkiFormatter, '#format_as_xhtml' do
  it "should format code blocks" do
    EnkiFormatter.format_as_xhtml("--- ruby\n"+
                                  "puts 'hi'\n"+
                                  "---\n").
                                  should match(/puts.*hi/)
  end
end


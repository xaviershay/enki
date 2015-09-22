require 'spec_helper'

describe String, '#slugorize' do
	it "should lowercase everything" do
		expect("ABCDEF".slugorize).to eq("abcdef")
	end

	it "should leave alphanumerics and hyphens alone" do
		expect("abc-123".slugorize).to eq("abc-123")
	end

	it "should ditch entities" do
		expect("abc&lt;-&#60;xyz".slugorize).to eq("abc-xyz")
	end

	it "should replace & with and" do
		expect("a-&-b-&-c".slugorize).to eq("a-and-b-and-c")
	end

	it "should strip all non-alphanumeric characters except - and &" do
		expect('abc""!@#$%^*()/=+|\[],.<>123'.slugorize).to eq("abc-123")
	end

  it "should allow apostrophes for good punctuation" do
    expect("tomato's".slugorize).to eq("tomato's")
  end

	it "should replace all whitespace with a dash" do
		expect("abc\n\t     xyz".slugorize).to eq("abc-xyz")
	end

	it "should trim dashes at the tail" do
		expect("abc--".slugorize).to eq("abc")
	end

	it "should trim dashes at the head" do
		expect("--abc".slugorize).to eq("abc")
	end

	it "should collapse multiple dashes" do
		expect("abc---xyz".slugorize).to eq("abc-xyz")
	end
end


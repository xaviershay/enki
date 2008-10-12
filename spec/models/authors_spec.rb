require File.dirname(__FILE__) + '/../spec_helper'

describe Author, 'validations' do
  def valid_author_attributes
    {
      :name    => "Don Alias",
      :email   => "don@enkiblog.com",
      :open_id => "http://enkiblog.com"
    }
  end

  it 'is valid with valid_author_attributes' do
    Author.new(valid_author_attributes).should be_valid
  end

  it 'is invalid with no name' do
    Author.new(valid_author_attributes.merge(:name => '')).should_not be_valid
  end

  it 'is invalid with no email' do
    Author.new(valid_author_attributes.merge(:email => '')).should_not be_valid
  end

  it 'is invalid with no open_id' do
    Author.new(valid_author_attributes.merge(:open_id => nil)).should_not be_valid
  end
  it 'is invalid with a blank open_id' do
    Author.new(valid_author_attributes.merge(:open_id => '')).should_not be_valid
  end
  it 'is invalid without a HTTP or HTTPS open_id' do
    Author.new(valid_author_attributes.merge(:open_id => 'something.com')).should_not be_valid
    Author.new(valid_author_attributes.merge(:open_id => 'ftp://something.com')).should_not be_valid
  end
end

describe 'Author', 'open_id' do
  before(:each) do
    @author = Author.new
  end
  it 'can be set with a URI string representation' do
    @author.open_id = "http://enkiblog.com"
    @author.open_id.should eql(URI.parse("http://enkiblog.com"))
  end
  it 'can be set with a URI' do
    @author.open_id = URI.parse("http://enkiblog.com")
    @author.open_id.should eql(URI.parse("http://enkiblog.com"))
  end
end

describe 'Author', 'with_open_id' do
  before(:each) do
    @author = Author.create! :name => "Don Alias",
                             :email  => "don@enkiblog.com",
                             :open_id  => "http://enkiblog.com"
    
  end
  it "should return the author with matching open_id" do
    Author.with_open_id("http://enkiblog.com").should eql(@author)
  end
  it "should return nil if there's no author with matching open_id" do
    Author.with_open_id("http://somesite.com").should be_nil
  end
end

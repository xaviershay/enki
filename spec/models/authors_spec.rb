require File.dirname(__FILE__) + '/../spec_helper'

describe Author, 'validations' do
  def valid_author_attributes
    {
      :name => "Don Alias",
      :email  => "don@enkiblog.com",
      :open_id  => "http://enkiblog.com"
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
    Author.new(valid_author_attributes.merge(:open_id => '')).should_not be_valid
  end
end

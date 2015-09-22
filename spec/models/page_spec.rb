require File.dirname(__FILE__) + '/../spec_helper'

describe Page, '#generate_slug' do
  it 'makes a slug from the title if slug if blank' do
    page = Page.new(:slug => '', :title => 'my title')
    page.generate_slug
    expect(page.slug).to eq('my-title')
  end

  it 'replaces & with and' do
    page = Page.new(:slug => 'a & b & c')
    page.generate_slug
    expect(page.slug).to eq('a-and-b-and-c')
  end

  it 'replaces non alphanumeric characters with -' do
    page = Page.new(:slug => 'a@#^*(){}b')
    page.generate_slug
    expect(page.slug).to eq('a-b')
  end

  it 'does not modify title' do
    page = Page.new(:title => 'My Page')
    page.generate_slug
    expect(page.title).to eq('My Page')
  end
end

describe Page, 'before validation' do
  it 'calls #generate_slug' do
    page = Page.new(:title => "My Page", :body => "body")
    page.valid?
    expect(page.slug).not_to be_blank
  end
end

describe Page, 'validations' do
  def valid_page_attributes
    {
      :title                => "My Page",
      :slug                 => "my-page",
      :body                 => "body"
    }
  end

  it 'is valid with valid_page_attributes' do
    expect(Page.new(valid_page_attributes)).to be_valid
  end

  it 'is invalid with no title' do
    expect(Page.new(valid_page_attributes.merge(:title => ''))).not_to be_valid
  end

  it 'is invalid with no body' do
    expect(Page.new(valid_page_attributes.merge(:body => ''))).not_to be_valid
  end
end

describe Page, '.build_for_preview' do
  before(:each) do
    @page = Page.build_for_preview(:title => 'My Page', :body => "body")
  end

  it 'returns a new page' do
    expect(@page).to be_new_record
  end

  it 'applies filter to body' do
    expect(@page.body_html).to eq('<p>body</p>')
  end
end

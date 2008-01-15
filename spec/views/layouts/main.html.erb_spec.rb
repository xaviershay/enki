require File.dirname(__FILE__) + '/../../spec_helper'

describe "/layouts/main.html.erb" do
  before(:each) do
    mock_tag = mock_model(Tag,
      :name     => 'code',
      :taggings => [mock_model(Tagging)]
    )
    Tag.stub!(:find).and_return([mock_tag])
  end

  it 'renders' do
    render '/layouts/main.html.erb'
  end
end

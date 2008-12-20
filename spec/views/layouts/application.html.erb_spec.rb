require File.dirname(__FILE__) + '/../../spec_helper'

describe "/layouts/application.html.erb" do
  before(:each) do
    mock_tag = mock_model(Tag,
      :name     => 'code'.taint,
      :taggings => [mock_model(Tagging)]
    )
    Tag.stub!(:find).and_return([mock_tag])

    mock_page = mock_model(Page,
      :title     => 'about'.taint,
      :slug     => 'about'.taint
    )
    Page.stub!(:find).and_return([mock_page])
  end

  it 'renders' do
    render '/layouts/application.html.erb'
  end
end

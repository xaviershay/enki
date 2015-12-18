require File.dirname(__FILE__) + '/../../spec_helper'

describe "/layouts/application.html" do
  before(:each) do
    allow(view).to receive(:enki_config).and_return(Enki::Config.default)

    mock_tag = mock_model(ActsAsTaggableOn::Tag,
      :name     => 'code',
      :taggings => [mock_model(ActsAsTaggableOn::Tagging)]
    )
    allow(ActsAsTaggableOn::Tag).to receive(:find).and_return([mock_tag])

    mock_page = mock_model(Page,
      :title     => 'about',
      :slug     => 'about'
    )
    allow(Page).to receive(:find).and_return([mock_page])
  end

  it 'renders' do
    render :template => '/layouts/application', :formats => [:html]
  end
end

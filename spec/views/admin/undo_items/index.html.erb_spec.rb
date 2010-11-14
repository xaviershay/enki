require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/undo_items/index.html.erb" do
  after(:each) do
    rendered.should be_valid_html5_fragment
  end

  it 'should render' do
    assign :undo_items, [mock_model(UndoItem,
      :created_at  => Time.now,
      :description => 'Deleted a comment'
    )]
    render :template => '/admin/undo_items/index.html.erb'
  end
end

require File.dirname(__FILE__) + '/../../spec_helper'

describe "/layouts/admin.html.erb" do
  it 'renders' do
    render '/layouts/admin.html.erb'
  end
end

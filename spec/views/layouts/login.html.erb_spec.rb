require File.dirname(__FILE__) + '/../../spec_helper'

describe "/layouts/login.html.erb" do
  it 'renders' do
    render '/layouts/login.html.erb'
  end
end

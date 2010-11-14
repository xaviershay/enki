require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/sessions/new.html.erb" do
  after(:each) do
    rendered.should be_valid_html5_fragment
  end

  it "renders" do
    view.stub!(:enki_config).and_return(Enki::Config.default)
    view.stub!(:allow_login_bypass?).and_return(true)
    render :template => '/admin/sessions/new.html.erb'
  end
end

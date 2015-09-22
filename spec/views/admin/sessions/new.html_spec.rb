require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/sessions/new.html" do
  after(:each) do
    expect(rendered).to be_valid_html5_fragment
  end

  it "renders" do
    allow(view).to receive(:enki_config).and_return(Enki::Config.default)
    allow(view).to receive(:allow_login_bypass?).and_return(true)
    allow(view).to receive(:auth_path).and_return('/auth/omniauth_path')
    render :template => '/admin/sessions/new', :formats => [:html]
  end
end

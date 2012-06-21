require File.dirname(__FILE__) + '/../../spec_helper'

describe "/layouts/login.html" do
  it 'renders' do
    view.stub!(:enki_config).and_return(Enki::Config.default)
    render :template => '/layouts/login', :formats => [:html]
  end
end

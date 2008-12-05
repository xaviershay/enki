require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SessionsController do
  describe 'handling GET to show (default)' do
    it 'redirects to new' do
      get :show
      response.should be_redirect
      response.should redirect_to(new_admin_session_path)
    end
  end

  describe 'handling GET to new' do
    before(:each) do
      get :new
    end

    it "should be successful" do
      response.should be_success
    end

    it "should render index template" do
      response.should render_template('new')
    end
  end

  describe 'handling DELETE to destroy' do
    before(:each) do
      delete :destroy
    end

    it 'logs out the current session' do
      session[:logged_in].should == false
    end

    it 'redirects to /' do
      response.should be_redirect
      response.should redirect_to('/')
    end
  end

  describe '#allow_login_bypass? when RAILS_ENV == production' do
    it 'returns false' do
      silence_warnings { RAILS_ENV = 'production' }
      @controller.send(:allow_login_bypass?).should == false
    end

    after do
      silence_warnings { RAILS_ENV = 'test' }
    end
  end
end

describe "logged in and redirected to /admin", :shared => true do
  it "should set session[:logged_in]" do
    session[:logged_in].should be_true
  end
  it "should redirect to admin posts" do
    response.should be_redirect
    response.should redirect_to('/admin/dashboard')
  end
end
describe "not logged in", :shared => true do
  it "should not set session[:logged_in]" do
    session[:logged_in].should be_nil
  end
  it "should render new" do
    response.should be_success
    response.should render_template("new")
  end
  it "should set flash.now[:error]" do
    flash.now[:error].should_not be_nil
  end
end

describe Admin::SessionsController, "handling CREATE with post" do
  before do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
  end

  def stub_open_id_authenticate(url, status_code, return_value)
    status = mock("Result", :successful? => status_code == :successful, :message => '')
    @controller.stub!(:config).and_return(mock("config", :author_open_ids => [
        "http://enkiblog.com",
        "http://secondaryopenid.com"
      ].collect {|uri| URI.parse(uri)}
    ))
    @controller.should_receive(:authenticate_with_open_id).with(url).and_yield(status,url).and_return(return_value)
  end
  describe "with invalid URL http://evilman.com and OpenID authentication succeeding" do
    before do
      stub_open_id_authenticate("http://evilman.com", :successful, false)
      post :create, :openid_url => "http://evilman.com"
    end
    it_should_behave_like "not logged in"
  end
  describe "with valid URL http://enkiblog.com and OpenID authentication succeeding" do
    before do
      stub_open_id_authenticate("http://enkiblog.com", :successful, false)
      post :create, :openid_url => "http://enkiblog.com"
    end
    it_should_behave_like "logged in and redirected to /admin"
  end
  describe "with valid secondary URL http://secondaryopenid.com and OpenID authentication succeeding" do
    before do
      stub_open_id_authenticate("http://secondaryopenid.com", :successful, false)
      post :create, :openid_url => "http://secondaryopenid.com"
    end
    it_should_behave_like "logged in and redirected to /admin"
  end
  describe "with valid URL http://enkiblog.com and OpenID authentication returning 'failed'" do
    before do
      stub_open_id_authenticate("http://enkiblog.com", :failed, true)
      post :create, :openid_url => "http://enkiblog.com"
    end
    it_should_behave_like "not logged in"
  end
  describe "with valid URL http://enkiblog.com and OpenID authentication returning 'missing'" do
    before do
      stub_open_id_authenticate("http://enkiblog.com", :missing, true)
      post :create, :openid_url => "http://enkiblog.com"
    end
    it_should_behave_like "not logged in"
  end
  describe "with valid URL http://enkiblog.com and OpenID authentication returning 'canceled'" do
    before do
      stub_open_id_authenticate("http://enkiblog.com", :canceled, true)
      post :create, :openid_url => "http://enkiblog.com"
    end
    it_should_behave_like "not logged in"
  end
  describe "with no URL" do
    before do
      post :create, :openid_url => ""
    end
    it_should_behave_like "not logged in"
  end
  describe "with bypass login selected" do
    before do
      post :create, :openid_url => "", :bypass_login => "1"
    end
    it_should_behave_like "logged in and redirected to /admin"
  end
  describe "with bypass login selected but login bypassing disabled" do
    before do
      @controller.stub!(:allow_login_bypass?).and_return(false)
      post :create, :openid_url => "", :bypass_login => "1"
    end
    it_should_behave_like "not logged in"
  end
end

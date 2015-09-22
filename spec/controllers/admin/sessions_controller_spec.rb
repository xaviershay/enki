require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SessionsController do
  describe 'handling GET to show (default)' do
    it 'redirects to new' do
      get :show
      expect(response).to be_redirect
      expect(response).to redirect_to(new_admin_session_path)
    end
  end

  describe 'handling GET to new' do
    before(:each) do
      get :new
    end

    it "should be successful" do
      expect(response).to be_success
    end

    it "should render index template" do
      expect(response).to render_template('new')
    end
  end

  describe 'handling DELETE to destroy' do
    before(:each) do
      delete :destroy
    end

    it 'logs out the current session' do
      expect(session[:logged_in]).to eq(false)
    end

    it 'redirects to /' do
      expect(response).to be_redirect
      expect(response).to redirect_to('/')
    end
  end

  describe '#allow_login_bypass? when RAILS_ENV == production' do
    it 'returns false' do
      allow(::Rails).to receive(:env).and_return('production')
      expect(@controller.send(:allow_login_bypass?)).to eq(false)
    end
  end
end

shared_examples_for "logged in and redirected to /admin" do
  it "should set session[:logged_in]" do
    expect(session[:logged_in]).to be_truthy
  end
  it "should redirect to admin posts" do
    expect(response).to be_redirect
    expect(response).to redirect_to('/admin')
  end
end
shared_examples_for "not logged in" do
  it "should not set session[:logged_in]" do
    expect(session[:logged_in]).to be_nil
  end
  it "should render new" do
    expect(response).to be_success
    expect(response).to render_template("new")
  end
  it "should set flash.now[:error]" do
    expect(flash.now[:error]).not_to be_nil
  end
end

describe Admin::SessionsController, "handling CREATE with post" do
  before do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
  end
  def stub_auth_response(auth_response)
    request.env["omniauth.auth"] = auth_response
  end
  def stub_enki_config
    allow(@controller).to receive(:enki_config).and_return(double("enki_config", :author_open_ids => [
        "http://enkiblog.com",
        "http://secondaryopenid.com"
      ].collect {|uri| URI.parse(uri)},
      :author_google_oauth2_email => "you@your-openid-connect-domain.com"
    ))
  end
  describe "with invalid URL http://evilman.com and OpenID authentication succeeding" do
    before do
      stub_enki_config
      stub_auth_response({ :provider => ApplicationController::OMNIAUTH_OPEN_ID_ADMIN_STRATEGY,
                           :uid => "http://evilman.com" })

      post :create
    end
    it_should_behave_like "not logged in"
  end
  describe "with valid URL http://enkiblog.com and OpenID authentication succeeding" do
    before do
      stub_enki_config
      stub_auth_response({ :provider => ApplicationController::OMNIAUTH_OPEN_ID_ADMIN_STRATEGY,
                            :uid => "http://enkiblog.com" })

      post :create
    end
    it_should_behave_like "logged in and redirected to /admin"
  end
  describe "with valid secondary URL http://secondaryopenid.com and OpenID authentication succeeding" do
    before do
      stub_enki_config
      stub_auth_response({ :provider => ApplicationController::OMNIAUTH_OPEN_ID_ADMIN_STRATEGY,
                            :uid => "http://secondaryopenid.com" })

      post :create
    end
    it_should_behave_like "logged in and redirected to /admin"
  end
  describe "with invalid email notyou@someotherdomain.com and Google OpenID Connect authentication succeeding" do
    before do
      stub_enki_config
      stub_auth_response({ :provider => ApplicationController::OMNIAUTH_GOOGLE_OAUTH2_STRATEGY,
                           :info => { :email => "notyou@someotherdomain.com" } })

      post :create
    end
    it_should_behave_like "not logged in"
  end
  describe "with valid email you@your-openid-connect-domain.com and Google OpenID Connect authentication succeeding" do
    before do
      stub_enki_config
      stub_auth_response({ :provider => ApplicationController::OMNIAUTH_GOOGLE_OAUTH2_STRATEGY,
                           :info => { :email => "you@your-openid-connect-domain.com" } })

      post :create
    end
    it_should_behave_like "logged in and redirected to /admin"
  end
  describe "with bypass login selected" do
    before do
      post :create, :bypass_login => "1"
    end
    it_should_behave_like "logged in and redirected to /admin"
  end
  describe "with bypass login selected but login bypassing disabled" do
    before do
      allow(@controller).to receive(:allow_login_bypass?).and_return(false)
      post :create, :bypass_login => "1"
    end
    it_should_behave_like "not logged in"
  end
end

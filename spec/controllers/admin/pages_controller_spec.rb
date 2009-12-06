require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::PagesController do
  describe 'handling GET to index' do
    before(:each) do
      @pages = [mock_model(Page), mock_model(Page)]
      Page.stub!(:paginate).and_return(@pages)
      session[:logged_in] = true
      get :index
    end

    it "is successful" do
      response.should be_success
    end

    it "renders index template" do
      response.should render_template('index')
    end

    it "finds pages for the view" do
      assigns[:pages].should == @pages
    end
  end

  describe 'handling GET to show' do
    before(:each) do
      @page = mock_model(Page)
      Page.stub!(:find).and_return(@page)
      session[:logged_in] = true
      get :show, :id => 1
    end

    it "is successful" do
      response.should be_success
    end

    it "renders show template" do
      response.should render_template('show')
    end

    it "finds page for the view" do
      assigns[:page].should == @page
    end
  end

  describe 'handling GET to new' do
    before(:each) do
      @page = mock_model(Page)
      Page.stub!(:new).and_return(@page)
      session[:logged_in] = true
      get :new
    end

    it('is successful') { response.should be_success}
    it('assigns page for the view') { assigns[:page] == @page }
  end

  describe 'handling PUT to update with valid attributes' do
    before(:each) do
      @page = mock_model(Page, :title => 'A page')
      @page.stub!(:update_attributes).and_return(true)
      Page.stub!(:find).and_return(@page)
    end

    def do_put
      session[:logged_in] = true
      put :update, :id => 1, :page => {
        'title' => 'My Post',
        'slug'  => 'my-post',
        'body'  => 'This is my post'
      }
    end

    it 'updates the page' do
      @page.should_receive(:update_attributes).with(
        'title' => 'My Post',
        'slug'  => 'my-post',
        'body'  => 'This is my post'
      )

      do_put
    end

    it 'it redirects to show' do
      do_put
      response.should be_redirect
      response.should redirect_to(admin_page_path(@page))
    end
  end

  describe 'handling PUT to update with invalid attributes' do
    before(:each) do
      @page = mock_model(Page)
      @page.stub!(:update_attributes).and_return(false)
      Page.stub!(:find).and_return(@page)
    end

    def do_put
      session[:logged_in] = true
      put :update, :id => 1, :page => {}
    end

    it 'renders show' do
      do_put
      response.should render_template('show')
    end

    it 'is unprocessable' do
      do_put
      response.status.should == '422 Unprocessable Entity'
    end
  end
end

describe Admin::PagesController, 'with an AJAX request to preview' do
  before(:each) do
    Page.should_receive(:build_for_preview).and_return(@page = mock_model(Page))
    controller.should_receive(:render).with(:partial => 'pages/page.html.erb')
    session[:logged_in] = true
    xhr :post, :preview, :page => {
      :title        => 'My Page',
      :body         => 'body'
    }
  end

  it "assigns a new page for the view" do
    assigns(:page).should == @page
  end
end

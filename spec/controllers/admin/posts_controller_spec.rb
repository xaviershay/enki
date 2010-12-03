require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::PostsController do
  describe 'handling GET to index' do
    before(:each) do
      @posts = [mock_model(Post), mock_model(Post)]
      Post.stub!(:paginate).and_return(@posts)
      session[:logged_in] = true
      get :index
    end

    it "is successful" do
      response.should be_success
    end

    it "renders index template" do
      response.should render_template('index')
    end

    it "finds posts for the view" do
      assigns[:posts].should == @posts
    end
  end

  describe 'handling GET to show' do
    before(:each) do
      @post = mock_model(Post)
      Post.stub!(:find).and_return(@post)
      session[:logged_in] = true
      get :show, :id => 1
    end

    it "is successful" do
      response.should be_success
    end

    it "renders show template" do
      response.should render_template('show')
    end

    it "finds post for the view" do
      assigns[:post].should == @post
    end
  end

  describe 'handling GET to new' do
    before(:each) do
      @post = mock_model(Post)
      Post.stub!(:new).and_return(@post)
      session[:logged_in] = true
      get :new
    end

    it('is successful') { response.should be_success}
    it('assigns post for the view') { assigns[:post] == @post }
  end

  describe 'handling PUT to update with valid attributes' do
    before(:each) do
      @post = mock_model(Post, :title => 'A post')
      @post.stub!(:update_attributes).and_return(true)
      Post.stub!(:find).and_return(@post)
    end

    def do_put
      session[:logged_in] = true
      put :update, :id => 1, :post => valid_post_attributes
    end

    it 'updates the post' do
      published_at = Time.now
      @post.should_receive(:update_attributes).with(valid_post_attributes)

      Time.stub!(:now).and_return(published_at)
      do_put
    end

    it 'it redirects to show' do
      do_put
      response.should be_redirect
      response.should redirect_to(admin_post_path(@post))
    end
  end

  describe 'handling PUT to update with invalid attributes' do
    before(:each) do
      @post = mock_model(Post)
      @post.stub!(:update_attributes).and_return(false)
      Post.stub!(:find).and_return(@post)
    end

    def do_put
      session[:logged_in] = true
      put :update, :id => 1, :post => {}
    end

    it 'renders show' do
      do_put
      response.should render_template('show')
    end

    it 'is unprocessable' do
      do_put
      response.status.should == 422
    end
  end

  describe 'handling POST to create with valid attributes' do
    it 'creates a post' do
      session[:logged_in] = true
      lambda { post :create, :post => valid_post_attributes }.should change(Post, :count).by(1)
    end
  end

  def valid_post_attributes
    {
      'title'      => "My Post",
      'body'       => "hello this is my post",
      'minor_edit' => "0"
    }
  end

  describe 'handling DELETE to destroy' do
    before(:each) do
      @post = Post.new
      @post.stub!(:destroy_with_undo)
      Post.stub!(:find).and_return(@post)
    end

    def do_delete
      session[:logged_in] = true
      delete :destroy, :id => 1
    end

    it("redirects to index") do
      do_delete
      response.should be_redirect
      response.should redirect_to(admin_posts_path)
    end

    it("deletes post") do
      @post.should_receive(:destroy_with_undo)
      do_delete
    end
  end

  describe 'handling DELETE to destroy, JSON request' do
    before(:each) do
      @post = Post.new(:title => 'A post')
      @post.stub!(:destroy_with_undo).and_return(mock("undo_item", :description => 'hello'))
      Post.stub!(:find).and_return(@post)
    end

    def do_delete
      session[:logged_in] = true
      delete :destroy, :id => 1, :format => 'json'
    end

    it("deletes post") do
      @post.should_receive(:destroy_with_undo).and_return(mock("undo_item", :description => 'hello'))
      do_delete
    end

    it("renders json including a description of the post") do
      do_delete
      JSON.parse(response.body)['undo_message'].should == 'hello'
    end
  end
end

describe Admin::PostsController, 'with an AJAX request to preview' do
  before(:each) do
    Post.should_receive(:build_for_preview).and_return(@post = mock_model(Post))
    session[:logged_in] = true
    xhr :post, :preview, :post => {
      :title        => 'My Post',
      :body         => 'body',
      :tag_list     => 'ruby',
      :published_at => 'now'
    }
  end

  it "assigns a new post for the view" do
    assigns(:post).should == @post
  end
end

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

  describe 'handling GET to index, YAML request' do
    before(:each) do
      @posts = [mock_model(Post), mock_model(Post)]
      @posts.each {|post| post.stub!(:to_serializable) }
      Post.stub!(:find).and_return(@posts)
      session[:logged_in] = true
      get :index, :format => 'yaml'
    end

    it "is successful" do
      pending("Works IRL, test gets 406")
      response.should be_success
    end

    it "finds posts with out pagination" do
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
  
  describe 'handling GET to show, YAML format' do
    before(:each) do
      @post = mock_model(Post)
      Post.stub!(:find).and_return(@post)
      session[:logged_in] = true
      get :show, :id => 1, :format => 'yaml'
    end

    it "is successful" do
      pending("Works IRL, test gets 406")
      response.should be_success
    end
  end

  describe 'handling PUT to update with valid attributes' do
    before(:each) do
      @post = mock_model(Post)
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

    it 'it redirects to edit' do
      do_put
      response.should be_redirect
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

    it 'renders edit' do
      do_put
      response.should render_template('edit')
    end

    it 'is unprocessable' do
      do_put
      response.headers['Status'].should == '422 Unprocessable Entity'
    end
  end

  describe 'handling PUT to update with valid attributes, YAML request' do
    before(:each) do
      @post = mock_model(Post)
      @post.stub!(:update_attributes).and_return(true)
      Post.stub!(:find).and_return(@post)
    end

    def do_put
      request.env['RAW_POST_DATA'] = {'post' => valid_post_attributes}.to_yaml
      request.headers['HTTP_X_ENKIHASH'] = hash_request(request)
      put :update, :id => 1, :format => 'yaml'
    end

    it 'updates the post' do
      @post.should_receive(:update_attributes).with(valid_post_attributes)
      do_put
    end
    
    it 'is successful' do
      do_put
      response.should be_success
    end
  end

  describe 'handling PUT to update with invalid attributes, YAML request' do
    before(:each) do
      @post = mock_model(Post)
      @post.stub!(:update_attributes).and_return(false)
      Post.stub!(:find).and_return(@post)
    end

    def do_put
      request.env['RAW_POST_DATA'] = {}.to_yaml
      request.headers['HTTP_X_ENKIHASH'] = hash_request(request)
      put :update, :id => 1, :format => 'yaml'
    end

    it 'is unprocessable' do
      do_put
      response.headers['Status'].should == '422 Unprocessable Entity'
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
      'title' => "My Post",
      'body' => "hello this is my post"
    }
  end
end

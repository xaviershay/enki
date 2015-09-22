require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/../../factories'

describe Admin::PostsController do
  describe 'handling GET to index' do
    before(:each) do
      FactoryGirl.create_list(:post, 2)
      session[:logged_in] = true
      get :index
    end

    it "is successful" do
      expect(response).to be_success
    end

    it "renders index template" do
      expect(response).to render_template('index')
    end

    it "finds posts for the view" do
      expect(assigns[:posts].size).to be 2
      expect(assigns[:posts][0]).to be_a_kind_of(Post)
      expect(assigns[:posts][1]).to be_a_kind_of(Post)
    end
  end

  describe 'handling GET to show' do
    before(:each) do
      @post = mock_model(Post)
      allow(Post).to receive(:find).and_return(@post)
      session[:logged_in] = true
      get :show, :id => 1
    end

    it "is successful" do
      expect(response).to be_success
    end

    it "renders show template" do
      expect(response).to render_template('show')
    end

    it "finds post for the view" do
      expect(assigns[:post]).to eq(@post)
    end
  end

  describe 'handling GET to new' do
    before(:each) do
      @post = mock_model(Post)
      allow(Post).to receive(:new).and_return(@post)
      session[:logged_in] = true
      get :new
    end

    it('is successful') { expect(response).to be_success}
    it('assigns post for the view') { assigns[:post] == @post }
  end

  describe 'handling PUT to update with valid attributes' do
    before(:each) do
      @post = mock_model(Post, :title => 'A post')
      allow(@post).to receive(:update_attributes).and_return(true)
      allow(Post).to receive(:find).and_return(@post)
    end

    def do_put
      session[:logged_in] = true
      put :update, :id => 1, :post => valid_post_attributes
    end

    it 'updates the post' do
      published_at = Time.now
      expect(@post).to receive(:update_attributes).with(valid_post_attributes)

      allow(Time).to receive(:now).and_return(published_at)
      do_put
    end

    it 'it redirects to show' do
      do_put
      expect(response).to be_redirect
      expect(response).to redirect_to(admin_post_path(@post))
    end
  end

  describe 'handling PUT to update with invalid attributes' do
    before(:each) do
      @post = mock_model(Post)
      allow(@post).to receive(:update_attributes).and_return(false)
      allow(Post).to receive(:find).and_return(@post)
    end

    def do_put
      session[:logged_in] = true
      put :update, :id => 1, :post => valid_post_attributes
    end

    it 'renders show' do
      do_put
      expect(response).to render_template('show')
    end

    it 'is unprocessable' do
      do_put
      expect(response.status).to eq(422)
    end
  end

  describe 'handling PUT to update with expected whitelisted attributes present' do
    before(:each) do
      @post = FactoryGirl.create(:post)
      allow(Post).to receive(:find).and_return(@post)
    end

    it 'allows whitelisted attributes as expected' do
      session[:logged_in] = true
      put :update, :id => 1, :post => {
        'title'                => "My Updated Post",
        'body'                 => "hello this is my updated post",
        'tag_list'             => "red, green, blue, magenta",
        'published_at_natural' => "1 hour from now",
        'slug'                 => "my-manually-entered-updated-post-slug",
        'minor_edit'           => "1"
      }

      expect(assigns(:post).title).to eq("My Updated Post")
      expect(assigns(:post).body).to eq("hello this is my updated post")
      expect(assigns(:post).tag_list).to eq(["red", "green", "blue", "magenta"])
      expect(assigns(:post).published_at_natural).to eq("1 hour from now")
      expect(assigns(:post).slug).to eq("my-manually-entered-updated-post-slug")
      expect(assigns(:post).minor_edit).to eq("1")
    end
  end

  describe 'handling POST to create with valid attributes' do
    it 'creates a post' do
      session[:logged_in] = true
      expect { post :create, :post => valid_post_attributes }.to change(Post, :count).by(1)
    end
  end

  describe 'handling POST to create with expected whitelisted attributes present' do
    it 'allows whitelisted attributes as expected' do
      session[:logged_in] = true
      put :create, :id => 1, :post => {
        'title'                => "My Awesome New Post",
        'body'                 => "hello this is my awesome new post",
        'tag_list'             => "teal, azure, turquoise",
        'published_at_natural' => "now",
        'slug'                 => "my-manually-entered-slug",
        'minor_edit'           => "0"
      }

      expect(assigns(:post).title).to eq("My Awesome New Post")
      expect(assigns(:post).body).to eq("hello this is my awesome new post")
      expect(assigns(:post).tag_list).to eq(["teal", "azure", "turquoise"])
      expect(assigns(:post).published_at_natural).to eq("now")
      expect(assigns(:post).slug).to eq("my-manually-entered-slug")
      expect(assigns(:post).minor_edit).to eq("0")
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
      allow(@post).to receive(:destroy_with_undo)
      allow(Post).to receive(:find).and_return(@post)
    end

    def do_delete
      session[:logged_in] = true
      delete :destroy, :id => 1
    end

    it("redirects to index") do
      do_delete
      expect(response).to be_redirect
      expect(response).to redirect_to(admin_posts_path)
    end

    it("deletes post") do
      expect(@post).to receive(:destroy_with_undo)
      do_delete
    end
  end

  describe 'handling DELETE to destroy, JSON request' do
    before(:each) do
      @post = Post.new(:title => 'A post')
      allow(@post).to receive(:destroy_with_undo).and_return(mock_model(UndoItem, :description => 'hello'))
      allow(Post).to receive(:find).and_return(@post)
    end

    def do_delete
      session[:logged_in] = true
      delete :destroy, :id => 1, :format => 'json'
    end

    it("deletes post") do
      expect(@post).to receive(:destroy_with_undo).and_return(mock_model(UndoItem, :description => 'hello'))
      do_delete
    end

    it("renders json including a description of the post") do
      do_delete
      expect(JSON.parse(response.body)['undo_message']).to eq('hello')
    end
  end
end

describe Admin::PostsController, 'with an AJAX request to preview' do
  before(:each) do
    session[:logged_in] = true
    xhr :post, :preview, :post => {
      :title                => 'My Post',
      :body                 => 'body',
      :tag_list             => 'ruby',
      :published_at_natural => 'now'
    }
  end

  it "assigns a new post for the view" do
    expect(assigns(:post).title).to eq('My Post')
    expect(assigns(:post).body).to eq('body')
    expect(assigns(:post).tag_list).to eq(['ruby'])
    expect(assigns(:post).published_at_natural).to eq('now')
  end
end

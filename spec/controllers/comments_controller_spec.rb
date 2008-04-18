require File.dirname(__FILE__) + '/../spec_helper'

describe CommentsController, 'with an atom GET to #index' do
  before(:each) do
    @mock_post = mock_model(Post)
    @mock_post.stub!(:approved_comments).and_return(@mock_comments = [mock_model(Comment)])
    Post.stub!(:find_by_permalink).and_return(@mock_post)

    get :index, :year => '2007', :month => '01', :day => '01', :slug => 'a-post', :format => 'atom'
  end
  
  it 'assigns a post' do
    assigns(:post).should_not be_nil
  end

  it 'assigns comments' do
    assigns(:comments).should == @mock_comments
  end
  
  it 'render the index template' do
    response.should render_template('comments/index')
  end
end

describe 'creating new comment', :shared => true do
  it 'assigns comment' do
    assigns(:comment).should_not be_nil
  end

  it 'creates a new comment on the post' do
    assigns(:comment).should_not be_new_record
  end

  it 'redirects to post' do
    response.should be_redirect
    response.should redirect_to(post_path(@mock_post))
  end
end

describe "invalid comment", :shared => true do
  it 'renders posts/show' do
    response.should be_success
    response.should render_template('posts/show')
  end

  it 'leaves comment in invalid state' do
    assigns(:comment).should_not be_valid
  end
end

describe CommentsController, 'handling commenting' do
  def mock_post!
    @mock_post = mock_model(Post)
    {
      :approved_comments           => @mock_comments = [mock_model(Comment)],
      :new_record?                 => false,
      :published_at                => 1.year.ago,
      :created_at                  => 1.year.ago,
      :denormalize_comments_count! => nil,
      :slug                        => 'a-post',
      :day                         => '01'
    }.each_pair do |attribute, value|
      @mock_post.stub!(attribute).and_return(value)
    end
    Post.stub!(:find_by_permalink).and_return(@mock_post)
    @mock_post
  end

  def stub_open_id_authenticate(url, status_code, return_value)
    status = mock("Status", :code => status_code, :server_url => 'http://example.com')
    registration = {
      "fullname" => "Don Alias",
      "email" => "donalias@enkiblog.com"
    }
    @controller.stub!(:authenticate_with_open_id).and_yield(status,url, registration).and_return(return_value)
  end

  describe 'with a POST to #index requiring OpenID authentication' do
    before do
      mock_post!

      @comment = {
        'author' => 'http://enkiblog.com',
        'body'   => 'This is a comment'
      }

      @controller.stub!(:authenticate_with_open_id).and_return(true)
    end
    
    def do_post
      post :index, :year => '2007', :month => '01', :day => '01', :slug => 'a-post', :comment => @comment
    end

    it 'stores a pending comment' do
      do_post
      session[:pending_comment].should == @comment
    end

    it 'redirects to OpenID authority' do
      @controller.should_receive(:authenticate_with_open_id).and_return(true)
      do_post
    end
  end

  describe 'with a POST to #index requiring OpenID authentication but unavailable server' do
    before do
      mock_post!

      stub_open_id_authenticate('http://enkiblog.com', :missing, false)
      post :index, :year => '2007', :month => '01', :day => '01', :slug => 'a-post', :comment => {
        'author' => 'http://enkiblog.com',
        'body'   => 'This is a comment'
      }
    end

    it_should_behave_like("invalid comment")

    it 'sets an appropriate error message on the comment' do
      assigns(:comment).openid_error.should == "Sorry, the OpenID server couldn't be found"
    end
  end

  describe CommentsController, 'with a canceled OpenID completion GET to #index' do
    before do
      mock_post!

      stub_open_id_authenticate('http://enkiblog.com', :canceled, false)
      post :index, :year => '2007', :month => '01', :day => '01', :slug => 'a-post', :comment => {
        'author' => 'http://enkiblog.com',
        'body'   => 'This is a comment'
      }
    end

    it_should_behave_like("invalid comment")

    it 'sets an appropriate error message on the comment' do
      assigns(:comment).openid_error.should == "OpenID verification was canceled"
    end
  end

  describe CommentsController, 'with a failed OpenID completion GET to #index' do
    before do
      mock_post!

      stub_open_id_authenticate('http://enkiblog.com', :failed, false)
      post :index, :year => '2007', :month => '01', :day => '01', :slug => 'a-post', :comment => {
        'author' => 'http://enkiblog.com',
        'body'   => 'This is a comment'
      }
    end

    it_should_behave_like("invalid comment")

    it 'sets an appropriate error message on the comment' do
      assigns(:comment).openid_error.should == "Sorry, the OpenID verification failed"
    end
  end

  describe 'with a successful OpenID completion GET to #index' do
    before do
      mock_post!

      session[:pending_comment] = {
        :author => 'http://enkiblog.com',
        :body   => 'This is a comment'
      }

      stub_open_id_authenticate('http://enkiblog.com', :successful, false)
      post :index, :year => '2007', :month => '01', :day => '01', :slug => 'a-post'
    end

    it_should_behave_like("creating new comment")

    it 'records OpenID authority ' do
      pending("authority is blank until I patch open_id_authentication to provide it")
      assigns(:comment).author_openid_authority.should == 'http://example.com'
    end

    it 'records OpenID identity url' do
      assigns(:comment).author_url.should == 'http://enkiblog.com'
    end

    it 'uses full name as author' do
      assigns(:comment).author.should == 'Don Alias'
    end

    it 'records email' do
      assigns(:comment).author_email.should == 'donalias@enkiblog.com'
    end
  end

  describe "with a POST to #index (non-OpenID comment)" do
    before(:each) do
      mock_post!

      post :index, :year => '2007', :month => '01', :day => '01', :slug => 'a-post', :comment => {
        :author => 'Don Alias',
        :body   => 'This is a comment',

        # Attributes you are not allowed to set
        :author_url              => 'http://www.enkiblog.com',
        :author_email            => 'donalias@enkiblog.com',
        :author_openid_authority => 'http://enkiblog.com/openid_server',
        :created_at              => @created_at = 1.year.ago,
        :updated_at              => @updated_at = 1.year.ago,
      }
    end

    
    it "allows setting of author" do
      assigns(:comment).author.should == 'Don Alias'
    end

    it "allows setting of body" do
      assigns(:comment).body.should == 'This is a comment'
    end

    it "forbids setting of author_url" do
      assigns(:comment).author_url.should be_blank
    end

    it "forbids setting of author_email" do
      assigns(:comment).author_email.should be_blank
    end

    it "forbids setting of author_openid_authority" do
      assigns(:comment).author_openid_authority.should be_blank
    end
    
    it "forbids setting of created_at" do
      assigns(:comment).created_at.should_not == @created_at 
    end

    it "forbids setting of updated_at" do
      assigns(:comment).updated_at.should_not == @updated_at
    end
  end
end

describe CommentsController, 'with an AJAX request to new' do
  before(:each) do
    Comment.should_receive(:build_for_preview).and_return(@comment = mock_model(Comment))

    xhr :get, :new, :year => '2007', :month => '01', :day => '01', :slug => 'a-post', :comment => {
      :author => 'Don Alias',
      :body   => 'A comment'
    }
  end

  it "assigns a new comment for the view" do
    assigns(:comment).should == @comment
  end
end

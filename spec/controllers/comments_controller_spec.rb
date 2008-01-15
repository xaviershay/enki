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
  
  it 'renders a feed' do
    pending
    response.should render_template('index.atom')
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

describe CommentsController, 'with a POST to #index requiring OpenID authentication' do
  it 'stores a pending comment'
  it 'redirects to OpenID authority'
end

describe CommentsController, 'with a POST to #index requiring OpenID authentication but unavailable server' do
  it 'renders posts/show'
  it 'leaves comment in invalid state' 
end

describe CommentsController, 'with a unsuccessful OpenID completion GET to #index' do
  it 'renders posts/show'
  it 'leaves comment in invalid state' 
end

describe CommentsController, 'with a successful OpenID completion GET to #index' do
  #it_should_behave_like("creating new comment")

  it 'records OpenID authority'
  it 'records OpenID identity url'
  it 'uses full name as author'
  it 'records email if provided'
end

describe CommentsController, "with a POST to #index" do
  before(:each) do
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

    post :index, :year => '2007', :month => '01', :day => '01', :slug => 'a-post', :comment => {
      :author => 'Don Alias',
      :body   => 'This is a comment',

      # Attributes you are not allowed to set
      :author_url              => 'http://www.enkiblog.com',
      :author_email            => 'donalias@enkiblog.com',
      :author_openid_authority => 'http://enkiblog.com/openid_server',
      :created_at              => @created_at = 1.year.ago,
      :updated_at              => @updated_at = 1.year.ago,
      :spam                    => true,
      :spaminess               => 0.3,
      :signature               => 'rt3ienrt823wontsriun3iunrst3rsitun3'
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

  it "forbids setting of spam" do
    assigns(:comment).spam.should == false
  end

  it "forbids setting of spaminess" do
    assigns(:comment).spaminess.should be_nil
  end

  it "forbids setting of signature" do
    assigns(:comment).signature.should be_nil
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

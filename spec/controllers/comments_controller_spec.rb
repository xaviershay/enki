require File.dirname(__FILE__) + '/../spec_helper'

describe CommentsController, 'with GET to #index' do
  include UrlHelper

  it 'redirects to the parent post URL' do
    @mock_post = mock_model(Post,
      :published_at => 1.year.ago,
      :slug         => 'a-post'
    )
    Post.stub!(:find_by_permalink).and_return(@mock_post)
    get :index, :year => '2007', :month => '01', :day => '01', :slug => 'a-post'
    response.should be_redirect
    response.should redirect_to(post_path(@mock_post))
  end
end

shared_examples_for 'creating new comment' do
  include UrlHelper

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

shared_examples_for "invalid comment" do
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

  describe "with a POST to #index (non-OpenID comment)" do
    before(:each) do
      mock_post!

      post :create, :year => '2007', :month => '01', :day => '01', :slug => 'a-post', :comment => {
        :author => 'Don Alias',
        :body   => 'This is a comment',

        # Attributes you are not allowed to set
        :author_url              => 'http://www.enkiblog.com',
        :author_email            => 'donalias@enkiblog.com',
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
    response.should be_success
  end

  it "assigns a new comment for the view" do
    assigns(:comment).should == @comment
  end
end

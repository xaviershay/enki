require File.dirname(__FILE__) + '/../spec_helper'

describe CommentsController, 'with GET to #index' do
  include UrlHelper

  it 'redirects to the parent post URL' do
    @mock_post = mock_model(Post,
      :published_at => 1.year.ago,
      :slug         => 'a-post'
    )
    allow(Post).to receive(:find_by_permalink).and_return(@mock_post)
    get :index, :year => '2007', :month => '01', :day => '01', :slug => 'a-post'
    expect(response).to be_redirect
    expect(response).to redirect_to(post_path(@mock_post))
  end
end

shared_examples_for 'creating new comment' do
  include UrlHelper

  it 'assigns comment' do
    expect(assigns(:comment)).not_to be_nil
  end

  it 'creates a new comment on the post' do
    expect(assigns(:comment)).not_to be_new_record
  end

  it 'redirects to post' do
    expect(response).to be_redirect
    expect(response).to redirect_to(post_path(@mock_post))
  end
end

shared_examples_for "invalid comment" do
  it 'renders posts/show' do
    expect(response).to be_success
    expect(response).to render_template('posts/show')
  end

  it 'leaves comment in invalid state' do
    expect(assigns(:comment)).not_to be_valid
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
      allow(@mock_post).to receive(attribute).and_return(value)
    end
    allow(Post).to receive(:find_by_permalink).and_return(@mock_post)
    @mock_post
  end

  describe "with a POST to and an invalid comment" do
    before(:each) do
      mock_post!

      post :create, :year => '2007', :month => '01', :day => '01', :slug => 'a-post', :comment => {
        :author => nil,
        :body   => 'This is a comment'
      }
    end

    it_behaves_like("invalid comment")
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
        :updated_at              => @updated_at = 1.year.ago
      }
    end

    it_behaves_like("creating new comment")

    it "allows setting of author" do
      expect(assigns(:comment).author).to eq('Don Alias')
    end

    it "allows setting of body" do
      expect(assigns(:comment).body).to eq('This is a comment')
    end

    it "forbids setting of author_url" do
      expect(assigns(:comment).author_url).to be_blank
    end

    it "forbids setting of author_email" do
      expect(assigns(:comment).author_email).to be_blank
    end

    it "forbids setting of created_at" do
      expect(assigns(:comment).created_at).not_to eq(@created_at)
    end

    it "forbids setting of updated_at" do
      expect(assigns(:comment).updated_at).not_to eq(@updated_at)
    end
  end
end

describe CommentsController, 'with an AJAX request to new' do
  before(:each) do
    expect(Comment).to receive(:build_for_preview).and_return(@comment = mock_model(Comment))

    xhr :get, :new, :year => '2007', :month => '01', :day => '01', :slug => 'a-post', :comment => {
      :author => 'Don Alias',
      :body   => 'A comment'
    }
    expect(response).to be_success
  end

  it "assigns a new comment for the view" do
    expect(assigns(:comment)).to eq(@comment)
  end
end

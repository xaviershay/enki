require File.dirname(__FILE__) + "/test_helper"

class Article < ActiveRecord::Base
  column :author,       :string
  column :author_email, :string
  column :title,        :string
  column :content,      :text
  column :permalink,    :string
  column :created_at,   :datetime
  
  acts_as_defensio_article :owner_url => OWNER_URL
end

class ArticleWhenPublished < ActiveRecord::Base
  column :announced, :bool
  column :published_at, :date_time
  
  acts_as_defensio_article :owner_url => OWNER_URL,
                           :announce_when => :published?
  
  def published?
    !self.published_at.nil?
  end
end

class Comment < ActiveRecord::Base
  column :author,     :string
  column :comment,    :text
  column :spam,       :boolean
  column :spaminess,  :float
  column :signature,  :string
  column :article_id, :integer
  
  belongs_to :article
  
  acts_as_defensio_comment :owner_url => OWNER_URL,
                           :fields => { :content => :comment }
end

class ActsAsTest < Test::Unit::TestCase
  def setup
    @comment = Comment.new :author => 'marc', :comment => 'hi!',
                           :signature => '123', :spam => false, :spaminess => 1.0,
                           :new_record => false
  end
  
  def test_initialize
    assert_not_nil @comment.class.defensio
  end
  
  def test_audit_comment
    article = build_article :permalink => "test-#{Time.now.to_i}"
    
    Comment.defensio.
      expects(:audit_comment).
      once.
      with(:user_ip         => '127.0.0.1',
           :referrer        => 'http://google.com',
           :article_date    => '2007/1/1',
           :comment_type    => 'comment',
           :comment_author  => 'marc',
           :comment_content => 'hi!',
           :permalink       => article.permalink).
      returns(mock(:success? => true, :spaminess => 1, :spam => false, :signature => '123'))

    comment = build_comment :article => article
    comment.save

    assert !comment.spam
    assert_not_nil comment.spaminess
    assert_not_nil comment.signature
  end
  
  def test_annouce_article
    Article.defensio.
      expects(:announce_article).
      once.
      with(:article_author       => 'marc',
           :article_author_email => 'macournoyer@gmail.com',
           :article_title        => 'A test article',
           :article_content      => '...',
           :permalink            => 'test-article').
      returns(mock(:success? => true))
    
    article = build_article
    article.save
  end
  
  def test_do_not_annouce_article_when_not_published
    article = ArticleWhenPublished.new
    article.expects(:announce_article!).never
    
    article.save
    assert !article.announced
  end
  
  def test_do_not_annouce_article_when_published
    article = ArticleWhenPublished.new
    article.expects(:announce_article!).once
    
    article.published_at = Time.now
    article.save
    
    assert article.announced
  end
  
  def test_annouce_article_with_socket_error
    Net::HTTP.expects(:post_form).times(3).raises SocketError
    RAILS_DEFAULT_LOGGER.expects(:error).once
    
    article = build_article
    article.save
  end
  
  def test_audit_comment_with_socket_error
    Net::HTTP.expects(:post_form).times(3).raises SocketError
    RAILS_DEFAULT_LOGGER.expects(:error).once
    
    comment = build_comment :article => build_article(:new_record => false)
    comment.save
  end
    
  def test_report_as_false_negative
    Comment.defensio.expects(:report_false_negatives).with(:signatures => @comment.signature)
    @comment.report_as_false_negative
    assert @comment.spam
  end
  
  def test_report_as_false_positive
    Comment.defensio.expects(:report_false_positives).with(:signatures => @comment.signature)
    @comment.report_as_false_positive
    assert !@comment.spam
  end
  
  def test_get_stats
    response = Comment.defensio_stats
    assert_respond_to response, :spam
    assert_respond_to response, :ham
  end
  
  private
    def build_article(attributes={})
      Article.new({ :author       => 'marc',
                    :author_email => 'macournoyer@gmail.com',
                    :title        => 'A test article',
                    :content      => '...',
                    :permalink    => 'test-article',
                    :created_at   => Time.parse('2007-1-1 1:00') }.merge(attributes))
    end
    
    def build_comment(attributes={})
      comment = Comment.new({ :author  => 'marc',
                              :comment => 'hi!' }.merge(attributes))
      comment.env = { 'REMOTE_ADDR' => '127.0.0.1', 'HTTP_REFERER' => 'http://google.com' }
      comment
    end
end
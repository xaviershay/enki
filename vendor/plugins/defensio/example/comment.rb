class Comment < ActiveRecord::Base
  # Columns: author, content, title, author_email, author_url, permalink, article_id
  attr_accessor :current_user
  
  belongs_to :article
  
  acts_as_defensio_comment
  
  def user_logged_in
    current_user.logged_in?
  end
  
  def trusted_user
    current_user.admin?
  end
end

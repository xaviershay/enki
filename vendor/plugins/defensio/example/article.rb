class Article < ActiveRecord::Base
  # Columns: author, author_email, title, content, permalink
  has_many :comments
  
  acts_as_defensio_article
end

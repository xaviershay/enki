class Comment < ActiveRecord::Base
  belongs_to :post

  def body_html
    body
  end
end

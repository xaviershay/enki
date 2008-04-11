class Author < ActiveRecord::Base
  validates_presence_of :name, :email, :open_id
end

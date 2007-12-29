
# this model expects a certain database layout and its based on the name/login pattern. 
class User < ActiveRecord::Base

  def self.get(openid_url)
    find_first(["openid_url = ?", openid_url])
  end  
  

  protected
  
  validates_uniqueness_of :openid_url, :on => :create
  validates_presence_of :openid_url
end

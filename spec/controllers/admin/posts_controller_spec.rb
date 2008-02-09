require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::PostsController do
  describe 'handling POST to create with valid attributes' do
    def valid_post_attributes
      {
        :title => "My Post",
        :body  => "hello this is my post"
      }
    end

    it 'creates a post' do
      session[:logged_in] = true
      lambda { post :create, :post => valid_post_attributes }.should change(Post, :count).by(1)
    end
  end
end

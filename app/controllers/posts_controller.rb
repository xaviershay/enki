class PostsController < ApplicationController
  def index
    @posts = Post.find_recent(:limit => 15)
  end

  def show
    @post = Post.find_by_permalink(*[:year, :month, :day, :slug].collect {|x| params[x] })
    @comment = @post.comments.build
  end
end

class PostsController < ApplicationController
  def index
    if @tag = params[:tag]
      @posts = Post.find_tagged_with(@tag)
    else
      @posts = Post.find_recent(:limit => 15)
    end
  end

  def show
    @post = Post.find_by_permalink(*[:year, :month, :day, :slug].collect {|x| params[x] })
    @comment = Comment.new
  end
end

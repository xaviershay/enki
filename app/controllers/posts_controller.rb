class PostsController < ApplicationController
  def index
    if @tag = params[:tag]
      @posts = Post.find_recent_by_tag(@tag)
    else
      @posts = Post.find_recent(:include => :tags)
    end

    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end

  def show
    @post = Post.find_by_permalink(*[:year, :month, :day, :slug].collect {|x| params[x] })
    @comment = Comment.new
  end
end

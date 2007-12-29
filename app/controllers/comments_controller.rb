class CommentsController < ApplicationController
  include UrlHelper

  before_filter :find_post

  def index
    if request.post?
      create
    else
      raise "TODO: Comments#index"
    end
  end

  def create
    @post.comments.create(params[:comment])
    redirect_to post_path(@post)
  end

  protected

  def find_post
    @post = Post.find_by_permalink(*[:year, :month, :day, :slug].collect {|x| params[x] })
  end
end

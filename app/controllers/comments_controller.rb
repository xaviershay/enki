class CommentsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  before_filter :verify_authenticity_token_unless_using_openid, :only => :create

  include UrlHelper

  before_filter :find_post, :except => [:new]

  def index
    redirect_to(post_path(@post))
  end

  def new
    @comment = Comment.build_for_preview(comment_params)

    respond_to do |format|
      format.js do
        render :partial => 'comment', :locals => {:comment => @comment}
      end
    end
  end

  # TODO: Spec OpenID with cucumber and rack-my-id
  def create
    @comment = Comment.new((session[:pending_comment] || comment_params || {}).
      reject { |key, value| !Comment.protected_attribute?(key) })

    @comment.post = @post

    if !@comment.requires_openid_authentication?
      @comment.blank_openid_fields
      save_comment_or_show_error
    else
      if request.env['omniauth.auth'].nil? && params[:message].blank? # Begin auth.
        session[:pending_comment] = comment_params
        session[:post_id] = @post.id
        redirect_to auth_path(:open_id_comment, "openid_url=#{@comment.author}")
      elsif request.env['omniauth.auth'].persent? # Process success response.
        @comment.author_url = request.env['omniauth.auth'][:uid]
        @comment.author = request.env['omniauth.auth'][:info][:name]
        @comment.author_email = request.env['omniauth.auth'][:info][:email] || ''
        @comment.openid_error = ''
        save_comment_or_show_error
      else # Process error response.
        @comment.openid_error = params[:message]
        save_comment_or_show_error
      end
    end
  end

  private

  def save_comment_or_show_error
    if @comment.save
      session[:pending_comment] = nil
      session[:post_id] = nil
      redirect_to post_path(@post)
    else
      render :template => 'posts/show'
    end
  end

  def comment_params
    params.require(:comment).permit(:author, :body)
  end

  protected

  def find_post
    @post = Post.find_by_permalink(*[:year, :month, :day, :slug].map {|x|
      params[x]
    })

    rescue ActiveRecord::RecordNotFound
      @post = Post.find(session[:post_id])
  end

  def verify_authenticity_token_unless_using_openid
    verify_authenticity_token unless using_open_id?
  end

  def using_open_id?
    if request.env['omniauth.auth'].present? &&
       request.env['omniauth.auth'][:provider] == OMNIAUTH_OPEN_ID_COMMENT_STRATEGY
      return true
    end

    return false
  end
end

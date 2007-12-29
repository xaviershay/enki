class CommentsController < ApplicationController
  include UrlHelper

  before_filter :find_post

  def index
    if request.post? || openid_completion?(request)
      create
    else
      raise "TODO: Comments#index"
    end
  end

  def create
    @comment = session[:pending_comment] || Comment.new((params[:comment] || {}).merge(:post => @post))
    session[:pending_comment] = nil
    consumer = OpenID::Consumer.new(session[:openid_session] ||= {}, OpenID::Store::Filesystem.new('tmp/openid'))
    if openid_completion?(request)
      openid_response = consumer.complete(params.reject{|k,v|request.path_parameters[k]}, request.protocol + request.host_with_port + request.request_uri)

      if openid_response.is_a?(OpenID::Consumer::SuccessResponse)
        open_id_fields = openid_response.extension_response('http://openid.net/extensions/sreg/1.1', false)
        @comment.author = open_id_fields["fullname"].to_s
        @comment.author_email = open_id_fields["email"].to_s
        @comment.author_openid_authority = openid_response.identity_url

        @comment.openid_error = ""
      else
        @comment.openid_error = "Could not authenticate <q>#{@comment.author_url}</q>"
      end
    elsif @comment.requires_openid_authentication?
      begin
        @comment.author_url = @comment.author
        openid_request = consumer.begin(@comment.author_url)
        openid_request.add_extension(OpenID::SReg::Request.new(['fullname'], ['email']))

        session[:pending_comment] = @comment    
            
        return_path = request.protocol + request.host_with_port + post_comments_path(@post)
        redirect(openid_request.redirect_url(request.protocol + request.host_with_port + '/', return_path))
        return
      rescue OpenID::DiscoveryFailure
        @comment.openid_error = "Unable to find OpenID server for <q>#{@comment.author}</q>"
      end
    end

    if @comment.save
      redirect_to post_path(@post)
    else
      render :template => 'posts/show'
    end
  end

  protected

  def find_post
    @post = Post.find_by_permalink(*[:year, :month, :day, :slug].collect {|x| params[x] })
  end

  def openid_completion?(request)
    request.get? && params["openid.mode"]
  end
    
  def redirect(where = {})
    headers['Location'] = url_for(where)
    render :nothing => true, :status => '302 Redirect'
    return
  end
end

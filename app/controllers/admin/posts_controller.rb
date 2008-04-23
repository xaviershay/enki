class Admin::PostsController < Admin::BaseController
  before_filter :find_post, :only => [:show, :update, :destroy]
  before_filter :translate_params, :only => [:create, :update]

  def index
    respond_to do |format|
      format.html {
        @posts = Post.paginate(
          :order => "created_at DESC",
          :page  => params[:page]
        )
      }
      format.yaml {
        render :yaml => Post.find(:all, 
          :select => 'id, title',
          :order  => 'created_at DESC'
        ).to_yaml
      }
    end
  end

  def create
    @post = Post.new(params[:post])
    if @post.save
      respond_to do |format|
        format.html {
          flash[:notice] = "Created post '#{@post.title}'"
          redirect_to(:action => 'show', :id => @post)
        }
        format.yaml { head(200) }
      end
    else
      respond_to do |format|
        format.html { render :action => 'new',         :status => :unprocessable_entity }
        format.yaml { render :yaml   => false.to_yaml, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    if @post.update_attributes(params[:post])
      respond_to do |format|
        format.html {
          flash[:notice] = "Updated post '#{@post.title}'"
          redirect_to(:action => 'show', :id => @post)
        }
        format.yaml { head(200) }
      end
    else
      respond_to do |format|
        format.html { render :action => 'show',        :status => :unprocessable_entity }
        format.yaml { render :yaml   => false.to_yaml, :status => :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.html {
        render :partial => 'post', :locals => {:post => @post} if request.xhr?
      }
      format.yaml {
        render :yaml => @post.to_yaml(:attributes => [:title, :slug, :body, :tag_list, :created_at, :updated_at, :published_at])
      }
    end
  end

  def destroy
    @post = Post.find(params[:id])
    undo_item = @post.destroy_with_undo

    respond_to do |format|
      format.html do
        flash[:notice] = "Deleted post '#{@post.title}'"
        redirect_to :action => 'index' 
      end
      format.json { 
        render :json => {
          :undo_path    => undo_admin_undo_item_path(undo_item),
          :undo_message => undo_item.description,
          :post         => @post
        }.to_json
      }
    end
  end

  protected

  def find_post
    @post = Post.find(params[:id])
  end

  def translate_params  
    params.update(translate_yaml(request.raw_post)) if params[:format] == 'yaml'
  end

  def build_object
    @current_object = Post.new(object_parameters) do |post|
      post.published_at = Time.now
    end
  end
end

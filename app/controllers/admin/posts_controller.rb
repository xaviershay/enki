class Admin::PostsController < Admin::BaseController
  make_resourceful do
    actions :all
    publish :yaml, :attributes => [:title, :slug, :body, :tag_list, :created_at, :updated_at, :published_at]

    response_for(:create) do
      redirect_to(:action => 'edit', :id => @post)
    end

    after(:create) do
      flash[:notice] = "Post created"
    end

    before(:update) do
      params.update(translate_yaml(request.raw_post)) if params[:format] == 'yaml'
    end

    after(:update) do
      flash[:notice] = "Post updated"
    end
   
    response_for(:update) do |format|
      format.html { redirect_to(:action => 'edit', :id => @post) }
      format.yaml { head(200) }
    end

    response_for(:update_fails) do |format|
      format.html { render :action => 'edit',        :status => :unprocessable_entity }
      format.yaml { render :yaml   => false.to_yaml, :status => :unprocessable_entity }
    end
  end

  protected

  def current_objects
    @current_objects ||= current_model.paginate(
      :order => "created_at DESC", 
      :page => params[:page] 
    )
  end

  def build_object
    @current_object = Post.new(object_parameters) do |post|
      post.published_at = Time.now
    end
  end
end

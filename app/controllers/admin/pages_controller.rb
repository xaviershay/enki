class Admin::PagesController < Admin::BaseController
  make_resourceful do
    actions :all
    publish :yaml, :attributes => [:title, :slug, :body, :created_at, :updated_at]

    response_for(:create) do
      redirect_to(:action => 'edit', :id => @page)
    end

    after(:create) do
      flash[:notice] = "Page created"
    end

    before(:update) do
      params.update(translate_yaml(request.raw_post)) if params[:format] == 'yaml'
    end

    after(:update) do
      flash[:notice] = "Page updated"
    end

    response_for(:update) do |format|
      format.html { redirect_to(:action => 'edit', :id => @page) }
      format.yaml { head(200) }
    end

    response_for :update_fails do |format|
      format.html { render :action => 'edit', :status => :unprocessable_entity }
      format.yaml { render :yaml => false.to_yaml, :status => :unprocessable_entity }
    end
  end

  protected

  def current_objects
    @current_object ||= current_model.paginate(
      :order => "created_at DESC", 
      :page => params[:page] 
    )
  end

  def translate_yaml(yaml)
    ret = YAML.load(yaml)
    raise("Invalid request: YAML must specify a hash") unless ret.is_a?(Hash)
    ret
  end
end

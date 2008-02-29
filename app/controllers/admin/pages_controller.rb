class Admin::PagesController < Admin::BaseController
  make_resourceful do
    actions :all
    publish :yaml, :attributes => [:id, :title], :only => :index
    publish :yaml, :attributes => [:title, :slug, :body, :created_at, :updated_at], :only => :show

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

    response_for(:update_fails) do |format|
      format.html { render :action => 'edit',        :status => :unprocessable_entity }
      format.yaml { render :yaml   => false.to_yaml, :status => :unprocessable_entity }
    end
  end

  protected

  def current_objects
    if params[:format] == 'yaml'
      @current_objects ||= current_model.find(:all, 
        :select => 'id, title',
        :order  => 'created_at DESC'
      )
    else
      @current_object ||= current_model.paginate(
        :order => "created_at DESC",
        :page  => params[:page]
      )
    end
  end
end

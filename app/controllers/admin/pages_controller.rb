class Admin::PagesController < Admin::BaseController
  before_filter :find_page, :only => [:show, :update, :destroy]
  before_filter :translate_params, :only => [:create, :update]

  def index
    respond_to do |format|
      format.html {
        @pages = Page.paginate(
          :order => "created_at DESC",
          :page  => params[:page]
        )
      }
      format.yaml {
        render :yaml => Page.find(:all, 
          :select => 'id, title',
          :order  => 'created_at DESC'
        ).to_yaml
      }
    end
  end

  def create
    @page = Page.new(params[:page])
    if @page.save
      respond_to do |format|
        format.html {
          flash[:notice] = "Created page '#{@page.title}'"
          redirect_to(:action => 'show', :id => @page)
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
    if @page.update_attributes(params[:page])
      respond_to do |format|
        format.html {
          flash[:notice] = "Updated page '#{@page.title}'"
          redirect_to(:action => 'show', :id => @page)
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
        render :partial => 'page', :locals => {:page => @page} if request.xhr?
      }
      format.yaml {
        render :yaml => @page.to_yaml(:attributes => [:title, :slug, :body, :created_at, :updated_at])
      }
    end
  end

  def new
    @page = Page.new
  end

  def destroy
    undo_item = @page.destroy_with_undo

    respond_to do |format|
      format.html do
        flash[:notice] = "Deleted page '#{@page.title}'"
        redirect_to :action => 'index' 
      end
      format.json { 
        render :json => {
          :undo_path    => undo_admin_undo_item_path(undo_item),
          :undo_message => undo_item.description,
          :page         => @page
        }.to_json
      }
    end
  end

  protected

  def find_page
    @page = Page.find(params[:id])
  end
end

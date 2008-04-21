class Admin::UndoItemsController < Admin::BaseController
  layout 'admin_new'

  def index
    @undo_items = UndoItem.find(:all,
      :order => 'created_at DESC',
      :limit => 50
    )
  end

  def undo
    item = UndoItem.find(params[:id])
    object = item.process!

    respond_to do |format|
      format.html {
        flash[:notice] = item.complete_description
        redirect_to(:back)
      }
      format.json {
        render :json => {
          :message => item.complete_description,
          :obj     => object
        }
      }
    end
  end
end

class Admin::UndoItemsController < Admin::BaseController
  def index
    @undo_items = UndoItem.order('created_at DESC').limit(50).all
  end

  def undo
    item = UndoItem.find(params[:id])
    begin
      object = item.process!

      respond_to do |format|
        format.html do
          flash[:notice] = item.complete_description
          redirect_to(:back)
        end
        format.json {
          render :json => {
            :message => item.complete_description,
            :obj     => object.attributes
          }
        }
      end
    rescue UndoFailed
      msg = "Could not undo, would result in an invalid state (i.e. a comment with no post)"
      respond_to do |format|
        format.html do
          flash[:notice] = msg
          redirect_to(:back)
        end
        format.json { render :json => { :message => msg } }
      end
    end
  end
end

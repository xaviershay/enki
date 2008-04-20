class Admin::CommentsController < Admin::BaseController
  layout 'admin_new'

  before_filter :find_comment, :only => [:show, :update, :destroy]

  def index
    @comments = Comment.paginate(
      :include => "post",
      :order => "comments.created_at DESC", 
      :page => params[:page] 
    )
  end
  
  def show
  end

  def update
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Updated comment by #{@comment.author}"
      redirect_to :action => 'index'
    else
      render :action => 'show'
    end
  end

  def destroy
    @comment.destroy

    respond_to do |format|
      format.html do
        flash[:notice] = "Deleted comment by #{@comment.author}"
        redirect_to :action => 'index' 
      end
      format.json { render :json => @comment.to_json }
    end
  end

  protected

  def find_comment
    @comment = Comment.find(params[:id])
  end
end

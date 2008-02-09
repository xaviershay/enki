class Admin::CommentsController < Admin::BaseController
  before_filter :find_comment, :only => [:mark_as_spam, :mark_as_ham]

  make_resourceful do
    actions :index, :edit, :update, :destroy

    after(:update) do
      flash[:notice] = "Comment updated"
    end

    response_for(:update) do
      redirect_to(:action => 'index')
    end
  end

  protected

  def current_objects
    @current_object ||= current_model.paginate(
      :include => "post",
      :order => "comments.created_at DESC", 
      :page => params[:page] 
    )
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end
end

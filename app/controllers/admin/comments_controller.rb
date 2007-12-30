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

  def mark_as_spam
    @comment.report_as_spam
    redirect_to :back 
  end

  def mark_as_ham
    @comment.report_as_ham
    redirect_to :back
  end

  protected

  def find_comment
    @comment = Comment.find(params[:id])
  end
end

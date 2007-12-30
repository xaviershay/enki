class CommentsController < ApplicationController
  def index
    @ham  = @article.comments.find_all_by_spam(false)
    @spam = @article.comments.find_all_by_spam(true, :order => 'spaminess desc')
  end
  
  def create
    @comment = @article.comments.build(params[:comment])
    @comment.env = request.env
    @comment.current_user = self.current_user
    
    if @comment.save
      if @comment.spam
        flash[:notice] = 'Your comment has been marked for review'
      else
        flash[:notice] = 'Comment created'
      end
      redirect_to article_url(@article)
    else
      render :action => 'new'
    end
  end
  
  def report_as_spam
    @comment = @article.comments.find(params[:id])
    @comment.report_as_spam
  end
  
  def report_as_ham
    @comment = @article.comments.find(params[:id])
    @comment.report_as_ham
  end
  
  def stats
    @stats = Comment.defensio_stats
  end
end
class Admin::DashboardController < Admin::BaseController
  layout 'admin_new'

  def show
    @posts            = Post.find_recent
    @comment_activity = CommentActivity.find_recent
  end
end

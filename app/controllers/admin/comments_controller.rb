class Admin::CommentsController < Admin::BaseController
  make_resourceful do
    actions :index, :edit, :update, :destroy

    after(:update) do
      flash[:notice] = "Comment updated"
    end

    response_for(:update) do
      redirect_to(:action => 'index')
    end
  end
end

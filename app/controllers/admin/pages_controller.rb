class Admin::PagesController < Admin::BaseController
  make_resourceful do
    actions :all

    response_for(:create) do
      redirect_to(:action => 'edit', :id => @page)
    end

    after(:create) do
      flash[:notice] = "Page created"
    end

    after(:update) do
      flash[:notice] = "Page updated"
    end

    response_for(:update) do
      redirect_to(:action => 'edit', :id => @page)
    end
  end
end

class ArchivesController < ApplicationController
  def index
    @months = Post.find_all_grouped_by_month
  end
end

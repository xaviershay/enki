module TagHelper
  def popular_tags
    Tag.find(:all).reject {|tag| tag.taggings.empty? }.sort_by {|tag| tag.taggings.size }.reverse
  end
end

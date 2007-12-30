module TagHelper
  def popular_tags
    @popular_tags ||= Tag.find(:all).reject {|tag| tag.taggings.empty? }.sort_by {|tag| tag.taggings.size }.reverse
  end

  def linked_tag_list(tags)
    tags.collect {|tag| link_to(tag.name, posts_path(:tag => tag))}.join(", ")
  end
end

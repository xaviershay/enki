module TagHelper
  def linked_tag_list(tags)
    raw tags.collect {|tag| link_to(tag.name, posts_path(:tag => tag.name))}.join(", ")
  end
end

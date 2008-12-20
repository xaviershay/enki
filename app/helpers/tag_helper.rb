module TagHelper
  def linked_tag_list(tags)
    tags.collect {|tag| link_to(h(tag.name), posts_path(:tag => tag))}.join(", ")
  end
end

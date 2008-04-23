class DeletePostUndo < UndoItem
  def process!
    post_attributes = loaded_data[:post]
    raise('Post already exists') if Post.find_by_id(post_attributes.delete('id').to_i)

    post = nil
    transaction do
      post = Post.create!(post_attributes)
      loaded_data[:comments].each do |comment|
        post.comments.create!(comment.except('id'))
      end
      self.destroy
    end
    post
  end

  def loaded_data
    @loaded_data ||= YAML.load(data)
  end

  def description
    "Deleted post '#{loaded_data[:post]["title"]}'"
  end

  def complete_description
    "Recreated post '#{loaded_data[:post]["title"]}'"
  end

  class << self
    def create_undo(post)
      DeletePostUndo.create!(:data => {:post => post.attributes, :comments => post.comments.collect(&:attributes)}.to_yaml)
    end
  end
end

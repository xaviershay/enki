class DeleteCommentUndo < UndoItem
  def process!
    raise(UndoFailed) if Comment.find_by_id(loaded_data.delete('id').to_i)

    comment = nil
    transaction do
      comment = Comment.create(loaded_data)
      raise UndoFailed if comment.new_record?
      self.destroy
    end
    comment
  end

  def loaded_data
    @loaded_data ||= YAML.load(data)
  end

  def description
    "Deleted comment by '#{loaded_data['author']}'"
  end

  def complete_description
    "Recreated comment by '#{loaded_data['author']}'"
  end

  class << self
    def create_undo(comment)
      DeleteCommentUndo.create!(:data => comment.attributes.to_yaml)
    end
  end
end

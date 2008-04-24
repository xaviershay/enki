class DeletePageUndo < UndoItem
  def process!
    raise('Page already exists') if Page.find_by_id(loaded_data.delete('id').to_i)

    page = nil
    transaction do
      page = Page.create!(loaded_data)
      self.destroy
    end
    page
  end

  def loaded_data
    @loaded_data ||= YAML.load(data)
  end

  def description
    "Deleted page '#{loaded_data['title']}'"
  end

  def complete_description
    "Recreated page '#{loaded_data['title']}'"
  end

  class << self
    def create_undo(page)
      DeletePageUndo.create!(:data => page.attributes.to_yaml)
    end
  end
end

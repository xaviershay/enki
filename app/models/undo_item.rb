class UndoItem < ActiveRecord::Base
  def process!
    raise("#process must be implemented by subclasses")
  end
end

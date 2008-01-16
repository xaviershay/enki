class Dir

  # Is a path parental to another?
  #
  #   TODO: Needs improvement.
  #   TODO: Instance version?

  def self.parent?(parent_path, child_path)
    %r|^#{Regexp.escape(parent_path)}| =~ child_path
  end

end

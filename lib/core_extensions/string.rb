module CoreExtensions::String
  def slugorize
    result = self.downcase
    result.gsub!(/&(\d)+;/, '')  # Ditch Entities
    result.gsub!('&', 'and')     # Replace & with 'and'
    result.gsub!(/['"]/, '')    # replace quotes by nothing
    result.gsub!(/\W/, ' ')     # strip all non word chars
    result.gsub!(/\ +/, '-')    # replace all white space sections with a dash
    result.gsub!(/(-)$/, '')    # trim dashes
    result.gsub!(/^(-)/, '')    # trim dashes
    result.gsub!(/[^a-zA-Z0-9\-]/, '-') # Get rid of anything we don't like
    result
  end

  def slugorize!
    self.replace(self.slugorize)
  end
end

String.send(:include, CoreExtensions::String)

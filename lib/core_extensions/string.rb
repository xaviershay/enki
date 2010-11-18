module CoreExtensions::String
  
  def slugorize
    result = self.downcase
    result.gsub!(/&([0-9a-z#])+;/, '')  # Ditch Entities
    result.gsub!('&', 'and')     # Replace & with 'and'
    result.gsub!(/[^a-z0-9\-]/, ' ') # Get rid of anything we don't like
    result.gsub!(/\ +/, '-')    # replace all white space sections with a dash
    result.gsub!(/(-)$/, '')    # trim dashes
    result.gsub!(/^(-)/, '')    # trim dashes
    result.gsub!(/(-)+/, '-')    # collapse dashes
    result
  end

  def slugorize!
    self.replace(self.slugorize)
  end
end

String.send(:include, CoreExtensions::String)

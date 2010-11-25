module CoreExtensions
  module String
  
    def slugorize
      result = self.downcase
      result.gsub!(/&([0-9a-z#])+;/, '')  # Ditch Entities
      result.gsub!('&', 'and')            # Replace & with 'and'
      result.gsub!(/[^a-z0-9\-']/, '-')   # Get rid of anything we don't like
      result.gsub!(/-+/, '-')             # collapse dashes
      result.gsub!(/-$/, '')              # trim dashes
      result.gsub!(/^-/, '')              # trim dashes
      result
    end

    def slugorize!
      self.replace(self.slugorize)
    end

  end
end

String.send(:include, CoreExtensions::String)

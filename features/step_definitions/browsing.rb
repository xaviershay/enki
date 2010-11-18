Then /I should see a link to all posts tagged "([\w\s]+)"/ do |tag_name|
  # TODO: Use an xpath matcher rather than regex
  response.body.should =~ %r{<a href="/#{tag_name}">awesome</a>}
end

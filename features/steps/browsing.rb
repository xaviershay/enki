Given /there is at least one post tagged "([\w\s]+)"/ do |tag_name|
  Factory(:post, :tags => [Factory(:tag, :name => tag_name)])
end

Then /I should see a link to all posts tagged "([\w\s]+)"/ do |tag_name|
  # TODO: Use an xpath matcher rather than regex
  response.body.should =~ %r{<a href="/#{tag_name}">awesome</a>}
end

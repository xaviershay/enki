require 'factory_girl'

Factory.define(:tag) do |a|
  a.name 'Tag'
end

Factory.define(:post) do |a|
  a.title     'A post'
  a.slug      'a-post'
  a.body      'This is a post'

  a.published_at Time.now
  a.created_at   Time.now
  a.updated_at   Time.now
end

Factory.define(:comment) do |a|
  a.author   'Don Alias'
  a.body     'I find this article thought provoking'
  a.association :post
end

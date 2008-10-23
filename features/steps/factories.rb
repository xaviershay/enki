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

  a.tags {|t| t.association(:tags) }
end

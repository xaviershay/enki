require 'factory_girl'

FactoryGirl.define do
  factory :tag, :class => ActsAsTaggableOn::Tag do
    name 'Tag'
  end

  factory :post do
    title     'A post'
    slug      'a-post'
    body      'This is a post'

    published_at { 1.day.ago }
    created_at   { 1.day.ago }
    updated_at   { 1.day.ago }
  end

  factory :comment do
    author       'Don Alias'
    author_email 'enki@enkiblog.com'
    author_url   'http://enkiblog.com'
    body         'I find this article thought provoking'
    association :post
  end
end
require 'factory_girl'

# These factories are used by some rspec specs, as opposed
# to the ones used by cucumber which are defined elsewhere.
FactoryGirl.define do
  factory :post do
    title                'My Post'
    body                 'hello this is my post'
    tag_list             'red, green, blue'
    published_at_natural 'now'
    slug                 'my-manually-entered-slug'
    minor_edit           '0'
  end

  factory :comment do
    author       'Don Pseudonym'
    author_email 'donpseudonym@enkiblog.com'
    author_url   'http://enkiblog.com'
    body         'Not all those who wander are lost'
    association :post
  end

  factory :page do
    title 'My page'
    slug  'my-manually-entered-slug'
    body  'hello this is my page'
  end
end

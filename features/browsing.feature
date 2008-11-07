Feature: Browsing
  Because I write totally awesome posts
  An everyday Joe
  Should be able to read and comment on my posts

  Scenario: browsing the home page
    Given there is at least one post tagged "awesome"
    When I go to the home page
    Then I should see "This is a post"
    And I should see a link to all posts tagged "awesome"

  Scenario: browsing the archive, to find more content to read
    Given there is at least one post titled "My Post"
    When I go to the home page
    And I follow "Archives"
    Then I should see "My Post"

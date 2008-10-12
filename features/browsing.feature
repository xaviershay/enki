Feature: Browsing
  Because I write totally awesome posts
  An everyday Joe
  Should be able to read and comment on my posts

  Scenario: browsing the home page
    Given there is at least one post tagged "awesome"
    When I go to the home page
    Then I should see "This is a post"
    And I should see a link to all posts tagged "awesome"

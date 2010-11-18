# I want to remove this feature
Feature: Tag edit
  Because no good reason
  An admin
  Should be able to edit tags

  Scenario: edit tag
    Given I am logged in
    And there is at least one post tagged "cool"
    When I go to /admin
    And I follow "Tags"
    And I follow "Edit"
    And I fill in "Name" with "awesome"
    And I press "Save"
    # Not sure why this doesn't redirect automatically
    And I follow "redirected"
    Then I should see "awesome"

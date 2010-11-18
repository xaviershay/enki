Feature: Undo
  Because I am human and make mistakes
  An admin
  Should be able to undo actions they make

  Scenario: delete a comment, then undo it
    Given I am logged in
    And the following comment exists:
      | body              |
      | Accidental Delete |
    When I go to /admin
    And I follow "Comments"
    And I press "Delete Comment"
    # Not sure why this doesn't redirect automatically
    And I follow "redirected"
    And I follow "Actions"
    And I press "Undo"
    Then a comment exists with attributes:
      | body              |
      | Accidental Delete |

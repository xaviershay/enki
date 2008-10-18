Feature: Health Monitor
  Because I want to have confidence that my site works
  An admin
  Should be able generate an exception to verify the error reporting stack is working

  Scenario: generating an exception
    Given I am logged in
    When I go to /admin
    And I follow "health"
    Then a RuntimeError is thrown when I press "throw exception"

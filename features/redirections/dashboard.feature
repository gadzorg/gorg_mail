Feature: I can manage my redirection from a dashboard

  Scenario: I can't access dashboard as a non-Gadz
    Given I am logged in with a non-gadz account
    When I visit "/dashboard"
    Then I should be forbidden to access the ressource
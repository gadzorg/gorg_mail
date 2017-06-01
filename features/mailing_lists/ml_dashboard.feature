Feature: I can manage my mailinglist subscriptions from a dashboard

  Scenario: As a non gadz member, I can't access the dashboard
    Given I am logged in with a non-gadz account
    When I visit "/mailinglists"
    Then I am forbidden to access the ressource
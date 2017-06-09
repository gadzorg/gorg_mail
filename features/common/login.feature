Feature: I login in the application

  Scenario: I visit the home page
    When I visit "/"
    Then the page has button "Connexion"

  Scenario: I visit home page as a logged-in Gadz
    Given I am logged in with a gadz account
    When I visit "/"
    Then I am redirected to "/dashboard"

  Scenario: I visit home page as a logged-in non-Gadz
    Given I am logged in with a non-gadz account
    When I visit "/"
    Then I am redirected to "/mailinglists"

  Scenario: I visit home page as a non initialized Gadz account
    Given I am logged in with a newly created gadz account
    When I visit "/"
    Then I am redirected to "/setup"
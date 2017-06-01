@javascript
Feature: I'm asked to setup my account on first log-in
  
  Scenario: I'm already setup
    Given I am logged in with a gadz account
    When I visit "/setup"
    Then I am redirected to "/dashboard"

  Scenario: I connect to the dashboard for the first time
    Given I am logged in with a newly created gadz account
    When I visit "/dashboard"
    Then I am redirected to "/setup"

  Scenario: I connect to the dashboard for the second time time
    Given I am logged in with a newly created gadz account
    And I visit "/dashboard"
    When I visit "/dashboard"
    Then I am redirected to "/setup"

  Scenario: I fill the setup form
    Given I am logged in with a newly created gadz account with firstname "john", lastname "doe"
    When I visit "/dashboard"
    And I check box "google_apps"
    And I fill "redirect" with "mon.adresse@example.com"
    And I click "Créer mon compte" button
    Then my redirect address "mon.adresse@example.com" is created
    And my source address "john.doe@gadz.org" is created
    And my googleapps account is created
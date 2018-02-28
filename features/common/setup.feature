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
    And I should not be subscribed to any mailinglist

  Scenario: I fill the setup form with subscription optout
    Given I am logged in with a newly created gadz account with firstname "john", lastname "doe", gadz_centre_principal "bo", gadz_proms_principale "2017"
    And there is a public mailing lists with email "tbk.bo@gadz.org"
    And there is a public mailing lists with email "bo217@gadz.org"
    And there is a public mailing lists with email "info-pg@gadz.org"
    When I visit "/dashboard"
    And I check box "default_mls"
    And I fill "redirect" with "mon.adresse@example.com"
    And I click "Créer mon compte" button
    Then my redirect address "mon.adresse@example.com" is created
    And I should be subscribed to 3 mailinglists
    And I should be subscribed to mailinglist "tbk.bo@gadz.org"
    And I should be subscribed to mailinglist "bo217@gadz.org"
    And I should be subscribed to mailinglist "info-pg@gadz.org"

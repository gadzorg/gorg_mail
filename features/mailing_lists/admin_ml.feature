Feature: Invite a user without account to join a mailing list
  #In step definitions 'I' refers to @meFeature: Register to a Mailinglists



  Background:
    Given I am logged in with a gadz account with email "my_address@gadz.org"
    And the following mailing lists exists :
      | inscription_policy |           name  |
      | closed             |           My Ml |
    And I am admin of the list "My Ml"
    And I visit the page of the mailling list "My Ml"



  Scenario: I subscribe a Gadz User
    Given the following users exist :
      | is_gadz      |hruid        | primary_email_source_account | email              |
      | true         |un.gadz.2011 |             un.gadz@gadz.org | ungadz@example.com |
    When I fill "email" with "un.gadz@gadz.org"
    And I click "Ajouter" button
    Then user "un.gadz.2011" should be subscribed to mailinglist "My Ml"

  Scenario: I subscribe a non-Gadz User
    Given the following users exist :
      | is_gadz      |hruid        | email              |
      | false        |un.pecs.ext  | unpecs@example.com |
    When I fill "email" with "unpecs@example.com"
    And I click "Ajouter" button
    Then user "un.pecs.ext" should be subscribed to mailinglist "My Ml"
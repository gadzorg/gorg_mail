Feature: Invite a user without account to join a mailing list
  #In step definitions 'I' refers to @me

  Background:
    Given there is a public mailing lists named "my_mailing_list"


  # As the Mailing List administrator
  Scenario: I invite external email "external@example.com" to join the list
    Given I am logged in with a gadz account with email "my_address@gadz.org"
    And I am admin of the list "my_mailing_list"
    When I visit the page of the mailling list "my_mailing_list"
    And I fill "email" with "external@example.com"
    And I click "Ajouter" button
    Then "external@example.com" receive an email with object "Vous êtes invité à rejoindre le groupe \"my_mailing_list\""
    And this email contains a link with a token
    And "me@example.com" becomes subscribed to the mailinglist "some_ml" as an inactive external member


  # As the external member
  Scenario: I click the link in the mail
    Given "external@example.com" was invited to join the mailing list named "my_mailing_list" with token "some_token"
    When I visit "/ml/lists/invations/some_token"
    Then the page contains "my_mailing_list"
    And the page contains "J'accepte les CGU"
    And the page contains a button "Accepter"
    And the page contains a button "Refuser"

  Scenario: I accept the invitation

  Scenario: I decline the invitation

  Scenario:
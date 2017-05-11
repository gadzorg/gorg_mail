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
    Then "external@example.com" becomes subscribed to the mailinglist "my_mailing_list" as an inactive external member
    And "external@example.com" receive an email with object "Vous êtes invité à rejoindre le groupe \"my_mailing_list\""
    And this email contains a link with a token
   # And the page contains "L'utilisateur external@example.com a été invité à rejoindre la liste de discussion"

  # As the external member
  Scenario: I click the link in the mail
    Given "external@example.com" was invited to join the mailing list named "my_mailing_list" with token "some_token"
    When I visit "/ml/lists/invitations/some_token"
    Then the page contains "my_mailing_list"
    And the page contains "J'accepte les CGU"
    And the page contains a button "Rejoindre le groupe"

 Scenario: I accept the invitation without accepting CGUs
    Given "external@example.com" was invited to join the mailing list named "my_mailing_list" with token "some_token"
    When I visit "/ml/lists/invitations/some_token"
    And I click "Rejoindre le groupe" button
    Then the page contains "my_mailing_list"
    Then the page contains "Vous devez valider les CGU pour continuer"
    And "external@example.com" remains subscribed to the mailinglist "my_mailing_list" as an inactive external member
#
  Scenario: I accept the invitation accepting CGUs
    Given "external@example.com" was invited to join the mailing list named "my_mailing_list" with token "some_token"
    When I visit "/ml/lists/invitations/some_token"
    And I check box "accept_cgu"
    And I click "Rejoindre le groupe" button
    Then the page contains "my_mailing_list"
    And "external@example.com" becomes subscribed to the mailinglist "my_mailing_list" as an active external member
    And the token "some_token" is used

  Scenario: Admin cancel the invitation before user accept it
    Given "external@example.com" was invited to join the mailing list named "my_mailing_list" with token "some_token"
    When external member "external@example.com" is deleted from "my_mailing_list"
    And I visit "/ml/lists/invitations/some_token"
    Then the page contains "Ce lien a déjà été utilisé ou n'est plus valable."
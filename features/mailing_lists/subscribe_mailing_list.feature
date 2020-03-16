Feature: Register to a Mailinglists

  A user should be able to subscribe to a MailingLists

  Background:
    Given I am logged in with a gadz account with email "my_address@gadz.org"

  Scenario: I subscribe to a public lists
    Given there is a public mailing lists named "Fun Public Group"
    And I visit to mailing lists index
    When I click "M'inscrire" button in "[data-list-name='Fun Public Group']"
    Then I becomes a member of "Fun Public Group"
    And "my_address@gadz.org" receive an email with object "Vous avez rejoint le groupe de discussion \"Fun Public Group\""
    And this email contains a text matching /\/ml\/lists\/[0-9]+/leave\/[0-9]+/

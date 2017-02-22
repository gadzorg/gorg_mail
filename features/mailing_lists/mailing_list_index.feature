Feature: Display available MailingLists

  A user should see the mailing lists he subscribed and available mailing lists

  Background:
    Given I'm a Gadz member
    And I'm logged in

  Scenario: I see unsubscribed public lists
    Given there is a public mailing lists named "Fun Public Group"
    When I visit to mailing lists index
    Then "not_joined_lists" contains "Fun Public Group"
    And the page has button "M'inscrire"

  Scenario: I see unsubscribed group-only mailing lists I'm in
    Given I'm in group "76dd86c5-02f9-4b21-aee4-5d4622a44995"
    And there is a group-only mailing lists named "Fun Private Group ML" for group "76dd86c5-02f9-4b21-aee4-5d4622a44995"
    When I visit to mailing lists index
    Then "not_joined_lists" contains "Fun Private Group ML"
    And the page has button "M'inscrire"

  Scenario:  I don't see unsubscribed group-only mailing lists I'm not in
    Given there is a group named "Boring Private Group"
    And there is a group-only mailing lists named "Boring Private Group ML" for group "76dd86c5-02f9-4b21-aee4-5d4622a44995"
    When I visit to mailing lists index
    Then "not_joined_lists" does not contain "Boring Private Group ML"

  Scenario: I don't see unsubscribed closed mailing lists I'm not in
    Given there is a closed mailing lists named "Secret ML"
    When I visit to mailing lists index
    Then "not_joined_lists" does not contain "Secret ML"

  Scenario: I see subscribed public lists
    Given I subscribed to a public mailing lists named "Fun Public Group"
    When I visit to mailing lists index
    Then "joined_lists" contains "Fun Public Group"
    And the page has button "Me desinscrire"

  Scenario:  I see subscribed group-only mailing lists I'm in
    Given I'm in group "76dd86c5-02f9-4b21-aee4-5d4622a44995"
    And I subscribed to a group-only mailing lists named "Fun Private Group ML" for group "76dd86c5-02f9-4b21-aee4-5d4622a44995"
    When I visit to mailing lists index
    Then "joined_lists" contains "Fun Private Group ML"
    And the page has button "Me desinscrire"


  Scenario: I see subscribed closed mailing lists I'm not in
    Given I subscribed to a closed mailing lists named "Secret ML"
    When I visit to mailing lists index
    Then "joined_lists" contains "Secret ML"
Feature: Unsbscribe a mailinglist as an external member
  #In step definitions 'I' refers to @me

  Background:
    Given I have an account with email "my_address@example.com"
    And I have a primary source email "me@gadz.org"
    And I have a redirection to "my_other_address@example.com"
    And I subscribed to a closed mailing lists named "gadz_list"
    And I subscribed to a public mailing lists named "public_list"
    And I subscribed to a public mailing lists named "other_public_list"
    And "me@example.com" is subscribed to the public mailinglist "some_ml" as an external member
    And "me@example.com" is subscribed to the closed mailinglist "other_ml" as an external member

# Faut il une protection contre le spam ?
  Scenario Outline: I confirm my mail address as an external user
    When I visit "/unsubscribe"
    And I fill "email" with <email_adress>
    And I click "Vérifier mon identité" button
    Then a token is created
    And <email_adress> receive an email with object "Confirmez votre adresse mail pour vous désabonner"
    And this email contains a link to use the token

    Examples:
    |                   email_adress |
    |       "my_address@example.com" |
    |                  "me@gadz.org" |
    | "my_other_address@example.com" |
    |               "me@example.com" |

  Scenario: "me@example.com" list unsubscribable mailinglists as an external user
    Given there is the unsubscribe token "some_token" created for email address "me@example.com"
    When I visit "/unsubscribe/some_token"
    Then "mailinglists" contains "some_ml"
    And "mailinglists" contains "other_ml"
    And the page has button "Tout cocher"
    And the page has button "Tout décocher"

  Scenario: "me@example.com" unsubscribe as an external user
    Given there is the unsubscribe token "some_token" created for email address "me@example.com"
    When I visit "/unsubscribe/some_token"
    And I check box "unsubscribe[some_ml]"
    And I click "Me désinscrire" button
    Then "me@example.com" is not an external member of "some_ml"
    And "me@example.com" is an external member of "other_ml"

  Scenario Outline: I list unsubscribable mailinglists for me
    Given there is the unsubscribe token "some_token" created for email address <email_adress>
    When I visit "/unsubscribe/some_token"
    Then "mailinglists" contains "gadz_list"
    And "mailinglists" contains "public_list"
    And "mailinglists" contains "other_public_list"
    And the page has button "Tout cocher"
    And the page has button "Tout décocher"

    Examples:
    |                   email_adress |
    |                  "me@gadz.org" |
    |       "my_address@example.com" |
    | "my_other_address@example.com" |

  Scenario Outline: I unsubscribe
    Given there is the unsubscribe token "some_token" created for email address <email_adress>
    When I visit "/unsubscribe/some_token"
    And I check box "unsubscribe[gadz_list]"
    And I check box "unsubscribe[public_list]"
    And I click "Me désinscrire" button
    Then I am not a member of "gadz_list"
    And I am not a member of "public_list"
    And I am a member of "other_public_list"

    Examples:
    |                   email_adress |
    |       "my_address@example.com" |
    |                  "me@gadz.org" |
    | "my_other_address@example.com" |
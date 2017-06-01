Feature: I can manage my mailinglist subscriptions from a dashboard, as a non-gadz account

  Background:
    Given I am logged in with a non-gadz account
    And the following mailing lists exists :
      | inscription_policy |           name  |
      | open               |    My public Ml |
      | closed             |   My private Ml |
      | conditional_gadz   |    Gadz Only Ml |

  Scenario: I can't access the dashboard
    When I visit "/mailinglists"
    Then I should be authorized to access the ressource

  Scenario: I can see public mailinglists
    When I visit "/mailinglists"
    Then "not_joined_lists" contains "My public Ml"
    And  "not_joined_lists" does not contain "Gadz Only Ml"
    And  "not_joined_lists" does not contain "My private Ml"

  @javascript
  Scenario: I join a public mailing list
    When I visit "/mailinglists"
    And I click "M'inscrire" button in "li[data-list-name='My public Ml']"
    Then "joined_lists" contains "My public Ml"
    Then "not_joined_lists" does not contain "My public Ml"
    And I becomes a member of "My public Ml"

  @javascript
  Scenario: I unsub from a public mailing list
    When I visit "/mailinglists"
    And I click "M'inscrire" button in "li[data-list-name='My public Ml']"
    And I click "Me desinscrire" button in "li[data-list-name='My public Ml']"
    Then "joined_lists" does not contain "My public Ml"
    Then "not_joined_lists" contains "My public Ml"
    And I am no longer a member of "My public Ml"


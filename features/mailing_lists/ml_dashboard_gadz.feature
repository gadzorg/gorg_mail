Feature: I can manage my mailinglist subscriptions from a dashboard, as a gadz account

  Background:
    Given I am logged in with a gadz account with email "my_address@gadz.org"
    And the following mailing lists exists :
      | inscription_policy |           name  |
      | open               |    My public Ml |
      | closed             |   My private Ml |
      | conditional_gadz   |    Gadz Only Ml |

  Scenario: I access the dashboard
    When I visit "/mailinglists"
    Then I should be authorized to access the ressource

  Scenario: I see public and Gadz only mailinglists
    When I visit "/mailinglists"
    Then "not_joined_lists" contains "My public Ml"
    Then "not_joined_lists" contains "Gadz Only Ml"
    Then "not_joined_lists" does not contain "My private Ml"

  @javascript
  Scenario: I join a public mailing list
    When I visit "/mailinglists"
    And I click "M'inscrire" button in "li[data-list-name='My public Ml']"
    Then "joined_lists" contains "My public Ml"
    Then "not_joined_lists" contains "Gadz Only Ml"
    Then "not_joined_lists" does not contain "My public Ml"
    And I becomes a member of "My public Ml"

  @javascript
  Scenario: I join a gadz Only mailing list
    When I visit "/mailinglists"
    And I click "M'inscrire" button in "li[data-list-name='Gadz Only Ml']"
    Then "joined_lists" contains "Gadz Only Ml"
    Then "not_joined_lists" contains "My public Ml"
    Then "not_joined_lists" does not contain "Gadz Only Ml"
    And I becomes a member of "Gadz Only Ml"


  @javascript @wip
  Scenario: I visit a public mailinglist show page
    Given I subscribed to the mailing list named "My public Ml"
    When I visit "/mailinglists"
    And I click "Consulter" button in "li[data-list-name='My public Ml']"
    Then "members" contains "Membres"
  @wip
  Scenario: I visit a private mailinglist show page
    Given I subscribed to the mailing list named "My private Ml"
    When I visit "/mailinglists"
    And I click "Consulter" button in "li[data-list-name='My private Ml']"
    Then "members" contains "Membres"
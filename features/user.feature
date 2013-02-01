Feature: Jooxe Users
    In order to test the Jooxe View class
    As a software tester
    I want to be able to test the Jooxe View class with users

Scenario: Loading the users index page
    Given the following users:
      | account_name | mail  |
      | jim | jim@example.com  |
      | jane | jane@example.com |
      | bob | bob@example.com  |
    When I visit the users index page
    Then I should see the following users:
      | account_name | mail  |
      | jim | jim@example.com  |
      | jane | jane@example.com |
      | bob | bob@example.com  |


Scenario: create a new user
    Given I visit the new user page
    When I fill in "Account Name" with "name 1"
    And I fill in "Mail" with "fred@example.com"
    And I press "Create"
    Then I should see the text "fred@example.com"
  
Scenario: Viewing a single user
    Given the following users:
      | account_name | mail  |
      | jim | jim@example.com  |
      | jane | jane@example.com |
      | bob | bob@example.com  |
    When I visit the page for user 1
    Then I should see the text jim@example.com
    And I should not see the text jane@example.com
 
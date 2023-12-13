@api @javascript @login
Feature: Log in using normal procedures

  As a registered user I should be able to
  - Log in

  Background:
    Given users:
      | name      | mail                  |
      | eirik@example.com | eirik@example.com |

  Scenario: A user can log in
    Given I am logged in as "eirik@example.com"
    Then I visit "/"

@site-check @api
Feature: Site check
  Scenario: An anonymous user can access the front page
    Given I am an anonymous user
    When I am on the homepage
    Then the response status code should be 200

  Scenario: An anonymous user can access the user login page
    Given I am an anonymous user
    When I go to "user/login"
    Then the response status code should be 200

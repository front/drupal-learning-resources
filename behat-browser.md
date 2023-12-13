# Behat tests that is using a browser

## Prerequisites

This assumes you have followed and understood the [intro to behat](behat.md)

## Install dependencies

For the easiest out of the box experience, we are going to use ddev to install the software needed to automate browser navigation. We start by running the following command in the project folder from the first part of the guide (in that example, the folder was called `learn`). Here we are running the command outside the running container, so on the host machine:

```
$ ddev get ddev/ddev-selenium-standalone-chrome
Installing ddev/ddev-selenium-standalone-chrome:1.0.4 
Downloading https://api.github.com/repos/ddev/ddev-selenium-standalone-chrome/tarball/1.0.4 
1.0.4_3487704640.tar.gz 4.99 KiB / ? [------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------=--------]  51.13% 0s 

Installing project-level components: 
👍 docker-compose.selenium-chrome.yaml 
👍 config.selenium-standalone-chrome.yaml 

Installed DDEV add-on ddev/ddev-selenium-standalone-chrome, use `ddev restart` to enable. 
Please read instructions for this add-on at the source repo at
https://github.com/ddev/ddev-selenium-standalone-chrome
Please file issues and create pull requests there to improve it. 
Installed ddev-selenium-standalone-chrome:1.0.4 from ddev/ddev-selenium-standalone-chrome 
```

As you can see, this now requires us to run `ddev restart`. So let's do that:

```
ddev restart
```

Now let's ssh into the container to run the next commands.

```
ddev ssh
```

First we are going to just download an example test from the assets directory in this repo:

```
wget https://raw.githubusercontent.com/front/drupal-learning-resources/main/assets/login.feature -O tests/features/login.feature
```

If you look at that file, it contains a tag called `javascript` you can see in the top of the file contents. The file contents are included here for reference:

```
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
```

This means behat will run it in a browser. Let's start by trying to run it:

```
./vendor/bin/behat tests/features/login.feature
```

This will hopefully output something like this:

```
@api @javascript @login
Feature: Log in using normal procedures
  
  As a registered user I should be able to
  - Log in

  Background:    # tests/features/login.feature:7
    Given users: # Drupal\DrupalExtension\Context\DrupalContext::createUsers()
      | name              | mail              |
      | eirik@example.com | eirik@example.com |

  Scenario: A user can log in                   # tests/features/login.feature:12
    Given I am logged in as "eirik@example.com" # Drupal\DrupalExtension\Context\DrupalContext::assertLoggedInByName()
    Then I visit "/"                            # Drupal\DrupalExtension\Context\MinkContext::assertAtPath()

1 scenario (1 passed)
3 steps (3 passed)
0m1.27s (12.01Mb)
eirik@learn-web:/var/www/html
```

So it passed. But we have no indication if it was run in a browser or what on earth it did. Wouldn't it be useful if we could see it running? Well guess what? We can!

Depending on your configuration, you should be able to visit something like `http://learn.ddev.site:7910/` in your browser. You should be greeted with a screen that has a button saying "Connect". Click this one. The password here should be `secret`.

Now, with this browser window open. Let's try to run the test again and see what happens:

![behat-browser](https://github.com/front/drupal-learning-resources/assets/865153/b1607ba3-af64-4523-8419-aea5dfbb70ec)

As you can see, it runs very fast so it's hard to see. But we are going to the login form, filling the credentials, and logging in. Proceeding to go to the homepage.

At this point there are also some tricks you can use to debug or even write your tests. One of my favorites here are the step definition "Then I break". Let's see what that does. If we change the login test to be something like this:

```diff
diff --git a/tests/features/login.feature b/tests/features/login.feature
index 9074fd2..0cbc4d3 100644
--- a/tests/features/login.feature
+++ b/tests/features/login.feature
@@ -11,4 +11,5 @@ Feature: Log in using normal procedures
 
   Scenario: A user can log in
     Given I am logged in as "eirik@example.com"
+    Then I break
     Then I visit "/"
```

Then the execution of the test will stop at that point, and we can use that to click around as the logged in user, and probably find useful things like selectors in the page or names of buttons:

![break-example](https://github.com/front/drupal-learning-resources/assets/865153/c7537a1b-d8d0-4e1e-bfc2-eb34ba96f35d)


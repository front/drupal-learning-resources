# As a Drupal developer, I want to learn how to set up automated integration tests (BDD) with Behat

Here, we are going to create a Drupal site. Create a simple custom module, and create some integration tests for it.

## Set up Drupal

You can do this any way you want. But since we are doing everything from scratch here, let's start by setting up an environment and installing Drupal.

### Set up a ddev project

In a new folder (for my example I called it learn) let's configure ddev:

```
$ ddev config
Creating a new ddev project config in the current directory (/home/eirik/Sites/learn) 
Once completed, your configuration will be written to /home/eirik/Sites/learn/.ddev/config.yaml
 
Project name (learn): 

The docroot is the directory from which your site is served.
This is a relative path from your project root at /home/eirik/Sites/learn 
You may leave this value blank if your site files are in the project root 
Docroot Location (current directory): web
Warning: the provided docroot at /home/eirik/Sites/learn/web does not currently exist. 
Create docroot at /home/eirik/Sites/learn/web? [Y/n] (yes): 
Created docroot at /home/eirik/Sites/learn/web. 
Found a php codebase at /home/eirik/Sites/learn/web. 
Project Type [backdrop, craftcms, drupal10, drupal6, drupal7, drupal8, drupal9, laravel, magento, magento2, php, shopware6, typo3, wordpress] (php): drupal10
No settings.php file exists, creating one 
Configuration complete. You may now run 'ddev start'. 
```

As you can see I set the docroot to `web` (since I know that's what default Drupal does) and the project type to `drupal10`.

I am also just creating a Drupal 10 project from scratch then:

```
ddev composer create drupal/recommended-project
``` 

After the project is started I just install a default Drupal install:

I ssh into the container so it's easier with the following commands

```
ddev ssh
```

I also add drush in here, since it's useful

```
composer require drush/drush
```

Now let's install drupal.

```
drush site:install -y
```

Now it's time to require some behat packages. Since we are using Drupal 10, we need to use version 5 of the Drupal extension.

```
composer require drupal/drupal-extension ^5-rc --dev
```

That would hopefully give us some new packages. Now it's time to add a behat.yml.dist file. We can do that based on [the one in the assets directory in this repo](assets/behat.yml), by running this command:

```bash
wget https://raw.githubusercontent.com/front/drupal-learning-resources/main/assets/behat.yml -O behat.yml.dist
```

Some of these values we will come back to, but this should be more than enough to write the first test.

According to this file, our tests should be located in `tests/features`. So let's start by creating that:

```
mkdir -p tests/features
```

And now let's create a simple test that checks that the site is working. Let's create a file called `check.site.feature` in there. `.feature` is the file extension we will be using, and the syntax will be [the gherkin language](https://docs.behat.org/en/latest/user_guide/gherkin.html). Create that file inside of the folder `tests/features` and use [the file from the assets directory](assets/check.site.feature) as the contents:

```
wget https://raw.githubusercontent.com/front/drupal-learning-resources/main/assets/check.site.feature -O tests/features/check.site.feature
```

This syntax is hopefully pretty easy to understand, but what this means is we have 2 tests: One that visits the frontpage and checks if the status code is 200. And another one checks if the status code is 200 on the user/login page. Not super useful, but not super unuseful either.

Now let's try to run it:

```
./vendor/bin/behat
```

The output should look something like this:

```
@site-check @api
Feature: Site check

  Scenario: An anonymous user can access the front page # tests/features/check.site.feature:3
    Given I am an anonymous user                        # Drupal\DrupalExtension\Context\DrupalContext::assertAnonymousUser()
    When I am on the homepage                           # Behat\MinkExtension\Context\MinkContext::iAmOnHomepage()
    Then the response status code should be 200         # Behat\MinkExtension\Context\MinkContext::assertResponseStatus()

  Scenario: An anonymous user can access the user login page # tests/features/check.site.feature:8
    Given I am an anonymous user                             # Drupal\DrupalExtension\Context\DrupalContext::assertAnonymousUser()
    When I go to "user/login"                                # Behat\MinkExtension\Context\MinkContext::visit()
    Then the response status code should be 200              # Behat\MinkExtension\Context\MinkContext::assertResponseStatus()

2 scenarios (2 passed)
6 steps (6 passed)
0m0.13s (6.94Mb)
``` 

:tada: It works!

Let's just double check that it's actually testing the right thing. We are going to do that by introducing an error in the test. Something like this, for example: 

```diff
diff --git a/tests/features/check.site.feature b/tests/features/check.site.feature
index d14b0ea..fdaa0e9 100644
--- a/tests/features/check.site.feature
+++ b/tests/features/check.site.feature
@@ -7,5 +7,5 @@ Feature: Site check
 
   Scenario: An anonymous user can access the user login page
     Given I am an anonymous user
-    When I go to "user/login"
+    When I go to "stupid/nonexisting/path"
```

Now let's run it again:

```
$ ./vendor/bin/behat 
@site-check @api
Feature: Site check

  Scenario: An anonymous user can access the front page # tests/features/check.site.feature:3
    Given I am an anonymous user                        # Drupal\DrupalExtension\Context\DrupalContext::assertAnonymousUser()
    When I am on the homepage                           # Behat\MinkExtension\Context\MinkContext::iAmOnHomepage()
    Then the response status code should be 200         # Behat\MinkExtension\Context\MinkContext::assertResponseStatus()

  Scenario: An anonymous user can access the user login page # tests/features/check.site.feature:8
    Given I am an anonymous user                             # Drupal\DrupalExtension\Context\DrupalContext::assertAnonymousUser()
    When I go to "stupid/nonexisting/path"                   # Behat\MinkExtension\Context\MinkContext::visit()
    Then the response status code should be 200              # Behat\MinkExtension\Context\MinkContext::assertResponseStatus()
      Current response status code is 404, but 200 expected. (Behat\Mink\Exception\ExpectationException)

--- Failed scenarios:

    tests/features/check.site.feature:8

2 scenarios (1 passed, 1 failed)
6 steps (5 passed, 1 failed)
0m0.26s (6.95Mb)
```

:rocket: It totally works!

Next: [Behat with a browser](behat-browser.md)

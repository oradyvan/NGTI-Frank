What is Frank?
----

Frank is 'Selenium for native iOS apps'. It allows you to write automated acceptance tests which verify the functionality of your native iOS app.

Learn More
----

[The Frank website](http://www.testingwithfrank.com) is your best resource. You'll find documentation, screencasts, video recordings of presentations, and links to further resources.


Getting Started
---------------

Getting started is easy. You just need to install a ruby gem, create a new target for your app in XCode, and start writing cucumber tests.

Building from source
----
After cloning the repo on github, run `git submodule update --init --recursive` to pull in the 3rd party submodules Frank uses, and then run `rake` to build the Frank library. You can also build the library using XCode.


Contributions welcome!
------------

We're always happy to accept documentation improvements, bug fixes and new features. Please fork this repo and
send a pull request. Feedback, suggestions and questions are always most welcome on the [mailing list](http://groups.google.com/group/frank-discuss).

NGTI Setup for Frank Development
----
The sources of original Frank project and of its submodules have been modified slightly to fit the specific needs of our iO app. We assume in the future development of iO app there still will be need of continuing Frank modifying, so here is the description of how to set up your local environment for this.

After cloning this repo from NGTI project and following the steps described in section **Building from source** you need to do the following:

1. Our version of gem has name `ngti-frank-cucumber`. It may potentially conflict with the original gem, `frank-cucumber` so please uninstall it first with the command:

   `sudo gem uninstall frank-cucumber`

2. Gem file is being deployed to a separate web repository that is only accessible from inside of our company network. To set it up, issue the commands:

    `sudo gem install geminabox`

    `gem sources --add http://BuilderBot.cp11.ngti.nl:9292`

3. To build new gem file, in Terminal go to your Frank working copy and issue the command:

   `rake build_for_release`

4. After the build was successful, `cd gem` and issue the command:

   `gem build frank-cucumber.gemspec`
   
   As the result of success you should see a file named `ngti-frank-cucumber-X.Y.Z.gem` created in current directory.

5. In order to deploy the just build gem to our web repository, issue the command:

   `gem inabox ngti-frank-cucumber-X.Y.Z.gem`

   *When you issue this command for the very first time, it will ask you of the host. Please input `http://BuilderBot.cp11.ngti.nl:9292`*

6. Finally, the gem is published and is available to be downloaded by everyone interested. The command for this is:

   `sudo gem update ngti-frank-cucumber`

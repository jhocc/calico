# Calico: Connecting Parents and Caseworkers

Calico is a web-based, responsive messaging app designed for birth and foster parents, and case managers. It enables parents to locate nearby Foster Family Agencies (FFA), identify agency case managers and engage in dialogue with these professionals and other stakeholders.   Its chief goal is to facilitate communication about children in out-of-home care.

To get started, parents go to [http://calicoapp.co] (http://calicoapp.co) and create a profile with a California zipcode. Once logged in, users are taken to their My Messages page with a welcome message with details about how to locate FFAs and communicate with caseworkers.  Users link to FFA profiles with additional information and can then start a conversation with a caseworker.   Users can also reset passwords, update profiles, and upload profile pictures. 

Calico was developed in response to the State of California’s ADPQ vendor pool RFI #75001.

## Calico is: 

* Intuitive, using familiar web conventions
* Mobile first and responsive — supporting any device 
* Designed to evolve to additional user roles (e.g., foster children).  

Calico reflects Case Commons’ years of experience building child welfare software with a user-centered, agile process.  We involved users early and often in user-centered evaluation, and iteratively released working code.   Our approach is consistent with both the ADPQ RFI requirements and the [US Digital Services Playbook] (https://playbook.cio.gov).

## Team Labor Categories

The Product Manager (PM), Nicole Reece  also served as Project Manager and proxy Product Owner for this project.  Nicole had full authority and responsibility to build the Minimum Viable Product (MVP).  Her team included:  

* Pierre Klein, Interaction Designer, User Researcher, Usability Tester
* Pema Geyleg, Technical Architect, DevOps Engineer
* Nate Jones, Front End Web Developer
* Jimmy Chao,  Front End Web Developer
* Oana Tararache, Back End Web Developer
* Johny Ho, Back End Web Developer
* Chuck Kalmanek, Delivery Manager

## Agile and User-Centered Design Process

* The project started with research to understand the business need  with (proxy) business stakeholders.  The PM then conducted secondary research to understand the California context, including legal requirements, Continuum of Care Reform and the Quality Parenting Initiative.  

* The PM and Interaction Designer brainstormed/sketched , wrote story cards and held a visual style session on product values and “inspiration” products.

* The PM and UX team then interacted iteratively with users.  Initial meetings focused on product and problem definition, and potential solutions. Follow-up meetings advanced the product concept through human-centered design activities: 

  * Interviews  to identify specific needs and potential features 
  * Live wireframing sessions 
  * Usability testing with live prototypes 
  * Design peer review sessions

* The PM created and groomed the Tracker backlog and facilitated the [Project Inception] (http://case-book.co.s3-website-us-east-1.amazonaws.com/InceptionCalico.pdf) with the team. Feature priorities, milestones and designs were refined, as engineers provided input and discussed technology strategies, complexity, sequencing and velocity.

* The engineering team worked in three tracks: the DevOps engineer established infrastructure; a second team built the user profile and Resource Finder; a third built the messaging page. The technical architect guided software design decisions and conducted code reviews. The team followed agile best practices, including Test Driven Development, paired programming, continuous integration and code review.  Before pushing code to master, developers confirmed all tests were green.  Once code was pushed, the PM conducted acceptance testing based on defined Acceptance Criteria.

* The team used several communication tools: daily stand-ups; [Slack] (https://slack.com) for real-time messaging; [Pivotal Tracker] (https://pivotaltracker.com) for Agile project management; [Github] (https://github.com) for version control and code review.

* The delivery manager helped define the roadmap and develop user stories, facilitate team communication, prioritize/unblock issues and confirm quality.

* The Tracker Backlog and Icebox were used to hold stories for future consideration. 

## Calico Open Source Technologies

[Ruby on Rails] (http://rubyonrails.org), a rapid-development web application framework with strong community support. 
[PostgreSQL] (https://www.postgresql.org), an enterprise-grade database. 

[React] (https://facebook.github.io/react/) and [Bootstrap] (http://getbootstrap.com), front-end framework and design style guide, chosen for their simple declarative programming model,  support for the [U.S. Web Design Standards] (https://standards.usa.gov/) and aspects of the Web Content Accessibility Guidelines. 

[Gulp] (http://gulpjs.com), to automate Javascript builds.  

[Devise] (https://github.com/plataformatec/devise), a modular authentication platform.  We followed the HTTPS-only standard to provide data privacy.  

The Socrata [Open Data API] (https://github.com/socrata/soda-ruby) to access CHHS data.   

[faker] (https://github.com/stympy/faker), to seed synthetic caseworker data.  

[Nginx] (https://wwww.nginx.com), a lightweight web proxy, and [puma] (http://puma.io), a fast, concurrent application server. 
  
[Rspec] (https://github.com/rspec/rspec-rails), for unit and feature tests.
[Selenium] (http://seleniumhq.org) and [Capybara] (https://github.com/jnicklas/capybara) to simulate user interactions. 
[Solano] (https://solanolabs.com), for continuous integration.

Calico was built using [Docker] (https://www.docker.com), with separate Docker images for nginx, PostgreSQL and the Calico app.  Calico was deployed on OS X for development; the production application is deployed on the [Heroku] (https://www.heroku.com) PaaS.  

[New Relic] (https://newrelic.com) and [Pingdom] (https://www.pingdom.com), for continuous application monitoring.

## Deployment Instructions (Development Environment)

Dependencies:  
* A Github account  
* A computer running Mac OS X 10.9.5+ with Xcode Version 6.1.1+  
* Download and install [Virtualbox 5.0.20] (http://download.virtualbox.org/virtualbox/5.0.20/VirtualBox-5.0.20-106931-OSX.dmg)  
* Download and install [Docker Toolbox version 1.11.2] (https://github.com/docker/toolbox/releases/download/v1.11.2/DockerToolbox-1.11.2.pkg)  

To install and run Calico, execute these commands:

    $ git clone git@github.com:Casecommons/calico.git
    $ cd calico
    $ bin/setup-virtualmachine
    $ bin/run-app-in-container --env development

Access Calico in your browser using the IP address output by the last command.  

Setting up and deploying Calico in production in Heroku is documented on the [wiki] (https://github.com/Casecommons/calico/wiki/Deploying-in-Heroku).  

## Further Information

* Project stories are in [Pivotal Tracker] (https://www.pivotaltracker.com/n/projects/1593991)
* Additional details about our process and process artifacts are in the project [wiki] (https://github.com/Casecommons/calico/wiki)
* For bugs, questions, or suggestions, please use [Github Issues] (https://github.com/Casecommons/Calico/issues).

## Reviewer Testing

Reviewers can sign up on the landing page, create a profile, and message a fictitious caseworker.   Zip code 93711 (among others) contains FFAs.   To verify that Calico messaging functionality works as advertised,  reviewers can log in to a caseworker account using the password “Calico2016!”.   For example, to log in as caseworker Devan Spinka (Kids Kasa Foster Care Inc in zip code 93711), log in using userid Devan.Spinka@calicoapp.co with password “Calico2016!”

## License

Copyright (c)2016 Case Commons, Inc.
Calico is available under the GNU Affero General Public License, available at [https://www.gnu.org/licenses/agpl-3.0.en.html] (https://www.gnu.org/licenses/agpl-3.0.en.html). 


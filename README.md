# Calico: Connecting Parents and Caseworkers

Calico is a web-based, responsive messaging app designed for parents (birth and foster), foster kids and case managers to facilitate communication about children in out of home care.

Some product points to highlight:
 - based upon web standards, to facilitate use by public without training
 - mobile first: designed to ensure site is easiest to use on mobile phone.
 - anyone with email can create account, in future, will only require mobile phone # (given birth parents and foster parents may not use email heavily)
 - designed to facilitate conversations and keep track of info to address 'games of telephone', forgetting/losing info
 - anyone can use, foster kids, county case managers, foster parents, etc.  Initial target audience is birth parent + FFA case manager
 -

## About Calico

Calico was built using Case Commons' agile development process, in response to the State of California's AGPQ solicitation.   

1. The Calico team was led by Nicole Tecco Reece (Product Manager).  Team members: 
	* Pierre Klein (UX) 
	* Pema Geyleg (Technical Architect)
	* Nate Jones (Full stack developer)
	* Jimmy Chao (Full stack developer)
	* Oana Tararche (Full stack developer)
	* Johny Ho (Full stack developer)
	* Chuck Kalmanek (Delivery Manager)
2. Describe user research and testing
	* Began with interviewing business stakeholder (proxy) to understand the business need for the work
	* Conducted secondary research -- legal requirements, Continuum of Care Reform, Quality Parenting Initiative.
	* Began to prepare the Definition of Ready (pre-cursor to Inception): design brainstorm, sketch session (PM + UX)
	* Wrote initial story cards for possible features (PM)
	* Met with end users (2) for feedback on the initial product definition (verbal), problem set and potential solutions (sketch/wireframe version)
	* Recorded feature ideas, comments, etc.
	* Visual style session (PM + UX) to review product values, inspiration products
	* Created initial set of stories and prioritized backlog
	* Review visual style options
	* Created stylized mockups
	* Conducted walkthru of user flows with static mockups for stakeholders
	* Gathered feedback, revised mockups
	* Synthesized input from end users + stakeholders into initial Definition of Ready, second version of Backlog
	* Inception held with entire team - revise feature priorities and milestones, given engineering input, ideas and estimates of complexity/feasibility
	* Development of features begins (2 tracks)
	* Acceptance of working software
	* Revising and adding stories as we learn more (iteration)
	* Demo of working software to end users (3), gather questions and feedback
	* Identify design problem for usability testing: Discoverability of messaging
	* Usability testing to be conducted twice (Friday/weekend of 6/3) and early week 6/6. NOTE: please upload some or all videos from usertesting.com to the github repo
	* Backlog (for final days and post-deadline) re-prioritized based upon usability testing responses
	* Roadmap (post go live) updated to demonstrate the directions we could take the product upon further feedback from users.
3. Calico was developed using Ruby on Rails, Bootstrap, React, Gulp, PostgreSQL, and other cool tech.
4. Unit and feature tests were developed in Rspec, and automated using [Solano] (https://www.solanolabs.com/) for continuous integration.
5. We used the open source [nginx] (https://www.nginx.com/) web proxy, and [puma] (http://puma.io/) application server.
6. [New Relic] (https://newrelic.com/) provides continuous application monitoring

## How To Use Calico?
Public users can go to beta-calico.herokuapp.com to sign up for a Calico account.  Create a profile with a CA zipcode and find FFAs in your area and case managers that work for those agencies with whom you can interact.
Message the help user on your messages page with any questions.

## How to Deploy Calico?

* System dependencies
* Configuration
* Database creation
* Database initialization
* How to run the test suite
* Services (job queues, cache servers, search engines, etc.)
* Deployment instructions


## Full Documentation

* Project stories are in [Pivotal Tracker] (https://www.pivotaltracker.com/n/projects/1593991)
* Design details are [here] (https://github.com/Casecommons/calico/docs/design)
* Etc. 

## Feedback

For bugs, questions, or suggestions, please use [Github Issues] (https://github.com/Casecommons/Calico/issues).

## License

Copyright 2016 Case Commons, Inc.

Licensed under the Apache License, Version 3.0 (the "license").  You may not use this file except in compliance with the License.   


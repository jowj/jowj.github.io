+++
title = "tvm at a new company"
date = 2020-03-29
author = ["josiah"]
draft = false
tags = ["security"]
+++

## no new problems {#no-new-problems}

i recently started a new job and am faced with the usual: "please set up our scanners and Make Us Secure", "What Do These Alerts Mean", etc etc. i keep thinking about the scanning / threat and vulnerability management (TVM) aspect, so i want to write about that. here are a list of questions that i've been asking myself, along with some possible answers.


### using an existing scanning install or starting over {#using-an-existing-scanning-install-or-starting-over}

it may be reasonable to nuke an install if:

-   data existing in the install is massively out of date / bad / for some reason is fucked up data
-   data existing in the install doesn't tell you anything useful; 'these ips are alive' isn't useful.

times when you definitely should not nuke an install:

-   if the install is tied to existing agents; losing those agent connections would be a mistake

those are really the only hard constraints i can think of. everything else seems pretty grey


### are naming schemes important enough to spend time on {#are-naming-schemes-important-enough-to-spend-time-on}

hard yes. some of the names in use at my new place are frankly _hilarious_. and bad. "aaah, a scan template called 'corp users', what do you suppo - oh, its for scanning production? of course."

i picked a rough naming scheme template for all objects, and then tweaked it on a per-object-type basis, i.e.:

ProductName - Environment - Geolocation - Data

"search - prod - aus" is pretty straight forward, and then the 'data' field can be where you really express differences between the object classes. if it ends up looking a bit different between object classes, that's ok. the most important thing for naming schemes is consistency to the rules you set. everything else, while still important, is secondary.


### a note on scan schedules {#a-note-on-scan-schedules}

think about what a particular scan is trying to accomplish. if the goal of a scan is to get data from _corporate servers_ then a typical overnight maintenance window makes sense.

if the goal is to get data from _the entire corporate netblock_ then scanning over night is probably really stupid, unless the entire company works during that time. after all, most companies are deploying large laptop fleets that all get taken home at the end of the day! instead, you can tackle this by doing one of these:

-   scan midday, during the work hours, at several different times to catch differently shifted people
-   install agents on all laptop / movable devices

ok, apparently the title should be "two notes on scans". if your goal is to scan sensitive production servers make sure you reach out to the ops team that manages those servers. they should know, you should have a paper trail proving you at least made best efforts to communicate, etc.


### what other things should I check on {#what-other-things-should-i-check-on}

-   is the OS backing the scanning app still getting updates? a lot of people fire and forget scan setups so make sure you're not running shit off some idiots ubuntu 12 install.
-   how much of the infrastructure are we actually scanning? do have blind spots?
    -   if there isn't an ipam then this will be reaaaaal hard to figure out, but its very important.
-   is your license sufficient or will you have to get more approved before you can actually achieve good coverage?
-   are there any non-expiring exceptions?
    -   if so, i recommend nuking them and rebuilding them with at the most a 1 year expiration date; force the company to re-eval once a year if they really want these risks.

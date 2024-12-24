+++
title = "using matrix"
date = 2021-01-23
author = ["josiah"]
draft = false
+++

## introduction {#introduction}

i wanna write about [matrix](https://matrix.org). matrix is a 'new' protocol for decentralized communication. it can be used in a bunch of different ways: from relatively secure, favoring security over ease of use, to very open, favoring ease of use over all other concerns. i tend to use it in the, to me, bare minimum secure configuration and then focusing hard on ease of use.

-   i use e2ee by default
-   i self host my home server
-   i allow federation

i like that i can expect message _content_ privacy and also retain relative ease of use within the same platform. i like that that i can bridge a bunch of services to a single chat client (albeit with some uh, effort / UX trade-offs). i like that there exists reference apps for basically every platform i care about (and basically all the platforms my friends care about).

i really like matrix! but its fair to say there are also problems with it. if you're familiar with matrix at all you [probably heard about their big security fuck up](https://matrix.org/blog/2019/04/11/we-have-discovered-and-addressed-a-security-breach-updated-2019-04-12). earlier, i wrote specifically that you can expect message _content_ privacy, and i'll add here that you cannot expect message _metadata_ privacy (for example, read the [first half of tptacek's reply on HN about contact lists in matrix vs signal](https://news.ycombinator.com/item?id=23108750)). if you self host, there's an even bigger metadata leak than for users who use a larger existing deployment.

i don't wanna convince you that matrix is the protocol of your dreams and you should use it. i just wanna talk about what i'm using it for and maybe help a few folks who ran into some of the same issues i've now solved.


## what am i doing with matrix {#what-am-i-doing-with-matrix}

one of the most fun / worst things about using matrix is that there's a bajillion knobs to tweak; anyone who is using it could have anywhere from 1 to n things different from my setup. here's what i'm doing:


### clients {#clients}

i'm using standard element clients for linux, macOS, iOS, and android.

i'm paying attention to ditto and nio as mobile clients; ditto is made by someone from my city which is rad! its purple, which is rad! nio is _also_ purple, so its also rad. i've played with the weechat-matrix plugin which i think fucking sucks. i've played with mirage, nheko, and a few others that just seemed incomplete. i'm hopeful that the KDE folks get a reasonably good client going with [konversations2](https://blogs.kde.org/2017/09/05/konversation-2x-2018-new-user-interface-matrix-support-mobile-version), but man the last meaningful update i've seen is ages old.

since originally writing ^ that paragraph, the new hotness for KDE clients is [neochat](https://github.com/KDE/neochat); I've only cursorily looked at this but it seems like is heading the right direction. Additionally, Nheko has received a bunch of updates and its one of the desktop linux clients i'll be trying out next. I've also tried the [libpurple plugin](https://github.com/matrix-org/purple-matrix) which is, like, fine I guess. its libpurple. Its not feature complete and it has all the drawbacks of libpurple. I wouldn't use it.


### servers {#servers}

i'm using the [synapse reference server](https://github.com/matrix-org/synapse), written in python. there really aren't other options here at the moment. dendrite (written in go) looks like it will no longer be the successor to Synapse, and instead just be a testing ground. there are a few rust servers being worked on as well, but with less official support.


### bridges {#bridges}


#### slack {#slack}

i'm currently using the [matrix-appservice-slack bridge](https://github.com/matrix-org/matrix-appservice-slack) to bridge my local family and friends slack to my matrix server. this lets me do two things that are important to me:

-   pull in all messages in my public channels to my element instance, which lets me capture logs (slack requires that you pay a non-trivial amount of money per user per month if you want to have access to historic data)
-   talk to my friends in slack from my element client.

the second one makes me feel like i'm 12, using trillian and setting away messages in aim. i love it.

all the data replicates without hiccups between my synapse instance and the slack api, but the presentation of threaded messages in the element clients sucks, frankly. there's [a bug](https://github.com/vector-im/riot-web/issues/2349) filed for it but what the final implementation will look like is anyone's guess.


#### irc {#irc}

the self hosted [matrix-appservice-irc bridge](https://github.com/matrix-org/matrix-appservice-irc) is what most people seem to use. i have used the _hosted_ version on matrix.org before; i hated it. it was great to be able to talk to folks on freenode channels from element, especially given that there is no reasonable irc client on iOS! but the UX is just bad.

i've started the learning process for self hosting it myself and having the bridge treat my existing IRC bouncer as a separate IRC network but that's pretty undocumented. there are no quick and dirty guides about it, and especially since i'm isolating at home all the time now, my drive to solve this iOS irc client problem has cratered. i _have_ verified with the bridge maintainer that what i want to do is possible; its just relatively niche and hasn't been written about.


#### discord {#discord}

i'm using the [mx-puppet-discord](https://github.com/matrix-discord/mx-puppet-discord) bridge for bridging in discord channels. I tried using the [appservice discord](https://github.com/Half-Shot/matrix-appservice-discord) bridge but had a _devil_ of a time getting it to work. mx-puppet-discord works and has (imo) a better user experience for admins, though it does seem pretty finnicky. from what I can tell, more finnicky than the appservice. at least this one i can get to run though!!


#### combining bridges in a single room {#combining-bridges-in-a-single-room}

a thing that i think is fucking _cool_ and also probably a source of some of my problems is: i currently use some of these bridges to create a frankenstein room, that does bidirecitonal send like discord &lt;-&gt; matrix &lt;-&gt; slack; the channel "mothra-fuckers" (shut up) in discord talks to the channel "mothra-fuckers" in  matrix, which is also bridged to "mothra-fuckers" in slack, and anyone in any of those channels can talk to all three platforms! rad!


## avoiding common pitfalls of self hosting {#avoiding-common-pitfalls-of-self-hosting}


### deployment {#deployment}

I think the first thing you should do is eschew configuring synapse and all these bridges on your own. that fucking sucks. use [this set](https://github.com/spantaleev/matrix-docker-ansible-deploy) of ansible roles, these guys are great, continuously update stuff, and provide meaningful changelogs for updates. their documentation is not always lovely, especially about the optional plugins they offer, but have been enough to get me started on solving the problem every time so far.

I forked their repo and periodically update it from `upstream/master` to pull in latest changes when I have time to commit to problem solving any issues. Mostly I don't have problems, but occasionally there are big version updates that have done things like enforce migrations from sqlite to pgsql, or enforced breaking changes with TLS, etc.


### disk space {#disk-space}

one of the things i keep intending to do (and have thus far put off) is move away from relying on raw disks attached to DO droplet and move towards object storage with s3/do spaces/ whatever. This is made easy if you use the previously mentioned set of ansible roles. if you don't do this, you will have to periodically go in and delete old media or add a bunch of new disk space.

if you really must go with disks and not object storage for some reason I recommend that you use external, non OS drives for very Obvious linux admin reasons. Much easier to snapshot / do backups on that sort of thing.


### backups! {#backups}

you should do backups. I haven't figured out a particularly great method here, yet. I do full VM snapshots through my cloud provider, but pulling data out of that environment on a regular basis is something I haven't worked out how to do well. [here](https://github.com/matrix-org/synapse/issues/2046) is a github issue that has some community opinions on what to backup, but there's still no official guidance as far as I know.


## talk to me about matrix! {#talk-to-me-about-matrix}

i really like matrix. i think there's a lot of cool stuff here, and I hope that it continues to improve. if you run into issues with matrix, have some questions about it you aren't sure where to ask, or just wanna chat about it, please talk to me! I've got several years experience running my home server, and all my friends are tired of hearing about matrix lmao. i'm <mailto:me@jowj.net> on email, or @jowj:awful.club on matrix.

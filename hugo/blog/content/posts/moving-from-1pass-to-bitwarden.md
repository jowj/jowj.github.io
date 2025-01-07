---
title: "Moving from 1pass to bitwarden"
date: 2020-03-29
author: ["josiah"]
draft: false
tags: ["security"]
aliases: ["/posts/moving-from-1pass-to-bitwarden.html"]
---

## background {#background}

I've been a 1pass user for a long time. I started with 1pass4; I used it with Mac and Windows endpoints. I've used it on iOS for almost that entire time. I've tried to use other things, like Enpass when I first tried to move to linux as a home os, or LastPass for certain jobs, but frankly none of them hold up.

Since early 2019 i've been running linux at home for everything and that has finally made 1password too painful such that i'm moving off of it. 1pass is a great app and has fantastic compatability for most people but it sucks horribly on linux; until now i've been using 1passX with a 1password.com account. This is the _only_ way to use 1password on a linux os. 1pass4 ran fine under wine, 1pass6 i think could work for some people (but i never got it to).

1passX is a browser extension. This means there's a few things that make me uncomfortable or that downright don't match with my work flow:

1.  having to open a browser on first boot to get access to passwords suck if you also have your browser bring back sessions on launch. everything takes forever to load and you're probably just looking for an entry real quick anyway.
2.  doing anything cryptographically sensitive in a browser extension is a little shady. I trust 1password enough to handle this, but this won't be true of everyone. info:
    -   here's a famous NCC write up about it: <https://www.nccgroup.trust/us/about-us/newsroom-and-events/blog/2011/august/javascript-cryptography-considered-harmful/>
    -   browser extensions that run on every page can be risky enough already; if that browser extension could be tricked to pass instructions to your local vault when it shouldn't (say, send an 'autofill' query over to your vault for 'google.com' when you're actually on 'g00gle.com' or whatever) then a browser bug could lead to your entire vault being exfilled.
3.  swapping quickly between anything i'm working on and my vault sucked because you had to pull up your browser and then move to the vault tab and then login. boo.

because of these issues i started looking for alternatives


## bitwarden {#bitwarden}

since i was looking for a new service anyway I decided to start with bitwarden, which I liked in abstract because I could eventually self host it. I never really moved beyond them; i've kept appraised of other options like keepass, lastpass, remembear, and others, but none of them have all of these things:

-   open source
-   self hosted (as an option)
-   ability to share passwords between accounts
-   good to great mobile experience on iOS <span class="underline">and</span> Android
-   totp support

i've been living on bitwarden for ~1 week at this point and haven't felt any real urge to go back to 1Password. I started with their hosted service so that I didn't have to go through a ton of self hosting work to figure out if I hated it or not. Now that I know that I like it, I can slowly start automating deploys and maintenance tasks and mirror data from their hosted service to my own instance as quickly or slowly as I please.


## the bad {#the-bad}

bad news first.

1.  bitwarden's desktop clients are all electron. I expect there to be vulns discovered here eventually that impact these clients. This is still better than the shared sandbox that is my browser IMO, but that's not an experts opinion, that's just mine.
2.  migrating over from 1pass was both great and more confusing than it needed to be.
    -   TOTP migration from 1pass is REALLY confusing, depending on what kind of bw account you have. I'll talk about it more specifically further down.
    -   You cannot export from 1password.com accounts through 1passX. You _must_ export from a 1pass7 install on a mac or windows machine. REALLY frustrating!
    -   You cannot export Document objects _at all_. You have to manually download them one at a time! Talk about letting your programming abstraction rule the user interface. an obvious mistake on 1pass's part, i hope they fix that eventually.
3.  bitwarden's UI is just not as polished as 1passwords. 1password is so good at that shit.


## totp issue specifics {#totp-issue-specifics}

bitwarden has different kinds of accounts, and there are different bitwarden service hosts that have different features. A free bitwarden account doesn't have TOTP support; that's one of the things they leave beyond a paywall. It seems pretty fair to me.

I created a free bitwarden account on bitwarden.com, exported one of my vaults, imported it into my new bw account, and then started poking around. Pretty much everything came over right away, but I noticed that the TOTP fields were hidden. "Makes sense", I thought, they said that they didn't offer that feature until you pay.

So I fuck around and do some more testing and poking and decide to spend the $10 to get premium bw. When i do that, the TOTP codes on all 2FA entries magically appear! So all that data succesfully gets exported &gt; imported and saved, its just not visible to you. Kind of confusing UX tbqh, but ok makes sense.

The desktop apps, being electron, got cached without showing the TOTP codes; super confusing again, and frustrating. if you need to clear the cache of an electron app you can follow this stack overflow post:
 <https://stackoverflow.com/questions/31446782/how-to-clear-the-cache-data-in-electronatom-shell>


## the cool {#the-cool}

On bitwarden's side there's a lot to be said for their importer from 1password's bespoke format. that just works! rare as hell, even brought in totp codes, great.

bw also handles documents in a sane format; rather than creating 'objects' as a seperate entry type in the vault it has them as attachments to any other kind of entry. DUH. I don't want just a signature pdf in my vault, either divorced from context or linked but still polluting my results. Stupid. bw reverts to older 1pass behavior with documents, letting me attach them anywhere and keep notes about the specific document. rad.

bw is open source! totally! the clients, the servers, the mobile apps, its rad! a fair critique of bw as a self hosted project is that the servers are _beefy_ fucks. That's true.  since its open source some weirdo has built a rust implementation that is API compatible with all clients. I think this is rad as hell (though i'm not about to trust all my vault secrets to Some Dude's implementation).

A counter argument to my worry about the server is that bw encrypts everything before sending to the server per 3. here:
<https://help.bitwarden.com/article/why-should-i-trust-bitwarden/>

I still am not gonna run bitwarden_rs though.

read about the bitwarden_rs project here:
<https://github.com/dani-garcia/bitwarden_rs>


## next steps {#next-steps}

i'm prboably gonna stay on bw premium on their paid service for a while. its only $10 anyway, cheaper than 1pass. I think the next think I might do is mirror my server data onto something i self host; that way even if bw gets breached and owned so bad their backups are hosed I can still restore on prem.

i haven't figured out how i could do that, but it seems like it should be pretty feasible. the fact that i could even do that is pretty fuckin' cool, tbqh.

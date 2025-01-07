---
title: "emacs on catalina"
date: 2020-03-29
author: ["josiah"]
draft: false
tags: ["emacs"]
aliases: ["/posts/emacs-on-catalina.html"]
---

## early days {#early-days}

i had to move from mojave to catalina during the beta to test some security tooling for work (spoilers: it sucked, though now cylance has actually fixed their catalina problems) and the process was r o u g h almost entirely because of emacs.

at first there was only a single reddit post detailing what emacs users might need to know about. it linked to [this gist](https://gist.github.com/dive/f64c645a9086afce8e5dd2590071dbf9).

this basically says to run this lisp to add your proper emacs path to the proper exclusions and then you won't have any problems. Ok great! but that didn't work. I could now _launch_ emacs from Spotlight and navigate around my Docs/Downloads/whatever, but i was totally unable to _swap_ to emacs from Spotlight. this also impacted using hammerspoon as a launcher, i'm guessing because the primative behind both mechanisms is the same.


## partial fix {#partial-fix}

later that week, a few other people said you needed to whitelist <span class="underline">ruby's</span> executable because that was actually how homebrew installed emacs; the emacs executable is called from a ruby script (which is called by a ball rolling down a train track headed towards a toothpick which,) and thus needs to be whitelisted as well. but that didn't work either (though they were actually correct that ruby was involved).

since I could at least launch and navigate around with my then-current janky set up i stopped spending Paid Time on it and moved on. i ran the the rest of the catalina beta out and then reported back on my experience with our security tools, whatever. a few weeks ago i finally got mad enough at the situation to spend some more time looking at this and found the answer really soon! apparently a bunch of people had similar problems to me and so there are several blogs about the problem now! the one I found most helpful was [this guy](https://spin.atomicobject.com/2019/12/12/fixing-emacs-macos-catalina/).


## jankiest fix {#jankiest-fix}

he gives a good breakdown as to why this is needed <span class="underline">instead of</span> the ruby application whitelisting. here's the quick fix:

```shell
% cd  /Applications /Emacs.app /Contents /MacOS
% mv Emacs Emacs-launcher
% mv Emacs-x86_64- 10_14 Emacs
% cd  /Applications /Emacs.app /Contents /
% rm  -rf _CodeSignature
```

this is not like, super great. its makes your configuration brittle and it will break when you update emacs! version 27 is looming i hear. but at least i can fucking swap to emacs again.

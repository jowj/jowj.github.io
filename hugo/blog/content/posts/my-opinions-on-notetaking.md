+++
title = "my opinions on task management and notes"
date = 2022-07-04
author = ["josiah"]
draft = false
+++

## Introduction {#introduction}

Note taking systems have come up at work a lot; flavor of the month applications (Roam Research! Obisidian!); whether you should write up notes in a private wiki; particular ideologies like [Zettelkasten](https://en.wikipedia.org/wiki/Zettelkasten) (ZTK) or [Getting Things Done](https://en.wikipedia.org/wiki/Getting_Things_Done) (GTD); etc. I have A Lot of Opinions about note taking and productivity, and wrote up a quick and dirty summary of options on apps / ideology for coworkers. This post is a longer form write up on task management, productivity systems, and notes generally from that original summary.

This post assumes you are a knowledge worker of some kind, and thus have a need for the heavier weight systems like ZTK or GTD. This post does not assume you are a programmer or work in tech, specifically. My goal is for you to feel comfortable reading this regardless of technical aptitude -- if you're the kind of person who needs a robust note / task management system then I want to help!


## Concepts / ideology / religious warfare {#concepts-ideology-religious-warfare}

Always start with ideas before implementation. I'm sure there's more sects out there than I am aware of, but broadly there are three mainstream knowledge management styles: Zettelkasten, Getting Things Done, and then just "writing shit down and hoping you find it later", which I'll call "Just Take Notes". The third is by far the most common when it comes to note taking, and variations on GTD are the most common task management system. ZTK is trendy methodology for knowledge management and discovery but doesn't really focus on task management necessarily (though some folks do bolt ZTK and GTD together!)


### Getting Things Done {#getting-things-done}

You can buy a book on GTD by the idea's creator, [David Allen](https://en.wikipedia.org/wiki/David_Allen_(author)), and if you like the system after reading about it here and want to learn it in its Pure Form or whatever then I absolutely encourage you to do that. However, my personal opinion is that adhering to the concepts outlined by its author is not all that useful to most people. Instead, I recommend taking some of GTD's core ideas and adapting them to fit your use-case.

For example, here's a workflow sample of GTD:


<div style="padding: 1em;background-color: #CCFFCC;border-radius: 15px;font-size: 0.9em;"> <h3>A GTD workflow sample</h3>

1.  The most annoying, distracting, or interesting task is chosen, and defined as an "incomplete".
2.  A description of the successful outcome of the "incomplete" is written down in one sentence, along with the criteria by which the task will be considered completed.
3.  The next step required to approach completion of the task is written down.
4.  A self-assessment is made of the emotions experienced after completing the steps of this process.

</div>

This breakdown is an excellent start for many people. It helps them get their hands around a task they've been procrastinating on and show that the task is maybe more tractable than originally thought. However, I often don't _need_ this sort of thing. Slavishly reproducing this is not useful to me. Instead, I focus on the core tools and concepts required to make any GTD system function:

Core needs (summarized):

1.  You need to be able to capture ideas/tasks/whatever as they come to you, hopefully without interrupting your workflow too much.
2.  You need to (either right away, or later during a review period) break down that idea/task, so you can figure out next steps.
3.  You need to be able to find your captured and clarified task/idea/bullshit later
4.  You need to review what you’ve captured and update/delete/whatever your bullshit
5.  (outside the scope of the system) actually do stuff with what you’ve captured.

Core tools:

-   An inbox
-   A trash can
-   A filing system for reference material
-   A calendar

<div style="padding: 1em;background-color: #CCFFCC;border-radius: 15px;font-size: 0.9em;"> <h3>Core tools explainer</h3>

-   An inbox is where un-filed ideas/tasks go. If a new idea or task comes to you, you should put it here.
-   A trash can is self-explanatory, and often doesn't have to be in the system itself; you can just delete an entry or file it away if it might be useful later.
-   A filing system allows you take un-filed items and move them to a semantically appropriate place after you've thought about it / broken it down into sub tasks / added context (like "Mowing the lawn" might go under "house maintenance"). This makes it much easier to find things later on. This is heirarchical, so you can have nested structures like "Personal" &gt; "Relationships" &gt; "Josiah" &gt; a number of items relating to your relationship with me.
-   A calendar allows you to schedule tasks and mark them as due on certain dates. This is a big one for keeping me productive over the long term.

</div>

With these tools you're able to meet all the requirements from the "needs" section mentioned above. When examining implementations (i.e. apps!) you want to make sure a given implementation has all the right bits that map to these tools and support these needs.


### Competing ideologies {#competing-ideologies}

The other religions are wrong, kill the heretics.


#### Zettelkasten {#zettelkasten}

I know very little about ZTK other than that it exists and that scientists _love_ it. The basic idea is kind of like note cards; each idea or concept has a card, and that card will have topic tags that can be used to reference other notes. This is useful for learning about a new concept over time - it allows you to reference what you had previously understood and square it with your new understanding, as well as reference related ideas or events to explicitly deepen your understanding. One could think of this as basically "tagging, the methodology".

If this style makes intuitive sense for you over the hierarchical filing system approach then more power to you. Hierarchies always ended up working better for me.


#### Plain notes {#plain-notes}

The "just take notes" method is objectively inferior to either GTD or ZTK for the knowledge worker use case. It still gets used frequently due to how difficult it is to start using a heavier weight ideology (the implementation ecosystem is pretty bad and only recently has it started improving). "Just take notes" people tend to rely on one of two methods for getting data back from entries they've added:

-   plain text search (which is very valuable, and finally being treated as important in modern note systems), or:
-   they don't. They rely on the act of recording the data to improve their memory, but never reference the recorded data ever again.

    Despite the limitations of Just Take Notes, there are two things that it usually gets right: plain text search &amp; data portability

<details class="code-details"
                 style ="padding: 1em;
                          background-color: #e5f5e5;
                          border-radius: 15px;
                          color: hsl(157 75%);
                          font-size: 0.9em;
                          box-shadow: 0.05em 0.1em 5px 0.01em  #00000057;">
                  <summary>
                    <strong>
                      <font face="Courier" size="3" color="green">
                         A note on plain text search
                      </font>
                    </strong>
                  </summary>

This is not possible in many, many note taking applications. I encourage you to select for this capability; using a tool that rolls its own search _and_ does not allow plain text search is a recipe for disaster. Tech workers have probably all encountered a wiki system called [Confluence](https://en.wikipedia.org/wiki/Confluence_(software)) that does this. This system is near universally reviled by non-management types because its such a pain to find data once its in there. I've heard it referred to as "write once find never" software because the search is so bad.


</details>

<details class="code-details"
                 style ="padding: 1em;
                          background-color: #e5f5e5;
                          border-radius: 15px;
                          color: hsl(157 75%);
                          font-size: 0.9em;
                          box-shadow: 0.05em 0.1em 5px 0.01em  #00000057;">
                  <summary>
                    <strong>
                      <font face="Courier" size="3" color="green">
                         A note on file formats and data portability
                      </font>
                    </strong>
                  </summary>

A good note taking system should not be beholden to a single app, developer, or company. Your note system should be as future proof as possible, and to that end you should use an open data format (as in, not proprietary) that's supported by a wide range of applications. That way, if your favored app goes the way of the dodo, your notes are 4 clicks away from being imported to the next app. If you use a proprietary file format you could _lose access to all your data_ if a company goes bankrupt.

Relatedly, you should care about where your notes are stored. Its very easy to get up and going with a cloud based note system, but the same system can cost you access and convenience in the long run. I recommend you select for a note taking app that is [Local First](https://www.inkandswitch.com/local-first/) - that is, it can use the cloud for backups and syncing files, but you should be storing notes locally on your devices.

This doesn't necessarily tie into plain text search, but frequently does. If a given note taking app uses their own file format or stores all your notes in a cloud solution you are unlikely to be able to perform plain text search on your notes. This is probably not true 100% of the time, but I can't think of an exception off the top of my head.

Modern good note taking solutions have converged on building off of one or two file formats that are human readable, stored locally as well as in a given cloud solution, and plain text searchable. The two formats are:

-   Markdown (the most common, newer, widely understood, widely supported)
-   Orgmode (more rare, older,  steeper learning curve, tooling is rougher, IMO more powerful)

I prefer orgmode, but as long as you're on one of these two you'll be fine.


</details>


## Implementations and apps {#implementations-and-apps}

Now that we've talked about key concepts we are ready to talk about possible implementations and apps that could work for you.


### Big players {#big-players}


#### Emacs and org-mode {#emacs-and-org-mode}

Orgmode is a big deal in this space, and a bunch of the dissertations written about big note systems and "personal information management" came from Org mode. Org mode as a platform supports both ZTK and GTD quite well, though GTD is the standard historical system and ZTK's linked notes is more recent. Org mode GTD support is handled natively (and there are a LOT of posts about GTD with orgmode - you can read a sample of them [here](https://orgmode.org/worg/org-gtd-etc.html)), while ZTK is handled via the [org-roam](https://github.com/org-roam/org-roam) package. I'm less plugged into ZTK on Org, but you can check out the creator's [thoughts](https://blog.jethro.dev/posts/introducing_org_roam/) on it on their blog.

Orgmode's has two incredible strengths:

1.  Customization
2.  History

These two strengths play together very well. Since org-mode is open source and built on top of emacs (which is also open source), you can write extensions to modify behavior and appearance. This is huge for adapting the tool to your own needs, even within the core GTD workflow. Emacs has been around since _1976_, so there's this huge body of work to draw on from other folks. I mentioned at the outset of this post that you don't have to be a programmer to read this - emacs is the most "I want you to be a programmer" tool I'll talk about here. But if you aren't a programmer you can still be extremely productive by using community maintained user-friendly configurations. [Spacemacs](https://www.spacemacs.org/) (free) and [doomemacs](https://github.com/doomemacs/doomemacs) (free) are the two notable flavors. I'll also mention a tool i've never used but have bookmarked called [EasyOrg](https://easyorgmode.com/) (paid), which appears to take some of the core org mode features and put them in a slimmed down editor with normal keybinds.

That keybind call out leads me to the weakness of the emacs/orgmode option:

1.  Ancient / unintuitive keybinding defaults
2.  A pretty terrible mobile experience

The keybinding defaults will be unintuitive to any modern user. Copy / cut / paste are all different, and so are core movement keys. You can remap all of them, of course, but to extend or configure emacs you must write [elisp](https://www.gnu.org/software/emacs/manual/html_node/elisp/), which is an archaic variant of a programming language that most folks do not like. Using something like EasyOrg as mentioned above mitigates this issue to some degree, as an individual won't have to write their own configuration, but using EasyOrg is not a panacea; a pre-configured tool like that likely has some other limitations to keep in mind.

The mobile experience sucks because there is no single official app; there's no emacs for mobile. There are, instead, many different mobile implementations that differ in goal (task management, knowledge-base access, calendar integration, git integration, etc), language, platform support, etc. If you choose to go with something like emacs + org mode you will need to evaluate mobile apps based on which feature set is important to you. I won't go into that here, but will instead list the apps worth evaluating:

-   [beorg](https://beorgapp.com/) (ios) (I use and recommend this)
-   [plain org](https://plainorg.com/) (ios)
-   [flat habits](https://flathabits.com/) (ios)
-   [mobileorg](https://mobileorg.github.io/) (ios)
-   [syncorg](https://github.com/wizmer/syncorg) (android)
-   [orgzly](http://www.orgzly.com/) (android) (I use this)

If you use emacs already then orgmode is a great choice. There's a huge history of personal information management here, there's a ton of community resources, and you have the ability to make it do anything you could ever want. Finally, the age of emacs makes it an incredibly safe choice when thinking of longevity. Emacs has been around since the 70s; there's hardly any software that's been around that long. Of course, evidence of history does not equate to evidence of future, but its a good indicator.

If you don't already use emacs and aren't my direct friend I mostly recommend other tools. If you're at all curious and want some help or to ask questions please feel free to [reach out to me](mailto:me@jowj.net), direct friend or not! I love to talk about emacs and I love to help people.


#### Obsidian {#obsidian}

[Obsidian](https://obsidian.md/) is a new and growing-in-popularity documentation tool. Its big strength is its [plugin](https://obsidian.md/plugins) system and vibrant [community](https://obsidian.md/community) - like emacs, there's probably someone else who has tried to do what you need before, and they may even have published an addon you can adapt to fit your needs. To be clear, if you want to write your own addon you'll need to be able to program, but using community available addons is easy, free, and does not require programming knowledge. The ability to support workflow customization is huge, though, and the presence of that feature is a big draw for me. Obsidian supports ZTK out the box - it looks really nice, I encourage you to check out the homepage for pretty graphs about note connectivity. It also supports GTD through the use of addons (probably a few, [this one](https://github.com/larslockefeer/obsidian-plugin-todo) seems to be the most popular).

Obsidian's business model is worth calling out here, as its a bit different than what you'd expect. The core tool is free for personal users, with a recurring yearly fee per user for commercial uses. However, there are two proprietary addons made by the Obsidian core team, not the community, that are also charged for: sync and publish. Sync is end to end encrypted, platform agnostic sync between devices. Its pretty great. Sync also includes 1 year of version history, which is _really_ fucking great. Publish is a bit less useful for the average user, but still quite nice: it allows you to publish your obsidian notes as a blog, under your own domain. You can view some samples of what it looks like [here](https://obsidian.md/publish), by scrolling down.

There are not too many downsides for Obsidian, and this is the app that I recommend to most folks who are looking: its based on markdown, which most people are familiar with; its free for personal users; it has a plugin/addon concept, and you can write your own if you really hit a wall; the company seems to have a decent revenue stream in certain paid addons + commercial offerings. However, just to be thorough, I'll mention that its not open source. If you care about that you're better off with something like emacs+orgmode for its freedom guarantees.


#### Roam Research {#roam-research}

RR seems to be a favored tool of many academics, though I have several issues with this and overall **would not recommend this to the average user**. Roam is a knowledge base / wiki style tool that supports ZTK workflows very well, and can be made to support GTD. I won't go in depth on this tool, but did feel the need to mention it due to its large popularity. Even the Orgmode ZTK module is named after this tool! The biggest reason I do not recommend RR is that is it _online first_ software. Its built out of the browser, and while it has an app, many features don't work unless you're running it in a regular chrome window (apparently including local backups, which feels insane).

Here are some articles that go into further info on RR if you are curious:

-   [The roam whitepaper](https://roamresearch.com/#/app/help/page/dZ72V0Ig6)
-   [Someone loves Roam and goes into loving detail about why](https://www.nateliason.com/blog/roam)
-   [Someone argues that Roam is the religious successor to the original web](https://capiche.com/e/roam-research-worldwideweb-xanadu) (which I think is dumb, but Roam links to this on their website)


### Honerable mentions {#honerable-mentions}

I don't want to go in depth on these so much as mention them. They are important, and in some cases historically the only option, but not what I recommend if you need a real heavy weight system.


#### Onenote {#onenote}

I would be convicted of a crime if I didn't mention [Onenote](https://www.microsoft.com/en-us/microsoft-365/onenote/digital-note-taking-app). Excellent basic note offering, works everywhere. You're reliant on Microsoft, which is a blessing and a curse - they will absolutely have revenue forever, but they also can cancel/ruin projects that are critical to you (see Skype/Lync/Teams fuckery). There's not good support for GTD or ZTK, though you can kludge stuff together with tags for both systems. There is no ability to extend onenote functionality if you hit a wall in the default offering.


#### Evernote {#evernote}

[Evernote](https://evernote.com/) is historically significant, but hasn't done as well in recent years. It is an intermediate app, and sits awkwardly between the intro-friendly Onenote and a heavier-weight system like Obsidian. It has apps that run everywhere and a great set of integrations which allow the user to pull data into their Evernote system automatically via feeds or app specific integrations (for instance, gcal data). Unfortunately, it suffers performance issues and lacks the openness that make Emacs+orgmode or Obsidian so powerful. Like Onenote, there is no way to write your own extension if you need to adapt the tool to your own workflows.


## Wrap up {#wrap-up}

I have notes going back years and years that are stuck in proprietary systems or languishing in systems that require manual work to migrate away from. I moved to emacs+orgmode in 2016/2017 and since then all my notes and tasks remain accessible and plain text searchable. It is worth spending real time choosing the appropriate system and implementation for you. I derive an incredible amount of value from my historic notes - it lets me: see what I've worked on, save WIP projects for open-ended periods of time when I have RSI flare ups, keep robust documentation around infrastructure and home care, and tons more. Especially at work this is a super power! I take notes, record issues I have with projects, and can refer back to anything relevant with a quick search. My performance at work is tied to how good my notes and task management systems are!

You should spend time on this too. If you have questions I want to hear from you :) .

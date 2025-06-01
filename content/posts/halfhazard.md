---
title: "Halfhazard(ous)"
date: 2025-06-01
author: ["josiah"]
draft: false
tags: ["projects, ios"]
---

I wrote [Halfhazard](https://github.com/jowj/halfhazard), a small app for keeping track of budgeting and billing for me and my partner. Its rough around the edges, has a handful of UI bugs, and will likely never be officially published on the app store (I pay for an Apple developer account and just use testflight builds for us), but I am now doing billing on it full time instead of through [Splitwise](https://www.splitwise.com/), our previous tracker.

This project represented my first foray into UI programming, and it saw several iterations. Originally, I wrote an app by hand using SwiftData and SwiftUI, which was an excellent learning experience. However, I ran into several problems that ultimately led to me rewriting the app using Firebase instead of SwiftData:
- SwiftData was fairly new at the time I was writing this. The docs were bad, and in some cases incorrect.
- UI programming itself is complicated and doesn't make intuitive sense to me. SwiftUI is very opinionated, and makes the process harder to grok, at least initially.
- SwiftData with iCloud storage does not support the usecase I care most about - I have some data that I won't to be private from the world but shared between certain known entities.
  - as near as I can tell it is an explicit design goal for iCloud DB store to not support shared objects like this - things can be totally private or totally public, but nothing in between.

I began rewriting my app with the help of copy/pasting into chatgpt. This was a frustrating process, and eventually I found it easier to simply start from scratch with no reused code. I started working with Claude Code at this point, which was VERY useful, and the rest of this project has been built with Claude's help. I learned a lot about how to interact with an AI inside a code base. Some stuff that I found useful:
- Resetting context prior to making big changes. It sucks so much to have the context window reset when its in the middle of a broad refactor.
- Creating tests for the agent to use prior to EVER returning to me. If, after it made changes, the tests don't pass, the agent must make the tests pass. Several times this resulted in the agent modifying the tests directly until I instructed out that behavior, after which it's been pretty solid.
- Using common frameworks and practices - the agent was out of its depth with SwiftUI in general. Anytime I had firebase questions or concerns it could 1shot it. SwiftUI stuff it didn't seem to have a ton of info on in its training set.

I'm pleased, over all, using Claude and having a tool at the end I can use and customize further at my leisure.

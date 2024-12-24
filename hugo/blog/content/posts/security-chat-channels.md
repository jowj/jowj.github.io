+++
title = "Do security in public"
date = 2024-09-15
author = ["josiah"]
draft = false
+++

## You should have an #ask-security channel {#you-should-have-an-ask-security-channel}

I recently had a conversation at work on this topic and I wanted to jot down some of my thoughts about it.

You should have an #ask-security channel, and either every service owner within your security org should monitor it, or you should have your SOC triage it and tag in sevice owners as needed.

Having an explicit venue for security conversations provides a bunch of benefits, like:

-   Raising security awareness within the engineering orgs
-   Gives faces to the Security team, which is especially useful since Security is often propped up as a boogeyman who makes unpopular policy decisions
-   Allows teams to ask security-impacting questions without going through a formal process like a security review


## Exceptions, but (mostly) not practical ones {#exceptions-but--mostly--not-practical-ones}

Management or other security minded engineers might push back on this for risk aversion reasons, like:


### Post intrusion data leaking {#post-intrusion-data-leaking}

<div style="padding: 1em;background-color: #CCFFCC;border-radius: 15px;font-size: 0.9em;"> <h3>but what if...</h3>

...we're breached? I see people talk about slack use in post-exploitation reports! Shouldn't we take steps to prevent slack, or any chat app, housing sensitive data?

</div>

A fair question! But, the question implicitly frames the scenario as "we aren't having sensitive conversations in slack now", which is almost certainly incorrect. A few points:

1.  Right now, your company has all kinds of security impacting conversations in channels all over your chatapp. There is basically no (cheap) way to prevent this. Centralizing them into a single channel (or 2, whatever) could even make IR _easier_ because you'd have a better idea of what was talked about and where.
2.  Just because you do security in public doesn't mean there aren't things that should be discussed in higher-trust environs. You can easily create a process by which teams move sensitive issues from the public channel to DMs, zoom, or Jira.
3.  Slack’s value lies in its efficiency as a communication tool, which is exactly what makes it attractive to attackers. Recent breaches have highlighted this risk. One approach to dealing with this is to add additional friction to the coms process, but this slows us as much as it slows attackers (or more!).

All decisions can be made on a spectrum of usability vs security, and there's a lot of circumstances where I'd push for an emphasis on security over usability. Here, though, the benefits outweighs the harms for a public slack channel.


### Regulatory environments {#regulatory-environments}

<div style="padding: 1em;background-color: #CCFFCC;border-radius: 15px;font-size: 0.9em;"> <h3>but what if...</h3>

...we made promises to regulators about where data lives? Slack doesn't give us the guarantees we promise customers.

</div>

This is a valid reason! If this applies to you, I recommend re-evaluating your chat strategy. Self hosting your chat app allows you to make whatever guarantees you like without compromising the speed at which you work.


## Benefits of a public security forum {#benefits-of-a-public-security-forum}


### Raising security's profile {#raising-security-s-profile}

Having public discussions about security raises the profile of security, which can be used to normalize discussing security issues and encourage engineers in non security focused domains to be more proactive about security. It also lets other employees who may not be cognizant of security in general watch practioners talk through their process, and weigh risk appropriately. We can all learn via modelled behavior, and this is one way of modeling behavior we want to see in engineering teams.


### Faster results {#faster-results}

Slack channel discussions tend to lead to faster resolutions of issues. If an engineer can directly ask a question, get an answer, and move on about her day without having to wait the mandatory 48 hour turn around time on a Jira comment, that engineer is able to stay focused on her task without context switching. We should be supporting that as much as possible!


## Things to avoid when implementing a public security channel {#things-to-avoid-when-implementing-a-public-security-channel}

A common failure mode I see is a channel gets set up, but never reaches critical mass and then ends up disused. This can happen for a lot of reasons, but especially these are common:

-   A channel that's hard to discover because its not public
-   A channel that's known but requires a direct invite


## Talk to me {#talk-to-me}

If you disagree with this premise i am interested in talking to you! please, [yell](mailto:me@jowj.net) (politely) at me.

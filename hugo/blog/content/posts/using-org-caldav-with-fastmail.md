+++
title = "using org caldav with fastmail"
date = 2021-03-08
author = ["josiah"]
draft = false
+++

## how to sync calendar events from fastmail to your org agenda {#how-to-sync-calendar-events-from-fastmail-to-your-org-agenda}

i've recently started a new job. i take a lot of notes, and I find it useful to take notes for each meeting along with some metadata about each meeting. the notes i obviously take as the meeting goes on, but the metadata is already in the meeting invite. rather than entering all of it manually for each meeting, I've had org-mode pull the meeting info for me.


### doing this {#doing-this}

1.  download [org-caldav](https://github.com/dengste/org-caldav)
2.  configure it
3.  run `org-caldav-sync`
4.  cool you're done


#### really though, {#really-though}

ok its only slightly more complicated than that. for fastmail, you can't follow the instructions as given exactly. Here's the broad way to configure it (i'll use `use-package` because so does everyone):

```elisp
(use-package org-caldav
  :ensure t
  :config
  (setq org-caldav-url "https://caldav.fastmail.com/dav/calendars/user/your@domain.tld/")
  (setq org-caldav-calendars
        '((:calendar-id "00000000-0000-0000-0000-000000000000"
                        :inbox "~/org/calendar-events.org")))
  (setq org-icalendar-timezone "America/Chicago"))

```

that's basically it. here's one of two original examples given in repo for reference:

```elisp
(setq org-caldav-calendars
  '((:calendar-id "work@whatever" :files ("~/org/work.org")
     :inbox "~/org/fromwork.org")
```

the way my method differs from the original instructions is the `org-caldav-url` and `calendar-id` vars. the string to use for the `url` is pulled from the fastmail documentation [here](https://www.fastmail.help/hc/en-us/articles/1500000278342#calendar). the `calendar-id` is behind your authwall; login -&gt; settings -&gt; calendars -&gt; locate your calendar -&gt; click the export button for that item. Here you should see a full URL in a text box that looks like this:

`https://caldav.fastmail.com/dav/calendars/user/your@user.tld/00000000-0000-0000-0000-00000000000000000`

copy everything after your `user@domain.tld`; that goes in your `calendar-id` field.


### org-gcal as an alternative to org-caldav {#org-gcal-as-an-alternative-to-org-caldav}

there are a few different ways to sync calendars into org-mode. [org-gcal](https://github.com/emacsmirror/org-gcal) is for folks running gcal for events. however, be warned that you must have a certain level of permission within your Google Org for that account to be useful; you need enough permission to create an API key within the org. for someone's personal accounts that probably works. if you're trying to integrate with a work account, where permissions should be more locked down, you will need to do something else.

google _really_ would prefer that you don't use caldav to talk to their calendars. org-cal is based on google's own API, and doesn't adhere to normal email standards.  this is shitty, but frankly caldav is a fucking mess, so you can't really blame them.


### access gcal calendars with org-caldav {#access-gcal-calendars-with-org-caldav}

so, what's a person to do if they don't have the ability to use google's api to pull down calendars, but they still need to sync gcal stuff to orgmode? well, you can do something kind of dumb, but easy. gcal publishes your calendar to an unauthed but secret URL by default. you can subscribe to that URL from within fastmail, and then sync that calendar down to org mode through fastmail!


#### doing this {#doing-this}

1.  copy the url from the google calender
2.  subscribe to the url in fastmail (and i assume any provider that uses caldav)
3.  sync that calendar down to org mode via org-caldav!


#### details {#details}

access the URL that google publishes to by logging into gcal -&gt; settings -&gt; click on the calendar you want to access on the left hand side of the screen -&gt; scroll down until you see "secret address in iCal format". copy that URL.

subscribe to the calendar in fastmail by logging into fastmail -&gt; settings -&gt; click on calendars on the left hand side -&gt; find the box labeled "Subscriptions" and paste in the URL there. hit subscribe. done!


#### other options {#other-options}

fastmail _also_ allows you to log into a few providers specifically. I suspect this is done by simply mimicking a client, so fastmail speaks the gcal API and you can have access to everything that way. I haven't tried this, though I may get curious eventually. If you try it [i'd love to know!](mailto:me@jowj.net)


### credential storage {#credential-storage}

syncing events to org mode manually seems fine to me; i'll typically do it once, maybe twice a day. typing in credentials each time you want to sync sucks though. this type of problem is commonly solved 1 of two ways, in emacs:

1.  authinfo
2.  authinfo, but encrypted with gpg

you should encrypt the file with gpg. this is not too difficult!


#### doing this {#doing-this}

1.  create a gpg key and trust it
2.  create a file that you will encrypt, adding the login details to the file
3.  configure emacs to look at this file for `auth-sources`
4.  test to make sure your changes work


#### details {#details}

you should create a gpg key and trust it. there are other guides for how to do that. here are a few:

-   <https://blog.eleven-labs.com/en/openpgp-almost-perfect-key-pair-part-1/>
-   <https://alexcabal.com/creating-the-perfect-gpg-keypair>
-   god gpg sucks

then, within emacs, open a file that you will encrypt. make sure it ends in `.gpg`. when you do that, emacs will prompt you for how you want to encrypt the file. you will see your newly added gpg key and id listed as an option. use that.

next, fill the file with your login creds in a vaguely frustrating format. here's how its supposed to look:
`machine www.google.com:443 port https login your.username password your.secret`

specification of port:443 and https is _required_ because `authsource` is weird.

now you need a minor bit of customization to make this work. the below snippet works just fine on my linux and mac machines. there are some added bits that are set if you're on a mac (`epa-pinentry-mode` to avoid errors. the rest of pretty self explantory.

```elisp
(require 'epa)
(when (eq system-type 'darwin)
  (setf epa-pinentry-mode 'loopback))
(setq auth-sources '("~/.emacs.d/yoursecrets.gpg"))
(setq auth-source-debug t)
```

finally, test and make sure your calendar event sync works without prompting you for a password by evaluating that lisp and then running `org-caldav-sync` again. if you've set everything up correctly it will auto sync and you won't have had to type anything extra!

nice!

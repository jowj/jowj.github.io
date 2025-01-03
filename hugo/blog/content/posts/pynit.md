+++
title = "pynit"
date = 2020-03-29
author = ["josiah"]
draft = false
tags = ["project notes"]
+++

## what is this {#what-is-this}

pynit is a personal archival script that relies on [pinboard](https://pinboard.in). it pulls in posts through the reddit api (by way of \`praw\`) and adds them to the linked \`pinboard\` account. you can get it [here](https://github.com/jowj/pynit).


## why i made it {#why-i-made-it}

i use reddit (foolish, i know) to keep up to date on a lot of bullshit in the world, although primarily:

-   fashion
-   emacs / org-mode
-   powershell
-   homelabs
-   secops

my typical workflow for seeing a piece of content that was useful looked something like:

-   view content
-   peruse comments (usually, the most useful part of the reddit entry)
-   find something that i want to revist
-   save it for later inside of reddit
-   forget about it forever, maybe revisit it within 3 months if i'm very bored
-   in the interim, many of the comments are deleted, links don't work, parent URL points to a dead webserver

this is obviously not ideal. pynit helps me with about half of those problems. specifically, because i pay for \`pinboard\`'s archiving service, i can preserve the context in the comment section of the reddit entry. links may still be broken, but i'm perfectly fine with using archive.org for viewing the links later if i need to. as i mentioned, comments end up being the most useful thing to me most of the time.

it should be noted that \`pinboard\` can be used to archive the parent URL context as well, but i opted not to do that in order to preserve some semblance of readability in my \`pinboard\` feed.

comments are also possible to be preserved through things resavr, ceddit, removeddit, etc. these type of sites go down regularly and are not very reliable in my experience (although resavr looks promising, if limited. it only archives comments that are deleted that are &gt; 1000 characters).

now whenever i want to revisit a particular item i have all the comments preserved via pinboard, and URLs can be usable (most of the time) through archive.org.


## what I learned while i made this {#what-i-learned-while-i-made-this}

i learned a few things that i want to write up here, all related to python or working with rest apis:


### python {#python}

i learned about [pysnoop](https://github.com/cool-RR/PySnooper) through [@mrled](https://twitter.com/mrled)and it was SO useful. there may be more ways to use it (read their github page, its got great examples), but i primarily used it by decorating a function i wanted to inspect, like:

```python
import pysnooper

@pysnooper.snoop()
def my_function():
    var1 = 'thing1'
    var2 = 'thing2'

    return(var1 + var2)

print(my_function())

```

this would return:

```python
19:54:53.048881 call         4 def my_function():
19:54:53.049021 line         5     var1 = 'thing1'
New var:....... var1 = 'thing1'
19:54:53.049094 line         6     var2 = 'thing2'
New var:....... var2 = 'thing2'
19:54:53.049155 line         8     return(var1 + var2)
19:54:53.049197 return       8     return(var1 + var2)
Return value:.. 'thing1thing2'
thing1thing2
```

this allowed me to simple add a single line to an exist function _without modifying the function itself at all_ and make sure I was actually doing what I thought I was doing. this was huge for letting me sanity check my work.


### rest apis {#rest-apis}

a lot of people (a lot of people!!) just have you use get requests instead of posts, even when you're posting stuff. i am not a Web Man, so i don't understand the why, but if all you've ever done is _read_ about working with rest apis then the real world may be confusing when you try and post something that requires a get request. the [pinboard api docs](https://pinboard.in/api) for instance require get requests when you mean posts for backwards compatibility with the \`delicious\` api.

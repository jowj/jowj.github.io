---
title: "My Test Post"
date: 2020-12-19
draft: true
---
# this is the first headersdsdasd

this is a normal paragraph, and it contains a line that wraps naturally
due to length. its pretty cool. below me is a list:

1.  item 1
2.  item 2s
3.  item 3
    -   unordered 1
    -   2
    -   3


# here is a python embd
```python
import slack

def reactable_string(text):
    reactable_array = []
    if 'cyber' in t:
        # panick!sdf

```


```python
import slack

def reactable_string(text):
    reactable_array = []
    t = text.lower()
    if 'cyber' in t:
        reactable_array.append('robot')
    if 'flavor town' in t:
        reactable_array.append('flavortown')
    return reactable_array

def rtm(emoji, payload, id, ts):
    payload['web_client'].reactions_add(
        channel=id,
        name=emoji,
        timestamp=ts
    )

    return None


@slack.RTMClient.run_on(event='message')
def handle_messages(**payload):
    data = payload['data']
    id = data['channel']
    ts = data['ts']

    if reactable_string(data['text']):
        needed = reactable_string(data['text'])

        if 'robot' in reactions_needed:
            rtm("robot_face", payload, id, ts)
        if 'flavortown' in reactions_needed:
            rtm("dark_sunglasses", payload, id, ts)
            rtm("guyfieri", payload, id, ts)


if __name__ == '__main__':
    stoken = 'XXXXXXXXXXXXXXXX'  # Secret token!!
    rtm_client = slack.RTMClient(token=stoken)
    rtm_client.start()
```

# here is a lisp embedss

```lisp
(let ((proj-base (file-name-directory load-file-name)))
  (setq org-publish-project-alist
        `(("project-name"
           :base-directory ,(concat proj-base ".")
           :recursive t
           :publishing-directory ,(concat proj-base  "../export")
           :publishing-function org-html-publish-to-html))))
```

# see links styling

<https://me.jowj.net> looks like this <https://google.com> looks like
this

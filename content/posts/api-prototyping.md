---
title: "rest api prototyping"
date: 2020-03-29
author: ["josiah"]
draft: false
tags: ["emacs", "orgmode"]
aliases: ["/posts/api-prototyping.html"]
---

## the problem {#the-problem}

lately i've been working on a lot of web API glue projects. these are usually simple things like "service1 needs to send messages to service2 in a particular format, with a particular set of priviledges." Sometimes its more complicated, but that's usually what it breaks down to.

at first I was writing python code the whole time, exploring the API through python (ugh) and kept getting frustrated; it felt like I wasn't able to go as fast as I would like, I kept making silly mistakes that I wouldn't catch until much later, etc. To fix this, i've moved to prototyping in [restclient.el](https://github.com/pashky/restclient.el) - this is a featureful rest client that you interact with through plain text (i.e., you can version control it!) within emacs.

this has worked great for a lot of things, but falls short when you have to generate an auth token programmatically (instead of using a static key) for each request. this problem is solvable using: a different kind of glue lol. i use python to create the auth token, org-babel to register the result and then pass it to \`restclient\` which will continue to be my prototyping tool of choice. this write up will go over how i stitch each part together; i'll use Cylance as an example service for api requests.


## Authentication and Authorization in Cylance {#authentication-and-authorization-in-cylance}

Cylance relies on something called JWT (JSON Web Token). There's an RFC for this here: <https://tools.ietf.org/html/rfc7519>. This is not possible to generate within \`restclient\`, so we do it in python.

To generate the JWT, in Cylance's case, we care about:

`TID_VAL`, which is the tenant ID. You can find this by logging into the console &gt; settings &gt; integrations.
`APP_ID` and `APP_SECRET`, which is under the same place, but you'll have to expand the custom application.

We'll add a `#+name:` argument to the top of the `org-mode` src block so that the output from the block can be registered for later use.


### python code {#python-code}

```python
import uuid
import json
import requests
import jwt
import pdb
from datetime import datetime, timedelta

# initial auth test setup
JTI_VAL = str(uuid.uuid4())
TID_VAL = ""     # The tenant's unique identifier.
APP_ID = ""      # The application's unique identifier.
APP_SECRET = ""  # application's secret to sign the auth token with.

# 30 minutes from now
TIMEOUT = 1800
NOW = datetime.utcnow()
TIMEOUT_DATETIME = NOW + timedelta(seconds=TIMEOUT)
EPOCH_TIME = int((NOW - datetime(1970, 1, 1)).total_seconds())
EPOCH_TIMEOUT = int((TIMEOUT_DATETIME - datetime(1970, 1, 1)).total_seconds())

AUTH_URL = "https://protectapi.cylance.com/auth/v2/token"

CLAIMS = {
    "exp": EPOCH_TIMEOUT,
    "iat": EPOCH_TIME,
    "iss": "http://cylance.com",
    "sub": APP_ID,
    "tid": TID_VAL,
    "jti": JTI_VAL
}

ENCODED = jwt.encode(CLAIMS, APP_SECRET, algorithm='HS256')
# lol you have to decode from a bytes object to a string because
# bytes aren't fucking json serializable
# you never seem to need to re-encode them? python is so fucking weird.
ENCODED = ENCODED.decode()

PAYLOAD = {"auth_token": ENCODED}
HEADERS = {"Content-Type": "application/json; charset=utf-8"}
RESP = requests.post(AUTH_URL, headers=HEADERS, data=json.dumps(PAYLOAD))
print(json.loads(RESP.text)['access_token'])
```

this will generate a token and attach it to the name space `jwt_token` as defined previously.


### restclient example {#restclient-example}

once the previous block has run to generate the json web token  we can pass it on to this restclient block and use it to query Cylance's API through `restclient.el` going forward! in order to pass the output from the registered name we used before, `jwt_token`, we add an argument to the `BEGIN_SRC` header, like `:var x=jwt_token`. Then, we can set a `restclient` local variable equal to the `org-babel` super-variable and use it within the rest of the src block, as seen below:

```restclient
# auth.test
:cylance_jwt_token = :x
GET https://protectapi.cylance.com/users/v2?page=1&page_size=1
Authorization: Bearer :cylance_jwt_token
Content-Type: application/json
User-Agent: Emacs Restclient

```

this will return my user (again, i've disturbed the output but it is roughly what's returned):

```js
{
  "page_number": 1,
  "page_size": 1,
  "total_pages": 6,
  "total_number_of_items": 6,
  "page_items": [
    {
      "id": "",
      "tenant_id": "",
      "first_name": "",
      "last_name": "",
      "email": "me@thiscompanyyo.isit",
      "has_logged_in": true,
      "role_type": "",
      "role_name": "i am the boss",
      "default_zone_role_type": "",
      "default_zone_role_name": "",
      "zones": [],
      "date_last_login": "2019-11-22T14:52:13",
      "date_email_confirmed": null,
      "date_created": "2019-05-17T17:16:52",
      "date_modified": "2019-05-17T17:16:52"
    }
  ]
}
// GET https://protectapi.cylance.com/users/v2?page=1&page_size=1
// HTTP/1.1 200 OK
// Content-Encoding: gzip
// Content-Type: application/json; charset=utf-8
// Date: Fri, 22 Nov 2019 16:24:13 GMT
// Server: openresty
// Content-Length: 339
// Connection: keep-alive
// Request duration: 0.305690s
```


## Troubleshooting python and org-babel {#troubleshooting-python-and-org-babel}

I had huge issues with python virtual environemtns and org-babel while initially setting up this environment. i once had an issue with emacs, I belive in an older version (25 or below i think) where it couldn't find my python binary on macOS. to fix this i manually set it in my `init.el` file, which worked for a long time.

however, if you start using venvs **within emacs**, tools like `pvenv` and `venv` **will not overwrite the global variable set with the new venv specific python binaries** if you've globally set the py binary location. This killed me. below are some blocks i used to troubleshoot what was going on.

This one is pretty straight forward: do i have a virtual env active, and where is the python binary as seen by the shell:

```shell
echo $VIRTUAL_ENV
which python
```

Same deal, only "where is the python binary as seen in the python session". in my case, this was showing me the system python binary even when the **shell** was showing me the venv binary.

```python
import sys
print('\n'.join(sys.path))
```

this block just proved that i could in fact import the right modules that were only in the venv.

```python
import jwt
```

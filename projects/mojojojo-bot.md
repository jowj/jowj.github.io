---
title: mojojojo-bot
categories: projects
---
# mojojojo-bot
this was relatively easy to build initially (straight from a template), but building any functionality that I wanted into was, as expected, hard. because i am garbage at python.

## learnings

### 1. import pdb (python debugger)
    pdb.set_trace
    SETS A BREAK POINT IN CODE AND I CAN WRITE CODE THERE AND INTERACT WITH IT HOOOO MY GOD

this is probably the biggest thing i learned; para exemplar say you have a bit of code that defines a variable eq to individual objects you iterate through one at a time:
```
events = slack_client.rtm_read()
for event in events:
    thing = event.property
    thing2 = event.otherproperty
    do stuff with thing / thing2
```
sometimes (all the time) you run into problems where maybe one of the variables you defined doesn't have the data you expect. so in order to troubleshoot you open you repl and try and do some adhoc definitions of variables and tokens so you can see what the deal is. as you might expect, that's bad and doesn't work very well. but with pdb.set_trace you can define a break point in your code that will give you a prompt, and then you can type "interact" into the prompt and it will let you type python into a repl provided with the state inherent in that point in your code! how fucking cool is that??

```
import pdb
events = slack_client.rtm_read()
for event in events:
    thing = event.property
    thing2 = event.otherproperty
    pdb.set_trace
    do stuff with thing / thing2
```
now the code looks like this and you can just call dir(events) and view its properties!!

### 2. accessing data in dict of dicts
python is not powershell python is not powershell python is not powershell python is no

so in powershell if you're given a dict you can access its indexes using dot params. like
```
PS /> $dict = @{}                                                                                                                                                                                                                                                             
PS /> $dict.Add('firstname','jowj')                                                                                                                                                                                                                                           
PS /> $dict.Add('pet','metroid')                                                                                                                                                                                                                                              
PS /> $dict                                                                                                                                                                                                                                                                   

Name                           Value                                                                                                                                                                                                                                         
----                           -----                                                                                                                                                                                                                                         
pet                            metroid                                                                                                                                                                                                                                       
firstname                      jowj                                                                                                                                                                                                                                          


PS /> $dict.pet                                                                                                                                                                                                                                                               
metroid
PS /> 
```

in python you cannot do this. in python, in order to pull data for a particular key/value pair, you must index using they key value.
```
>>> dict = {}
>>> dict
{}
>>> dict = {"firstname" : "jowj", "pet" : "metroid"}
>>> dict
{'firstname': 'jowj', 'pet': 'metroid'}
>>> dict.firstname
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'dict' object has no attribute 'firstname'
>>> dict[0]
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
KeyError: 0
>>> dict["firstname"]
'jowj'
>>> 
```

it took me. so. so. so. long. 

## what's next:
i gotta finish fixing this bot to get everything i want into 1 file (right now i have some of the functionality i want in two different scripts). then maybe add some extra functionality like:
* commanding to my twitter bot
* ...other stuff.


## resources:
* basic tutorial / code i stole - https://www.fullstackpython.com/blog/build-first-slack-bot-python.html
* to set an environment variable in powershell in userscope, you gotta go out to .net - [Environment]::SetEnvironmentVariable("SLACK_BOT_TOKEN", "Test value.", "User")
* responding to messages with specific text - http://pfertyk.me/2016/11/automatically-respond-to-slack-messages-containing-specific-text/
* api docs - https://github.com/slackapi/python-slackclient

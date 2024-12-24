+++
title = "vcards"
date = 2020-03-29
author = ["josiah"]
draft = false
+++

## computer recovery after a death in the family {#computer-recovery-after-a-death-in-the-family}

this past week my dad and I helped my grandmother with a few Computer Things. my grandfather died at the end of last year and the process of getting "Computer Things" to a usable state for my grandmother was pretty rough.

One of the things that was unexpectedly frustrating was transferring stuff (photos, contacts, whatever) from my granddad's account to my grandmothers. as near as i can tell, a different family member had been helping my grandmother and closed several of my grandfather's old accounts. including email accounts and _iCloud_ accounts.


### outline {#outline}

normally, transferring contacts from one persons icloud to another's is pretty straight forward (there's an export button on icloud.com), but if you can't succesfully auth to icloud it gets a lot trickier. there's probably a few ways to do this, but the tack i ended up taking was:

1.  find a totally different source for the contacts (in this case, my grandfather's outlook 2010 install)
2.  export those contacts to vcards
3.  import those vcards to icloud.com under the new account

That is the bones of what happened, but the details kept screwing me over.


### specifics {#specifics}

first, outlook 2010 contact exports by default come out in an outlook specific format (.msg) that cannot be imported into icloud. ok well fine, surely there's a straight forward way to deal with that.

good news: you can directly export contacts from outlook to vcf
bad news: its fucking hidden behind a "send as business card" dialogue option that is fucking unintuitive. thanks 2010 microsoft.
worse news: it sends a very old .vcf format, 2.1. The minimum I could get working with icloud was 3.0

ok well surely you can convert the 2.1 version to 3.0? in fact, what is even the difference? here is some wikipedia examples:

```text
BEGIN:VCARD
VERSION:2.1
N:Gump;Forrest;;Mr.
FN:Forrest Gump
ORG:Bubba Gump Shrimp Co.
TITLE:Shrimp Man
PHOTO;GIF:http://www.example.com/dir_photos/my_photo.gif
TEL;WORK;VOICE:(111) 555-1212
TEL;HOME;VOICE:(404) 555-1212
ADR;WORK;PREF:;;100 Waters Edge;Baytown;LA;30314;United States of America
LABEL;WORK;PREF;ENCODING=QUOTED-PRINTABLE;CHARSET=UTF-8:100 Waters Edge=0D=
 =0ABaytown\, LA 30314=0D=0AUnited States of America
ADR;HOME:;;42 Plantation St.;Baytown;LA;30314;United States of America
LABEL;HOME;ENCODING=QUOTED-PRINTABLE;CHARSET=UTF-8:42 Plantation St.=0D=0A=
 Baytown, LA 30314=0D=0AUnited States of America
EMAIL:forrestgump@example.com
REV:20080424T195243Z
END:VCARD
```

```text
BEGIN:VCARD
VERSION:3.0
N:Gump;Forrest;;Mr.;
FN:Forrest Gump
ORG:Bubba Gump Shrimp Co.
TITLE:Shrimp Man
PHOTO;VALUE=URI;TYPE=GIF:http://www.example.com/dir_photos/my_photo.gif
TEL;TYPE=WORK,VOICE:(111) 555-1212
TEL;TYPE=HOME,VOICE:(404) 555-1212
ADR;TYPE=WORK,PREF:;;100 Waters Edge;Baytown;LA;30314;United States of America
LABEL;TYPE=WORK,PREF:100 Waters Edge\nBaytown\, LA 30314\nUnited States of America
ADR;TYPE=HOME:;;42 Plantation St.;Baytown;LA;30314;United States of America
LABEL;TYPE=HOME:42 Plantation St.\nBaytown\, LA 30314\nUnited States of America
EMAIL:forrestgump@example.com
REV:2008-04-24T19:52:43Z
END:VCARD
```

the thing that caused most of the issues for the contact set I was working on was the `TEL;` lines. the type declarations, when present, needed to be altered. to fix this is pretty simple:

```shell
cat /path/to/dir/* > all-outlook-contacts.vcf
sed -e 's/TEL;/TEL;TYPE=/g' -e 's/VERSION:2.1/VERSION:3.0/g' ../new-contacts/all-outlook-contacts.vcf > ../new-contacts/all-CLEANED.vcf
```

yes thats right, ' i am very 3 now ' is most of the work lmao. this worked, but I still couldn't import the vcf files to icloud - it would think for a while, then error saying that at least one of the entries was unreadable. i skimmed through the file visually and found some lines that were interesting - on a few cards there was a LANGUAGE declaration:

```shell
cat ../new-contacts/all-outlook-contacts.vcf | grep =en
>N;LANGUAGE=en-us:last first
>N;LANGUAGE=en-us:last first
>N;LANGUAGE=en-us:last first
>N;LANGUAGE=en-us:last first
```

wtf is that, that isn't mentioned in the spec until vcards 4.0

my best guess is that this is just some Fancy Colour from outlook specifically, because nobody else was talking about this based on quick google searches. I just removed it from these 4 cards and went on to import them to icloud succesfully.


### what should i do when i die {#what-should-i-do-when-i-die}

the lesson i learned during this process is:

-   don't close people's accounts right away; make sure everything is prepared before accounts are closed.
-   by the time i die i should establish a fucking runbook to go over the necessary steps for people who aren't technically inclined
-   open formats are great

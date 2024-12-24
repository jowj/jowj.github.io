+++
title = "blogging on github pages with orgmode"
date = 2020-04-11
author = ["josiah"]
draft = false
+++

## what i did {#what-i-did}

i've just moved from using markdown and jekyll to generate a static website on github pages to using org-mode and org-publish to generate static html files, also on github pages.


## why did i do this {#why-did-i-do-this}

my setup has been a pain - i do most of my writing and thinking in [org mode](https://orgmode.org/), but to post stuff on <https://me.jowj.net/> i have to convert that to markdown (relatively easy, due to a package called [ox-md](https://github.com/emacsmirror/org/blob/master/lisp/ox-md.el)) and use [jekyll](https://jekyllrb.com/) to convert md to html and handle the generation of the site. the problem with jekyll is that it _sucks_. its a tool based on the ruby ecosystem, and since I actually publish my stuff so infrequently every time i use it i have to update something about my ruby environment. this adds probably 10-20 minutes while I remember / look up which commands i'm supposed to run and why, and figuring out what things are actually broken this time.

theming in jekyll i also don't really enjoy. i think its a fine way to get started with an easy, responsive look to a blog, but if you wanna have more particular say about it you probably will end up writing your own css.

i wanted a way to handle multiple rss feeds; i wanted to be able to blog about personal bullshit AND project/technical work in the same site. obviously, most people are not going to give a shit about both of those things at the same time, so separating the rss feeds out seemed like a pretty straightforward way of handling that! ultimately this was harder than i wanted it to be, but it does seem to work!

i also just thought it would be cool to do everything within emacs (because my brain is broken lol). now the site is built with emacs and org mode entirely!


## how it works {#how-it-works}

most of the configuration and automation is in two files: [publish.el](https://github.com/jowj/jowj.github.io/blob/master/publish.el) and [Makefile](https://github.com/jowj/jowj.github.io/blob/master/Makefile) (raw links, also pasted below). publish.el has by far the most stuff in it, Makefile is just stupid simple automation.


### publish.el {#publish-dot-el}

i cribbed from several places to build this. in particular, two folks had done something similar and i referred to their work heavily. see the [credits &amp; references](#credits-and-references) entry.

one of the ways I differed from some of the other configurations I referenced was that i wanted the publishing process to be distinct from my personal [emacs configuration](https://git.awful.club/jowj/chd/src/branch/master/.emacs.d). publishing from within emacs itself is pretty cool, but it'll be cooler when i can publish by just uploading .org files and having github actions run a container and my publishing function on `git push`. i'm not there yet but [some people are doing this already with gitlab](https://gjhenrique.com/meta.html).

since i won't be using my personal emacs config, i'll have to setup package management here as well:

<a id="code-snippet--handle package setup"></a>
```elisp
;;;; package setup
(require 'ox-publish)
(package-initialize)

(require 'package)
(setq package-archives
      '(("melpa" . "http://melpa.milkbox.net/packages/")
        ("gnu" . "http://elpa.gnu.org/packages/")
        ("elpy" . "http://jorgenschaefer.github.io/packages/")))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(use-package htmlize
  :ensure t)

(use-package webfeeder
  :ensure t)
```

man i got SO stuck on how to do syntax highlighting AND use my own custom css. if you use the stock html and css templates that ship with org mode (i.e. don't customize anything at all) you can easily add syntax highlighting using the `htmlize` package. if you override the stock templates then you don't get syntax highlighting by default!!

the actual solution ended up being so simple i'm mad its not in any of the documentation I found expressly, so I'm going to make sure i write a googlable phrase about it:

-   "fix syntax highlighting when using custom css in emacs org mode by defining font-locks manually."

<!--listend-->

<a id="code-snippet--fix syntax highlighting."></a>
```elisp
;; fucking custom colors eluded me until this shit.
;; reference this guy's setup, he's a king:
;; https://gitlab.com/jgkamat/jgkamat.gitlab.io/-/blob/master/jgkamat-website.el
(when noninteractive
  ;; Don't run in interactive mode to avoid breaking your colors
  (custom-set-faces
   '(default                      ((t (:foreground "#909396" :background "#262626"))))
   '(font-lock-builtin-face       ((t (:foreground "#598249"))))
   '(font-lock-comment-face       ((t (:foreground "#5e6263"))))
   '(font-lock-constant-face      ((t (:foreground "#15968D"))))
   '(font-lock-function-name-face ((t (:foreground "#2F7BDE"))))
   '(font-lock-keyword-face       ((t (:foreground "#598249"))))
   '(font-lock-string-face        ((t (:foreground "#15968D"))))
   '(font-lock-type-face		       ((t (:foreground "#598249"))))
   '(font-lock-variable-name-face ((t (:foreground "#2F7BDE"))))
   '(font-lock-warning-face       ((t (:foreground "#bd3832" :weight bold)))))
  (setq htmlize-use-rgb-map 'force))
```

ok so that's all the like 'setup' type shit out of the way. after that i ran into several frustrating org mode limitations or...decisions made by org mode that make blogging with it a bit of a pain. A ton of the config is dedicated to working around those problems.

-   why the fuck is an 'html validation link' part of the default postamble config? who is this useful for?
-   why does the largest orgmode package built for static site generation for org mode think you want to build off of a single org mode file with blog posts as headings?
    -   that is stupid. org-mode itself doesn't care about your file hierarchy and neither should you :|
-   why is defining a custom stylesheet such a pain in the dick lmao.
    -   there's a like a million ways to do this, ranging from updating default variables to adding it in every single .org file, but they all have frustrating limitations!
-   having nav buttons at the top or side of the screen for different categories is pretty basic but unsupported by default. you have to write your own weird hack for this; i chose to add it to the preamble on every page using dynamic file name expansion, but i saw several different solutions to this problem:
    -   some people did it in the preamble like me
    -   some people did it in the postamble
    -   some people created a file called like "nav.org" and used org-mode `includes` on every page to reference it. I thought this was the ugliest option in general, but its by far the easiest!

<!--listend-->

```elisp
;;;; custom var/func defs to deal with frustrating org limitations
(setq make-backup-files nil)
(setq org-html-postamble t
      org-html-validation-link nil)

(defvar org-blog-date-format "%h %d, %Y"
  "Format for displaying publish dates.")

(defvar jlj/root (expand-file-name "."))
(defvar org-blog-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"css/my-dark.css\"/>")
(defvar org-personal-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"../posts/css/my-dark.css\"/>")
(defvar org-index-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"posts/css/my-dark.css\"/>")

(defun jlj/preamble (info)
  "Return preamble as a string.  INFO."
  "This is required to dynamically link shit depending on where you on in the folder structure."
  (let* ((file (plist-get info :input-file))
         (prefix (file-relative-name (expand-file-name jlj/root)
                                     (file-name-directory file))))
    (format
     "<a href=\"%1$s/index.html\">home</a>
<a href=\"%1$s/posts/articles.html\">essays</a>
<a href=\"%1$s/personal/articles.html\">diary</a>
<a href=\"https://git.awful.club/projects\">projects</a>
<a href=\"%1$s/resume.pdf\">resume</a>"
     prefix)))

(setq org-html-postamble-format `(("en" ,(concat "<p class=\"creator\">Made with %c</p></p>"))))
(setq org-html-preamble #'jlj/preamble)
```

`org-publish-project-alist` is the meat of the static site generation. you define a list of components of your site and have different variable settings for each component. i have several different components created:

-   `site-org` publishes all my technical writing.
-   `site-index` publishes just my home page.
-   `site-personal` publishes my diary entries.
-   `site-static` is currently not doing what I want it to! its _supposed_ copy ANY file that is not a .org file and publish it, but it doesn't seem to be doing that. I'm <span class="underline">very</span> certain its just because I don't understand its arguments well, so, like, don't copy my config about that. its still being worked on!

`jlj/publish-sitemap` is a function that wraps `org-publish-sitemap` and adds in my own css file. as far as I can tell, there is NO OTHER WAY to get the sitemap file generated by the `org-publish-project-alist` declarations to use custom css. infuriating.  because this is emacs and org mode there are of course other work-arounds possible here, but!! this should not require a work around, this is basic!!

<a id="code-snippet--Configuring org-publish-project-alist"></a>
```elisp
(setq org-publish-project-alist
      (list
       (list "site-org"
             :base-directory "./source"
             :recursive t
             :exclude "index.org"
             :publishing-function '(org-html-publish-to-html)
             :publishing-directory "./posts/"
             :sitemap-title "a list of stuff i wrote"
             :sitemap-filename "articles.org"
             :auto-sitemap t
             :sitemap-style 'list
             :sitemap-sort-files 'anti-chronologically
             :html-html5-fancy t
             :html-doctype "html5"
             :html-head-include-default-style nil
             :html-head org-blog-head)
       (list "site-index"
             :base-directory "."
             :recursive nil
             :publishing-function '(org-html-publish-to-html)
             :publishing-directory "."
             :html-head org-index-head)
       (list "site-personal"
             :base-directory "./personal-source"
             :recursive t
             :exclude "index.org"
             :publishing-function '(org-html-publish-to-html)
             :publishing-directory "./personal/"
             :sitemap-title "personal bullshit"
             :sitemap-filename "articles.org"
             :auto-sitemap t
             :sitemap-style 'list
             :sitemap-sort-files 'anti-chronologically
             :html-head-include-default-style nil
             :html-head org-personal-head)
       (list "site-static"
             :base-directory "."
             :base-extension 'any
             :exclude "\\.org\\'"
             :publishing-directory "."
             :publishing-function 'org-publish-attachment
             :recursive t)
       (list "site" :components '("site-org"))))



(defun jlj/publish-sitemap (title list)
  "Replace org-publish-sitemap.  TITLE and LIST are magic fuck u linter i won't do wat u tell me."

  (org-publish-sitemap
   (concat "#+TITLE: " title "\n"
          "#+HTML_HEAD: <link rel=\"stylesheet\" type=\"text/css\" href=\"css/my-dark.css\">"
          "\n"
          (org-list-to-org list)))
)
```

finally, i actually publish the site and then generate some rss feeds. i want so specifically talk about the rss feed generation; the most well known package for rss feed gen is [ox-rss](https://github.com/yyr/org-mode/blob/master/contrib/lisp/ox-rss.el) and i could not get that package to work. i used [webfeeder.el](https://gitlab.com/ambrevar/emacs-webfeeder/-/tree/master) and had much better luck with it.

its important to note that i wrap org-publish-all and the webfeeder lines with my own function `jlj/publish`. the org project <span class="underline">must</span> be published prior to the webfeeder feed generation. `webfeeder.el` works by generating a feed based on your .html files, not your .org files.

```elisp
(defun jlj/publish ()
    "Wrap org-publish-all so that its easier to modify this in the future."
    (org-publish-all)

    ;; build rss for interesting posts
    (setq webfeeder-default-author "josiah <me@jowj.net>")
    (webfeeder-build
     "rss.xml"
     "./posts"
     "https://me.jowj.net/posts/"

     (delete "index.html"
             (mapcar (lambda (f) (replace-regexp-in-string ".*/posts/" "" f))
                     (file-expand-wildcards "~/Documents/projects/jlj-blog/posts/*.html")))
     :builder 'webfeeder-make-rss
     :title "josiahs blog"
     :description "projects/writing bullshit in rss.")

    ;; build rss for diary posts
    (webfeeder-build
     "rss.xml"
     "./personal"
     "https://me.jowj.net/personal/"

     (delete "index.html"
             (mapcar (lambda (f) (replace-regexp-in-string ".*/personal/" "" f))
                     (file-expand-wildcards "~/Documents/projects/jlj-blog/personal/*.html")))
     :builder 'webfeeder-make-rss
     :title "josiahs diary"
     :description "personal bullshit in rss.")
  )
```


### Makefile {#makefile}

super easy makefile lol.

-   run emacs with no init file
-   tell it to load publish.el
-   tell it run my publishing function

on clean, tell it to remove a bunch of files and folders that gave me grief. many of these won't be generated anymore, i fixed the problem that necessitated me adding the corresponding line! but i leave it in anyway.

if you're unfamiliar with make you can still use this without learning _any_ make primitives, you can just, in the directory with the Makefile, run these commands:

-   `make` will build the site from scratch
-   `make clean` will delete all the generated files.

<!--listend-->

```makefile
# Makefile for jlj blog
.PHONY: all publish publish_no_init

all: publish

publish: publish.el
        @echo "Publishing...."
        emacs --no-init --script publish.el --funcall=jlj/publish

clean:
        @echo "Cleaning up.."
        @rm -rvf *.elc
        @rm -rvf posts/*.html
        @rm -fv index.html
        @rm -fv index.xml
        @rm -fv posts/articles.xml
        @rm -fv posts/rss.xml
        @rm -fv posts/atom.xml
        @rm -fv personal/*.html
        @rm -fv personal/rss.xml
        @rm -fv personal/atom.xml
        @rm -fv source/*.html
        @rm -rvf ~/.org-timestamps/*

```


## credits &amp; references {#credits-and-references}

there are a TON of places to read about doing this sort of thing. two folks in particular were really useful to me:

-   [Ambrevar](https://ambrevar.xyz/index.html),  (in particular, <https://ambrevar.xyz/blog-architecture/index.html>)
-   [jgkamat](https://jgkamat.gitlab.io/),  (in particular, <https://jgkamat.gitlab.io/blog/website1.html>)

jgkamat's publish files lead me to the font-face-locking approach to custom syntax highlighting.
ambrevar actually wrote the webfeeder.el solution to the idiot org rss problem. both of these folks are fantastic.

-   <https://orgmode.org/worg/> has several useful entries on org &gt; html publishing
-   <https://www.brautaset.org/articles/2017/blogging-with-org-mode.html>
-   <https://opensource.com/article/20/3/blog-emacs>
-   <https://www.sadiqpk.org/blog/2018/08/08/blogging-with-org-mode.html>
-   a lot more i've forgotten.

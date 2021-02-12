;; this is a mess of a publish file.
;; a lot is taken from ambrevar's writing, which is here: https://gitlab.com/ambrevar/ambrevar.gitlab.io/blob/mastr/epublish.el
;; the rest is scraped together from random other blogs which I forget.

;;;; package setup
(require 'ox-publish)
(package-initialize)
(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "http://elpa.gnu.org/packages/")
	("elpy" . "http://jorgenschaefer.github.io/packages/")))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(require 'cl)

(use-package htmlize
  :ensure t)

;; idiot code specific linting /build problems
(setq python-indent-guess-indent-offset t)
(setq python-indent-guess-indent-offset-verbose nil)


;; configure org tooltips -> html!
(load-file (concat default-directory "org-special-block-extras.el"))
(add-hook #'org-mode-hook #'org-special-block-extras-mode)


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
  (setq htmlize-use-rgb-map 'force)
  (require 'htmlize))

;; handle rss feed creation
(use-package webfeeder
  :ensure t)

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

(defun jlj/publish ()
    "Wrap org-publish-all so that its easier to modify this in the future."
    (org-publish-all)

    ;; build rss for interesting posts
    (setq webfeeder-default-author "josiah <me@jowj.net>")
    (webfeeder-build
     "rss.xml"
     "./posts"
     "https://me.jowj.net/posts/"

     (delete "articles.html"
    	     (mapcar (lambda (f) (replace-regexp-in-string ".*/posts/" "" f))
    		     (file-expand-wildcards "~/Documents/projects/jowj.github.io/posts/*.html")))
     :builder 'webfeeder-make-rss
     :title "josiahs blog"
     :description "projects/writing bullshit in rss.")

    ;; build rss for diary posts
    (webfeeder-build
     "rss.xml"
     "./personal"
     "https://me.jowj.net/personal/"

     (delete "articles.html"
    	     (mapcar (lambda (f) (replace-regexp-in-string ".*/personal/" "" f))
    		     (file-expand-wildcards "~/Documents/projects/jowj.github.io/personal/*.html")))
     :builder 'webfeeder-make-rss
     :title "josiahs diary"
     :description "personal bullshit in rss.")
  )


(provide 'publish)
;;; publish.el ends here


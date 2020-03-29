;; this is a mess of a publish file.
;; a lot is taken from ambrevar's writing, which is here: https://gitlab.com/ambrevar/ambrevar.gitlab.io/blob/master/publish.el
;; the rest is scraped together from random other blogs which I forget.

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

(use-package htmlize)
(use-package webfeeder)

;;;; custom var/func defs to deal with frustrating org limitations

(setq make-backup-files nil)
(defvar jlj/root (expand-file-name "."))

(defun jlj/git-creation-date (file)
  "Return the first commit date of FILE.
Format is %Y-%m-%d."
  (with-temp-buffer
    (call-process "git" nil t nil "log" "--reverse" "--date=short" "--pretty=format:%cd" file)
    (goto-char (point-min))
    (buffer-substring-no-properties (line-beginning-position) (line-end-position))))

(defun jlj/git-last-update-date (file)
  "Return the last commit date of FILE.
Format is %Y-%m-%d."
  (with-output-to-string
    (with-current-buffer standard-output
      (call-process "git" nil t nil "log" "-1" "--date=short" "--pretty=format:%cd" file))))

(defun jlj/org-publish-find-date (file project)
  "Find the date of FILE in PROJECT.
Just like `org-publish-find-date' but do not fall back on file
system timestamp and return nil instead."
  (let ((file (org-publish--expand-file-name file project)))
    (or (org-publish-cache-get-file-property file :date nil t)
	(org-publish-cache-set-file-property
	 file :date
	   (let ((date (org-publish-find-property file :date project)))
	     ;; DATE is a secondary string.  If it contains
	     ;; a time-stamp, convert it to internal format.
	     ;; Otherwise, use FILE modification time.
             (let ((ts (and (consp date) (assq 'timestamp date))))
	       (and ts
		    (let ((value (org-element-interpret-data ts)))
		      (and (org-string-nw-p value)
			   (org-time-string-to-time value))))))))))

(defun jlj/org-publish-sitemap-entry (entry style project)
  "Custom format for site map ENTRY, as a string.
See `org-publish-sitemap-default-entry'."
  (cond ((not (directory-name-p entry))
         (let* ((meta-date (jlj/org-publish-find-date entry project))
                (file (expand-file-name entry
                                        (org-publish-property :base-directory project)))
                (creation-date (if (not meta-date)
                                   (jlj/git-creation-date file)
                                 ;; Default to the #+DATE value when specified.  This
                                 ;; can be useful, for instance, when Git gets the file
                                 ;; creation date wrong if the file was renamed.
                                 (format-time-string "%Y-%m-%d" meta-date)))
                (last-date (jlj/git-last-update-date file)))
           (format "[[file:%s][%s]]^{ (%s)}"
                   entry
                   (org-publish-find-title entry project)
                   (if (string= creation-date last-date)
                       creation-date
                     (format "%s, updated %s" creation-date last-date)))))
	((eq style 'tree)
	 ;; Return only last subdir.
	 (capitalize (file-name-nondirectory (directory-file-name entry))))
	(t entry)))


(defun jlj/preamble (info)
  "Return preamble as a string."
  (let* ((file (plist-get info :input-file))
         (prefix (file-relative-name (expand-file-name "source" jlj/root)
                                     (file-name-directory file))))
    (format
     "<a href=\"%1$s/index.html\">About</a>
<a href=\"%1$s/articles.html\">Articles</a>
<a href=\"%1$s/projects/index.html\">Projects</a>
<a href=\"%1$s/atom.xml\">Feed</a>" prefix)))

(setq org-html-postamble t
      org-html-postamble-format `(("en" ,(concat "<p class=\"date\">Date: %d</p>
<p class=\"creator\">Made with %c</p>")))
      ;; Use custom preamble function to compute relative links.
      org-html-preamble #'jlj/preamble
      ;; org-html-container-element "section"
      org-html-metadata-timestamp-format "%Y-%m-%d"
      org-html-checkbox-type 'html
      org-html-html5-fancy t
      ;; Use custom .css.  This removes the dependency on `htmlize', but then we
      ;; don't get colored code snippets.
      org-html-htmlize-output-type nil
      org-html-validation-link nil
      org-html-doctype "html5")

(defun jlj/org-publish-sitemap (title list)
  "blog site map, as a string.
See `org-publish-sitemap-default'. "
  ;; Remove index and non articles.
  ;; (setcdr list (seq-filter
  ;;               (lambda (file)
  ;;                 (string-match "file:[^ ]*/index.org" (car file)))
  ;;               (cdr list)))
  ;; TODO: Include subtitle?  It may be wiser, at least for projects.
  (concat "#+TITLE: " title "\n"
          "#+HTML_HEAD: <link rel=\"stylesheet\" type=\"text/css\" href=\"css/my-dark.css\">"
          "\n"
          "#+HTML_HEAD: <link rel=\"icon\" type=\"image/x-icon\" href=\"logo.png\"> "
          "\n"
          "#+HTML_HEAD: <link href=\"atom.xml\" type=\"application/atom+xml\" rel=\"alternate\" title=\"josiah's homepage\">"
          "\n\n"
          (org-list-to-org list)))


(setq org-publish-project-alist
      (list
       (list "site-org"
             :base-directory "./source/"
             :recursive t
             :publishing-function '(org-html-publish-to-html)
             :publishing-directory "public/"
             :sitemap-format-entry #'jlj/org-publish-sitemap-entry
             :auto-sitemap t
             :sitemap-title "Articles"
             :sitemap-filename "articles.org"
             ;; :sitemap-file-entry-format "%d *%t*"
             :sitemap-style 'list
             :sitemap-function #'jlj/org-publish-sitemap
             ;; :sitemap-ignore-case t
             :sitemap-sort-files 'anti-chronologically
             :html-head-include-default-style nil
             :html-head-include-scripts nil
             :html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"css/my-dark.css\">
<link rel=\"icon\" type=\"image/x-icon\" href=\"../logo.png\">
<link href=\"../atom.xml\" type=\"application/atom+xml\" rel=\"alternate\" title=\"y don't u blog about it\">")
       (list "site-static"
             :base-directory "./source/"
             :exclude "\\.org\\'"
             :base-extension 'any
             :publishing-directory "./public"
             :publishing-function 'org-publish-attachment
             :recursive t)
       (list "site" :components '("site-org"))))

(defun jlj/publish ()
  (org-publish-all)
  (setq webfeeder-default-author "josiah <me@jowj.net>")
  (webfeeder-build
   "rss.xml"
   "./public"
   "https://me.jowj.net/"
   (delete "index.html"
           (mapcar (lambda (f) (replace-regexp-in-string ".*/public/" "" f))
                   (directory-files-recursively "public" "index.html")))
   :builder 'webfeeder-make-rss
   :title "josiah's shitty blog"
   :description "(Abstract Abstract)")
  (webfeeder-build
   "atom.xml"
   "./public"
   "https://me.jowj.net/"
   (delete "index.html"
           (mapcar (lambda (f) (replace-regexp-in-string ".*/public/" "" f))
                   (directory-files-recursively "public" "index.html")))
   :title "josiah's shitty blog"
   :description "(Abstract Abstract)"))

(provide 'publish)
;;; publish.el ends here


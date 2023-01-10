;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

;; load the publishing system
(require 'ox-publish)

;; Define the project structure
(setq org-publish-project-alist
      (list
       (list "geokkjer.eu"
	     :recursive t
	     :base-directory "./content"
	     :publishing-directory "./public"
	     :publishing-function 'org-html-publish-to-html
	     :with-author nil
	     :with-creator t
	     :with-toc nil
	     :section-numbers nil
	     :time-stamp-file nil)))

;; customize thte html output
(setq org-html-validation-link nil
      org-html-head-include-scripts nil
      org-html-head-include-default-style nil
      ;; org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />")
      org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css\"> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">")

;; Generate the site output
(org-publish-all t)

(message "Site: geokkjer.eu built!")

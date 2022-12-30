;; Turns off the startup-message
(setq inhibit-startup-message t)

;; Disable UI-elements
(scroll-bar-mode -1)  ; Disable visible scrollbar
(tool-bar-mode -1)    ; Disable the toolbar
(tooltip-mode -1)     ; Disable tooltips
(set-fringe-mode 10)  ; Give us some breathing room

(menu-bar-mode -1)    ; Disable the menu bar

;; Set up the visual bell
(setq visible-bell t)

;; Setting to auto reload files
(setq auto-revert-mode t)

;; Doom stuff
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :custom ((doom-modeline-height 15)))

(use-package all-the-icons)

(use-package doom-themes
  :init (load-theme 'doom-dracula t))

;; Enable line numbers

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                vterm-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(defvar geokkjer/default-font-size 140)

(set-face-attribute 'default nil :font "MesloLGS NF" :height geokkjer/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "MesloLGS NF" :height 140)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "MesloLGS NF" :height 130 :weight 'regular)

;; Initialize package sources
(require 'package)

;; Set the repos
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package in case we are on non-Linux platform
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package swiper)

;; Ivy Configuration --------------------------
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-reverse-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reversee-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))


(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" .'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(defun efs/org-mode-setup ()
    (org-indent-mode)
    (variable-pitch-mode 1)
    (visual-line-mode 1))

    ;; Org Mode Configuration  

    (defun efs/org-font-setup ()
    ;; Replace list hyphen with dot
    (font-lock-add-keywords 'org-mode
                            '(("^ *\\([-]\\) "
                                (0 (prog1 () (compose-region
                                                (match-beginning1)
                                                (match-end 1)
                                                "•")))))))

    ;; Show overview when open
    (setq org-startup-folded t)

    ;; Set faces for heading levels
    (with-eval-after-load 'org-faces
    (dolist (face '((org-level-1 . 1.2)
                    (org-level-2 . 1.1)
                    (org-level-3 . 1.05)
                    (org-level-4 . 1.0)
                    (org-level-5 . 1.1)
                    (org-level-6 . 1.1)
                    (org-level-7 . 1.1)
                    (org-level-8 . 1.1)))
        (set-face-attribute (car face) nil :font "MesloLGS NF" :weight 'regular
                            :height (cdr face))

        ;; Ensure that anything that should be fixed-pitch in Org files appears that way
        (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
        (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
        (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
        (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
        (set-face-attribute 'org-special-keyword nil :inherit
                            '(font-lock-comment-face fixed-pitch))
        (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face
                                                        fixed-pitch))
        (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)))

(use-package org
    :hook (org-mode . efs/org-mode-setup)
    :config
    (setq org-ellipsis " ▾")

    (use-package org-bullets
    :after org
    :hook (org-mode . org-bullets-mode)
    :custom
    (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

    (defun efs/org-mode-visual-fill ()
    (setq visual-fill-column-width 100
            visual-fill-column-center-text t)
    (visual-fill-column-mode 1))

    (use-package visual-fill-column
    :hook (org-mode . efs/org-mode-visual-fill)))

(org-babel-do-load-languages
'org-babel-load-languages
'((emacs-lisp . t)
    (shell . t)
    (python . t)))

(push '("conf-unix" . conf-unix) org-src-lang-modes)

(setq org-confirm-babel-evaluate nil)

;; This is needed as of Org 9.2
(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("nx" . "src nix"))

;; Automaticly tangle Emacs.org on save
(defun geokkjer/org-babel-tangle-config ()
(when (string-equal (buffer-file-name)
                    (expand-file-name "~/Projects/Code/dotfiles/emacs/Emacs.org"))

    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
    (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'geokkjer/org-babel-tangle-config)))

;; Org-agenda config

(setq org-agenda-start-with-log-mode t)
(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-agenda-files
    '("~/Projects/Code/dotfiles/emacs/OrgFiles/Tasks.org"
        "~/Projects/Code/dotfiles/emacs/OrgFiles/Birthdays.org"
        "~/Projects/Code/dotfiles/emacs/OrgFiles/Habits.org"))

(require 'org-habit)
(add-to-list 'org-modules 'org-habit)
(setq org-habit-graph-column 60)

(setq org-refile-targets
    '(("Archive.org" :maxlevel . 1)
        ("Tasks.org" :maxlevel . 1)))

;; Save Org buffers after refiling!
(advice-add 'org-refile :after 'org-save-all-org-buffers)

(setq org-tag-alist
    '((:startgroup)
        ;; Put mutually exclusive tags here
        (:endgroup)
        ("@errand" . ?E)
        ("@home" . ?H)
        ("@work" . ?W)
        ("agenda" . ?a)
        ("planning" . ?p)
        ("publish" . ?P)
        ("batch" . ?b)
        ("note" . ?n)
        ("idea" . ?i)))

;; Configure custom agenda views
(setq org-agenda-custom-commands
    '(("d" "Dashboard"
        ((agenda "" ((org-deadline-warning-days 7)))
        (todo "NEXT"
                ((org-agenda-overriding-header "Next Tasks")))
        (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active
Projects")))))

        ("n" "Next Tasks"
        ((todo "NEXT"
                ((org-agenda-overriding-header "Next Tasks")))))

        ("W" "Work Tasks" tags-todo "+work-email")

        ;; Low-effort next actions
        ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
        ((org-agenda-overriding-header "Low Effort Tasks")
        (org-agenda-max-todos 20)
        (org-agenda-files org-agenda-files)))

        ("w" "Workflow Status"
        ((todo "WAIT"
                ((org-agenda-overriding-header "Waiting on External")
                (org-agenda-files org-agenda-files)))
        (todo "REVIEW"
                ((org-agenda-overriding-header "In Review")
                (org-agenda-files org-agenda-files)))
        (todo "PLAN"
                ((org-agenda-overriding-header "In Planning")
                (org-agenda-todo-list-sublevels nil)
                (org-agenda-files org-agenda-files)))
        (todo "BACKLOG"
                ((org-agenda-overriding-header "Project Backlog")
                (org-agenda-todo-list-sublevels nil)
                (org-agenda-files org-agenda-files)))
        (todo "READY"
                ((org-agenda-overriding-header "Ready for Work")
                (org-agenda-files org-agenda-files)))
        (todo "ACTIVE"
                ((org-agenda-overriding-header "Active Projects")
                (org-agenda-files org-agenda-files)))
        (todo "COMPLETED"
                ((org-agenda-overriding-header "Completed Projects")
                (org-agenda-files org-agenda-files)))
        (todo "CANC"
                ((org-agenda-overriding-header "Cancelled Projects")
                (org-agenda-files org-agenda-files)))))))


(setq org-capture-templates
    `(("t" "Tasks / Projects")
        ("tt" "Task" entry (file+olp
                            "~/Projects/Code/dotfiles/emacs/OrgFiles/Tasks.org"
                            "Inbox")
        "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

        ("j" "Journal Entries")
        ("jj" "Journal" entry
        (file+olp+datetree
        "~/Projects/Code/dotfiles/emacs/OrgFiles/Journal.org")
        "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
        ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
        :clock-in :clock-resume
        :empty-lines 1)
        ("jm" "Meeting" entry
        (file+olp+datetree
        "~/Projects/Code/dotfiles/emacs/OrgFiles/Journal.org")
        "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
        :clock-in :clock-resume
        :empty-lines 1)

        ("w" "Workflows")
        ("we" "Checking Email" entry (file+olp+date
                                    "~/Projects/Code/dotfiles/emacs/OrgFiles/Journal.org")
        "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines
        1)

        ("m" "Metrics Capture")
        ("mw" "Weight" table-line (file+headline
                                    "~/Projects/Code/dotfiles/emacs/OrgFiles/Metrics.org" "Weight")
        "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

(define-key global-map (kbd "C-c j")
(lambda () (interactive) (org-capture nil "jj")))

(efs/org-font-setup)

(defun geokkjer/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((lsp-mode . geokkjer/lsp-mode-setup)
         (lsp-mode . lsp-enable-which-key-integration))
  :init
  (setq lsp-keymap-prefix "C-c l"))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-psition 'bottom))

(setq lsp-ui-sidline-enable nil)
(setq lsp-ui-sideline-show-hover nil)

(use-package lsp-treemacs
  :after lsp)

(use-package web-mode)
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(setq web-mode-engines-alist '(("django" . "\\.html\\'")))

(use-package typescript-mode
:mode "\\.ts\\'"
:hook (typescript-mode . lsp-deferred)
:config
(setq typescript-indent-level 2))

(use-package python-mode
:mode "\\.py\\'"
:hook (python-mode . lsp-deferred)
:config
)

(use-package lsp-python-ms
:ensure t
:hook (python-mode . (lambda ()
                       (require 'lsp-python-ms)
                       (lsp-deferred)))
:init
(setq lsp-python-ms-executable (executable-find "python-language-server")))

(use-package go-mode)

(require 'lsp-mode)
(add-hook 'go-mode-hook #'lsp-deferred)

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
(add-hook 'before-save-hook #'lsp-format-buffer t t)
(add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

(use-package sql-indent)

(use-package nix-mode
:mode "\\.nix\\'")

(add-to-list 'lsp-language-id-configuration '(nix-mode . "nix"))
(lsp-register-client
(make-lsp-client :new-connection (lsp-stdio-connection '("rnix-lsp"))
                :major-modes '(nix-mode)
                :server-id 'nix))

(use-package scheme)



(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
          ("<tab>" . company-complete-section))
        (:map lsp-mode-map
          ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-orefix-lenght 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

;; rainbow-delimiters
(use-package rainbow-delimiters
:hook (prog-mode . rainbow-delimiters-mode))

(use-package flycheck
:ensure t
:init (global-flycheck-mode))

;; TODO learn to use projectile
(use-package projectile
:diminish
:config
:custom ((projectile-completion-system 'ivy))
:bind-keymap
("C-c p" . projectile-command-map)
:init
(when (file-directory-p "~/Projects/Code")
    (setq projectile-projects-search-path '("~/Projects/Code")))
(setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
:config (counsel-projectile-mode))

;; TODO learn git and Magit
(use-package magit
    :custom
    (magit-display-buffer-function
    #'magit-display-buffer-same-window-except-diff-v1))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package general
  :config
  (general-create-definer geokkjer/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  (geokkjer/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h")
    'evil-delete-backeard-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package hydra)
(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(geokkjer/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(use-package term
  :config
  (setq explicit-shell-file-name "bash")
  ;; (setq explicit-zsh-args '())
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package vterm
  :commands vterm
  :config
  ;; (setq vterm-shell "zsh")
  (setq vterm-max-scrollback 10000))

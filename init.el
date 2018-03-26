;;; init.el --- -*- lexical-binding: t; -*-
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;; some things to not forget about when using emacs!  For those who
;; don’t know: C-u 1 C-y is equivalent to plain C-y, but C-u 2 C-y (or
;; just C-2 C-y) inserts the previous killed text (much like C-y M-y),
;; and also marks it as the current one. With higher arguments, it
;; inserts earlier kills.

                                        ; general setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-verbose t)
(setq use-package-always-ensure t)
(require 'use-package)
(use-package auto-compile
  :config (auto-compile-on-load-mode))
(setq load-prefer-newer t)

(setq use-package-always-ensure t)
(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t))
(unless (assoc-default "org" package-archives)
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t))

;; Create own directory for ~ backup files
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; Disk space is cheap. Save lots.
(setq gc-cons-threshold 50000000)
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; fuck cursor lagging on moving
(setq auto-window-vscroll nil)

;; paren mode
(setq show-paren-mode t)

;; Disable window chrome
(tool-bar-mode 0)
(menu-bar-mode 0)
(when window-system
  (scroll-bar-mode -1))
(setq inhibit-startup-message t)
                                        ;      initial-scratch-message (format ";; %s\n" (adafruit-wisdom-select)))

;; stop truncating lines
(set-default 'truncate-lines t)
(setq truncate-partial-width-windows nil)


;; powerline is terrific
(use-package powerline
  :ensure t
  :config (powerline-center-theme))

(defadvice load-theme (before clear-previous-themes activate)
  "Clear existing theme settings instead of layering them"
  (mapc #'disable-theme custom-enabled-themes))


;; wrap visual lines! it helps.
(global-visual-line-mode 1)

;; im sick of yes-or-no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Fancy lambdas
(global-prettify-symbols-mode t)

;; screw the bell
(setq ring-bell-function 'ignore)

;; Scroll conservatively
(setq scroll-conservatively 100)

;; time on modeline is cool
(use-package time
  :ensure t
  :config
  (progn
    (setf display-time-default-load-average nil
          display-time-use-mail-icon t
          display-time-24hr-format t)
    (display-time-mode t)))

;; Font functionality
                                        ; iosevka, consolas, source code pro, Fira Code
(setq lp/default-font "Fira Code")
(setq lp/default-font-size 12)

(setq lp/current-font-size lp/default-font-size)

;; Define the factor that we should go by when increasing/decreasing
(setq lp/font-change-increment 1.1)

(defun lp/set-font-size ()
  "Set the font to 'lp/default-font' at 'lpcurrent-font-size'."
  (set-frame-font
   (concat lp/default-font "-" (number-to-string lp/current-font-size))))

(defun lp/reset-font-size ()
  "Change font back to default size"
  (interactive)
  (setq lp/current-font-size lp/default-font-size)
  (lp/set-font-size))

(defun lp/increase-font-size ()
  "increase current font size by a factor of 'lp/font-change-increment'."
  (interactive)
  (setq lp/current-font-size
        (ceiling (* lp/current-font-size lp/font-change-increment)))
  (lp/set-font-size))

(defun lp/decrease-font-size ()
  (interactive)
  (setq lp/current-font-size
        (floor (/ lp/current-font-size lp/font-change-increment)))
  (lp/set-font-size))

(define-key global-map (kbd "C-0") 'lp/reset-font-size)
(define-key global-map (kbd "C-=") 'lp/increase-font-size)
(define-key global-map (kbd "C--") 'lp/decrease-font-size)

(lp/reset-font-size)

;; (mapc
;;  (lambda (face)
;;    (set-face-attribute
;;     face
;;     'nil
;;     :family "Fira Code"
;;     :height 130
;;     :width 'normal
;;     :weight 'normal))
;;  '(default))
                                        ; (set-face-attribute
                                        ;  'variable-pitch
                                        ;  'nil
                                        ;  :family "Helvetica Neue"
                                        ;  :height 150)

;; linum mode with spaces? TODO / WIP
;; (global-linum-mode 1)
;; (defadvice linum-update-window (around linum-dynamic activate)
;;   (let* ((w (length (number-to-string
;;                      (count-lines (point-min) (point-max)))))
;;          (linum-format (concat " %" (number-to-string w) "d ")))
;;     ad-do-it))
;;(setq fci-rule-color (face-attribute 'linum :foreground))

;; Fill column
(setq fci-rule-column 80)


;; global-hl-line-mode softly highlights bg color of line. Its nice.
(when window-system
  (global-hl-line-mode))

                                        ; useful functions + keybinds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun lp/kill-current-buffer ()
  "Just kill the buffer man (no prompt when killing buffer)"
  (interactive)
  (kill-buffer (current-buffer)))

(defun lp/generate-scratch-buffer ()
  (interactive)
  (switch-to-buffer (make-temp-name "scratch-")))

(defun lp/cleanup-buffer-safe ()
  "Perform a bunch of safe operations on whitespace content. Does
  not indent buffer!"
  (interactive)
  (untabify (point-min) (point-max))
  (delete-trailing-whitespace)
  (set-buffer-file-coding-system 'utf-8))
(defun lp/cleanup-buffer ()
  "Perform bunch of operations on the whitespace content of buffer."
  (interactive)
  (lp/cleanup-buffer-safe)
  (indent-region (point-min) (point-max)))


;; Always killcurrent buffer
(global-set-key (kbd "C-x k") 'lp/kill-current-buffer)

;; Look for executables in bin
(setq exec-path (append exec-path '("/user/local/bin")))

;; Always use spaces for indentation
;; fuck tabs
(setq-default indent-tabs-mode nil)

;; Lets bind C-c C-k to compile buffer
(global-set-key (kbd "C-c C-k") 'eval-buffer)

;; hippie expand is quite nice for aut-completing
(global-set-key (kbd "M-/") 'hippie-expand)
                                        ;(global-set-key (kbd "M-o") 'other-window)

;; Gotta keep those buffers clean
(global-set-key (kbd "C-c n") 'lp/cleanup-buffer)
(global-set-key (kbd "C-c C-n") 'lp/cleanup-buffer)

;; Open up a randomly generated scratch buffer (cause i like scratch buffers)
(global-set-key (kbd "<f12>") 'lp/generate-scratch-buffer)

;; Compile on a keybind
(global-set-key (kbd "C-<f7>") 'compile)

;; Quickly comment region
(global-set-key (kbd "C-<f8>") 'comment-or-uncomment-region)

;; fuk these defaults
(global-set-key (kbd "M-g") #'goto-line)

;; pop to the last command mark! its cool.
(bind-key "C-x p" 'pop-to-mark-command)
(setq set-mark-command-repeat-pop t)

                                        ; window management
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Window management - Balance, switching, and splitting

;; I almost always want to switch to a window when I split. So lets do that.

(defun lp/split-window-below-and-switch ()
  "Split window horizontally, then switch to that new window"
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))

(defun lp/split-window-right-and-switch ()
  "Split the window vertically, then switch to the new pane."
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))

(global-set-key (kbd "C-x 2") 'lp/split-window-below-and-switch)
(global-set-key (kbd "C-x 3") 'lp/split-window-right-and-switch)


;; ace-window stuff

;; You can also start by calling ace-window and then decide to switch the action to delete or swap etc. By default the bindings are:

;;     x - delete window
;;     m - swap windows
;;     M - move window
;;     j - select buffer
;;     n - select the previous window
;;     u - select buffer in the other window
;;     c - split window fairly, either vertically or horizontally
;;     v - split window vertically
;;     b - split window horizontally
;;     o - maximize current window
;;     ? - show these command bindings

(use-package ace-window
  :ensure t
  :bind ("M-o" . ace-window)
  :config
  (progn
    (setq  aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))))



;;; Hide a whole bunch of stuff on the modeline. It's a bit annoying.
;;; Using the =diminish= package for this.
(use-package diminish
  :ensure t
  :config
  (progn
    (defmacro diminish-minor-mode (filename mode &optional abbrev)
      `(eval-after-load (symbol-name ,filename)
         '(diminish ,mode ,abbrev)))

    (defmacro diminish-major-mode (mode-hook abbrev)
      `(add-hook ,mode-hook
                 (lambda () (setq mode-name ,abbrev))))

    (diminish-minor-mode 'abbrev 'abbrev-mode)
    (diminish-minor-mode 'simple 'auto-fill-function)
    (diminish-minor-mode 'company 'company-mode)
    (diminish-minor-mode 'eldoc 'eldoc-mode)
    (diminish-minor-mode 'flycheck 'flycheck-mode)
    (diminish-minor-mode 'flyspell 'flyspell-mode)
    (diminish-minor-mode 'global-whitespace 'global-whitespace-mode)
    (diminish-minor-mode 'projectile 'projectile-mode)
    (diminish-minor-mode 'ruby-end 'ruby-end-mode)
    (diminish-minor-mode 'subword 'subword-mode)
    (diminish-minor-mode 'undo-tree 'undo-tree-mode)
    (diminish-minor-mode 'yard-mode 'yard-mode)
    (diminish-minor-mode 'yasnippet 'yas-minor-mode)
    (diminish-minor-mode 'wrap-region 'wrap-region-mode)
    (diminish-minor-mode 'paredit 'paredit-mode " π")
    (diminish-major-mode 'emacs-lisp-mode-hook "el")
    (diminish-major-mode 'haskell-mode-hook "λ=")
    (diminish-major-mode 'lisp-interaction-mode-hook "λ")
    (diminish-major-mode 'python-mode-hook "Py")))




                                        ; lisps
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; I'd prefer that compilation output goes to *compilation buffer*
;;; Rarely have the window selected, so the output disappears past the
;;; bottom of the window
(setq compilation-scroll-output t)
(setq compilation-window-height 15)


;; quicktramp setup
(setq tramp-default-method "ssh")
(use-package paredit
  :ensure t)
(use-package rainbow-delimiters
  :ensure t)
;; We want all lispy languages to use =paredit-mode= and =rainbow-delimiters
(setq lisp-mode-hooks
      '(clojure-mode-hook
        emacs-lisp-mode-hook
        lisp-mode-hook
        scheme-mode-hook)) ; can add more or whatever


(dolist (hook lisp-mode-hooks)
  (add-hook hook (lambda ()
                   (setq show-paren-style 'expression)
                   (paredit-mode)
                   (rainbow-delimiters-mode))))
                                        ; (add-hook 'text-mode-hook 'hook-function)


                                        ; programming environment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Magit
;; God bless magit and all that it does
(use-package magit  :ensure t
  :commands magit-status magit-blame
  :init
  (defadvice magit-status (around magit-fullscreen activate)
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))
  :config
  (setq magit-branch-arguments nil
        ;; use ido to look for branches
        magit-completing-read-function 'magit-ido-completing-read
        ;; don't put "origin-" in front of new branch names by default
        magit-default-tracking-name-function 'magit-default-tracking-name-branch-only
        magit-push-always-verify nil
        ;; Get rid of the previous advice to go into fullscreen
        magit-restore-window-configuration t)

  :bind ("C-x g" . magit-status))

;;; Dired
;; clean up permissions and owners, less noisy
(add-hook 'dired-mode-hook
          (lambda ()
            (dired-hide-details-mode 1)))
;; disable ls by default
(setq dired-use-ls-dired nil)

(use-package projectile
  :ensure t
  :config
  (progn
    (require 'projectile)

    ;; Projectile everywhere obviously
    (projectile-global-mode)

    (defun lp/search-project-for-symbol-at-point ()
      "Use projectile-ag to search current project for the current symbol."
      (interactive)
      (projectile-ag (projectile-symbol-at-point)))
    (global-set-key  (kbd "C-c v") 'projectile-ag)
    (global-set-key (kbd "C-c C-v") 'lp/search-project-for-symbol-at-point)))





                                        ; eshell my goodness
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; chec kout
;; [[https://github.com/howardabrams/dot-files/blob/master/emacs-eshell.org][this
;; guy]] for some of his amazing eshell config

;;; Currently using eshell for my shell sessions. Bound to C-c s.
;; Going to do some setup for this though
(setenv "PATH"
        (concat
         "/usr/local/bin:/usr/local/sbin:"
         (getenv "PATH")))
(use-package eshell
  :init
  (setq ;; eshell-buffer-shorthand t ...  Can't see Bug#19391
   eshell-scroll-to-bottom-on-input 'all
   eshell-error-if-no-glob t
   eshell-hist-ignoredups t
   eshell-save-history-on-exit t
   eshell-prefer-lisp-functions nil
   eshell-destroy-buffer-when-process-dies t))


(add-hook 'eshell-mode-hook (lambda ()
                              (eshell/alias "e" "find-file $1")
                              (eshell/alias "ff" "find-file $1")
                              (eshell/alias "emacs" "find-file $1")
                              (eshell/alias "ee" "find-file-other-window $1")

                              (eshell/alias "gd" "magit-diff-unstaged")
                              (eshell/alias "gds" "magit-diff-staged")
                              (eshell/alias "d" "dired $1")

                              ;; The 'ls' executable requires the Gnu version on the Mac
                              (let ((ls (if (file-exists-p "/usr/local/bin/gls")
                                            "/usr/local/bin/gls"
                                          "/bin/ls")))
                                (eshell/alias "ll" (concat ls " -AlohG --color=always")))))

(global-set-key (kbd "C-c s") 'eshell)

;; Change up some
(defun curr-dir-git-branch-string (pwd)
  "Returns current git branch as a string, or the empty string if
PWD is not in a git repo (or the git command is not found)."
  (interactive)
  (when (and (not (file-remote-p pwd))
             (eshell-search-path "git")
             (locate-dominating-file pwd ".git"))
    (let* ((git-url (shell-command-to-string "git config --get remote.origin.url"))
           (git-repo (file-name-base (s-trim git-url)))
           (git-output (shell-command-to-string (concat "git rev-parse --abbrev-ref HEAD")))
           (git-branch (s-trim git-output))
           (git-icon  "\xe0a0")
           (git-icon2 (propertize "\xf020" 'face `(:family "octicons"))))
      (concat git-repo " " git-icon2 " " git-branch))))

(defun pwd-replace-home (pwd)
  "Replace home in PWD with tilde (~) character."
  (interactive)
  (let* ((home (expand-file-name (getenv "HOME")))
         (home-len (length home)))
    (if (and
         (>= (length pwd) home-len)
         (equal home (substring pwd 0 home-len)))
        (concat "~" (substring pwd home-len))
      pwd)))

(defun pwd-shorten-dirs (pwd)
  "Shorten all directory names in PWD except the last two."
  (let ((p-lst (split-string pwd "/")))
    (if (> (length p-lst) 2)
        (concat
         (mapconcat (lambda (elm) (if (zerop (length elm)) ""
                                    (substring elm 0 1)))
                    (butlast p-lst 2)
                    "/")
         "/"
         (mapconcat (lambda (elm) elm)
                    (last p-lst 2)
                    "/"))
      pwd)))  ;; Otherwise, we just return the PWD

(defun split-directory-prompt (directory)
  (if (string-match-p ".*/.*" directory)
      (list (file-name-directory directory) (file-name-base directory))
    (list "" directory)))

(defun ruby-prompt ()
  "Returns a string (may be empty) based on the current Ruby Virtual Environment."
  (let* ((executable "~/.rvm/bin/rvm-prompt")
         (command    (concat executable "v g")))
    (when (file-exists-p executable)
      (let* ((results (shell-command-to-string executable))
             (cleaned (string-trim results))
             (gem     (propertize "\xe92b" 'face `(:family "alltheicons"))))
        (when (and cleaned (not (equal cleaned "")))
          (s-replace "ruby-" gem cleaned))))))

(defun python-prompt ()
  "Returns a string (may be empty) based on the current Python
   Virtual Environment. Assuming the M-x command: `pyenv-mode-set'
   has been called."
  (when (fboundp #'pyenv-mode-version)
    (let ((venv (pyenv-mode-version)))
      (when venv
        (concat
         (propertize "\xe928" 'face `(:family "alltheicons"))
         (pyenv-mode-version))))))

(defun eshell/eshell-local-prompt-function ()
  "A prompt for eshell that works locally (in that is assumes
that it could run certain commands) in order to make a prettier,
more-helpful local prompt."
  (interactive)
  (let* ((pwd        (eshell/pwd))
         (directory (split-directory-prompt
                     (pwd-shorten-dirs
                      (pwd-replace-home pwd))))
         (parent (car directory))
         (name   (cadr directory))
         (branch (curr-dir-git-branch-string pwd))
         (ruby   (when (not (file-remote-p pwd)) (ruby-prompt)))
         (python (when (not (file-remote-p pwd)) (python-prompt)))

         (dark-env (eq 'dark (frame-parameter nil 'background-mode)))
         (for-bars                 `(:weight bold))
         (for-parent  (if dark-env `(:foreground "dark orange") `(:foreground "blue")))
         (for-dir     (if dark-env `(:foreground "orange" :weight bold)
                        `(:foreground "blue" :weight bold)))
         (for-git                  `(:foreground "green"))
         (for-ruby                 `(:foreground "red"))
         (for-python               `(:foreground "#5555FF")))

    (concat
     (propertize "⟣─ "    'face for-bars)
     (propertize parent   'face for-parent)
     (propertize name     'face for-dir)
     (when branch
       (concat (propertize " ── "    'face for-bars)
               (propertize branch   'face for-git)))
     (when ruby
       (concat (propertize " ── " 'face for-bars)
               (propertize ruby   'face for-ruby)))
     (when python
       (concat (propertize " ── " 'face for-bars)
               (propertize python 'face for-python)))
     (propertize "\n"     'face for-bars)
     (propertize (if (= (user-uid) 0) " #" " $") 'face `(:weight ultra-bold))
     ;; (propertize " └→" 'face (if (= (user-uid) 0) `(:weight ultra-bold :foreground "red") `(:weight ultra-bold)))
     (propertize " "    'face `(:weight bold)))))

(setq eshell-highlight-prompt nil)
(setq-default eshell-prompt-function #'eshell/eshell-local-prompt-function)

;; ehsell here!
(defun eshell-here ()
  "Opens up a new shell in the directory associated with the
current buffer's file. The eshell is renamed to match that
directory to make multiple eshell windows easier."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (height (/ (window-total-height) 3))
         (name   (car (last (split-string parent "/" t)))))
    (split-window-vertically (- height))
    (other-window 1)
    (eshell "new")
    (rename-buffer (concat "*eshell: " name "*"))

    (insert (concat "ls"))
    (eshell-send-input)))

(bind-key "C-!" 'eshell-here)

(defun eshell-here ()
  "Opens up a new shell in the directory associated with the
    current buffer's file. The eshell is renamed to match that
    directory to make multiple eshell windows easier."
  (interactive)
  (let* ((height (/ (window-total-height) 3)))
    (split-window-vertically (- height))
    (other-window 1)
    (eshell "new")
    (insert (concat "ls"))
    (eshell-send-input)))

(bind-key "C-!" 'eshell-here)

(use-package eshell
  :config
  (defun ha/eshell-quit-or-delete-char (arg)
    (interactive "p")
    (if (and (eolp) (looking-back eshell-prompt-regexp))
        (progn
          (eshell-life-is-too-much) ; Why not? (eshell/exit)
          (ignore-errors
            (delete-window)))
      (delete-forward-char arg)))
  :init
  (add-hook 'eshell-mode-hook
            (lambda ()
              (bind-keys :map eshell-mode-map
                         ("C-d" . ha/eshell-quit-or-delete-char)))))


(setq qtramp-default-method "ssh")




;;; A quick hook to C modes to quickswap to =.h= files or =.c= files. It's nice
(add-hook 'c-mode-common-hook
          (lambda ()
            (local-set-key (kbd "C-c o") 'ff-find-other-file)))
;; also gdb is cool
(setq gdb-many-windows 't)

;; Slime for lisps!
(use-package slime
  :ensure t
  :config
  (progn
    (slime-setup '(slime-repl))
    (setq inferior-lisp-program "/usr/bin/sbcl")
    (setq slime-contribs '(slime-fancy))))


(use-package python
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode)
  :config
  (progn
    (elpy-enable)
    (setq python-indent-offsett 2)))



;; mark any TODO or somethign like that in red font!
(add-hook 'prog-common-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIX\\|FIXME\\|TODO\\|BUG\\|HACK\\):" 1 font-lock-warning-face t)))))

;; flycheck mode is not too bad.


(use-package flycheck
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-flycheck-mode)
  :config
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

;; Yasnippet configuration
(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :config
  (progn
    (yas-global-mode 1)
    (setq yas-fallback-behavior 'return-nil)
    (setq yas-triggers-in-field t)
    (setq yas-verbosity 0)
    (setq yas-snippet-dirs (list "~/.emacs.d/snippets/" "~/.emacs.d/elpa/yasnippet-20170923.1646/snippets/"))
    ;; (define-key yas-minor-mode-map [(tab)] nil)
    ;; (define-key yas-minor-mode-map (kbd "TAB") nil)
    ))

(use-package auto-yasnippet
  :ensure t
  :bind ((  "C-1" . aya-create)
         (  "C-2" . aya-expand)))


(use-package recentf
  :ensure t
  :diminish recentf-mode
  :config
  (progn
    (recentf-mode 1)
    (setq recentf-max-menu-items 25)))


;; Ido configuration
(use-package flx-ido
  :disabled
  :ensure t
  :config
  (progn
    (setq ido-enable-flex-matching t)
    (setq ido-everywhere t)
    (ido-mode 1)
    (ido-ubiquitous-mode 1)
    (flx-ido-mode 1) ; better/faster matching
    (setq ido-create-new-buffer 'always) ; don't confirm to create new buffers
    (ido-vertical-mode 1)
    (setq ido-vertical-define-keys 'C-n-and-C-p-only)))

(use-package ido-completing-read+
  :ensure t)

;; ivy stuff
(use-package smex
  :ensure t
  :config
  (smex-initialize))

(use-package ivy
  :ensure t
  :diminish ivy-mode
  :config
  (progn
    (with-eval-after-load 'ido
      (ido-mode -1)
      ;; Enable ivy
      (ivy-mode 1))

    (setq ivy-use-virtual-buffers t)
    (setq ivy-initial-inputs-alist nil)
    (setq enable-recursive-minibuffers t)
    (setq ivy-count-format "%d/%d ")))

;; sick of this blinking
(blink-cursor-mode -1)


(use-package counsel
  :ensure t
  :bind (("C-x f" . counsel-find-file)
         ("C-h f" . counsel-describe-function)
         ("C-h v" . counsel-describe-variable)
         ("M-x" . counsel-M-x)
         ("C-c o" . counsel-recentf)
         ("C-x l" . counsel-locate))
  :config
  (progn
    (setq counsel-find-file-at-point t)))

(use-package swiper
  :ensure t
  ;; :bind (:map isearch-mode-map
  ;;             ("M-i" . swiper-from-isearch)) ; isearch > swiper
  :bind (("C-c C-r" . swiper)
         ("C-c C-s" . counsel-grep-or-swiper))
  )
                                        ; mc tips and tricks!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;     To get out of multiple-cursors-mode, press <return> or C-g. The
;;     latter will first disable multiple regions before disabling
;;     multiple cursors. If you want to insert a newline in
;;     multiple-cursors-mode, use C-j.

;;     (define-key mc/keymap (kbd "<return>") nil) will make <return>
;;     insert a newline; multiple-cursors-mode can still be disabled
;;     with C-g.

;;     Sometimes you end up with cursors outside of your view. You can
;;     scroll the screen to center on each cursor with C-v and M-v or
;;     you can press C-' to hide all lines without a cursor, press C-'
;;     again to unhide.

;;     Try pressing mc/mark-next-like-this with no region selected. It
;;     will just add a cursor on the next line.

;;     Try pressing mc/mark-next-like-this-word or
;;     mc/mark-next-like-this-symbol with no region selected. It will
;;     mark the word or symbol and add a cursor at the next occurance

;;     Try pressing mc/mark-all-like-this-dwim on a tagname in
;;     html-mode.

;;     Notice that the number of cursors active can be seen in the
;;     modeline.

;;     If you get out of multiple-cursors-mode and yank - it will yank
;;     only from the kill-ring of main cursor. To yank from the
;;     kill-rings of every cursor use yank-rectangle, normally found
;;     at C-x r y.

;;     You can use mc/reverse-regions with nothing selected and just
;;     one cursor. It will then flip the sexp at point and the one
;;     below it.

;;     When you use mc/edit-lines, you can give it a positive or
;;     negative prefix to change how it behaves on too short lines.

;;     If you would like to keep the global bindings clean, and get
;;     custom keybindings when the region is active, you can try
;;     region-bindings-mode.

;; BTW, I highly recommend adding mc/mark-next-like-this to a key
;; binding that's right next to the key for er/expand-region.
(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)
         ("C-S-<mouse-1>" . mc/add-cursor-on-click))
  :bind (:map region-bindings-mode-map
              ("a" . mc/mark-all-like-this)
              ("p" . mc/mark-previous-like-this)
              ("n" . mc/mark-next-like-this)
              ("P" . mc/unmark-previous-like-this)
              ("N" . mc/unmark-next-like-this)
              ("[" . mc/cycle-backward)
              ("]" . mc/cycle-forward)
              ("m" . mc/mark-more-like-this-extended)
              ("h" . mc-hide-unmatched-lines-mode)
              ("\\" . mc/vertical-align-with-space)
              ("#" . mc/insert-numbers) ; use num prefix to set the starting number
              ("^" . mc/edit-beginnings-of-lines)
              ("$" . mc/edit-ends-of-lines))
  :init
  (progn
    (setq mc/list-file (locate-user-emacs-file "mc-lists"))

    ;; Disable the annoying sluggish matching paren blinks for all cursors
    ;; when you happen to type a ")" or "}" at all cursor locations.
    (defvar modi/mc-blink-matching-paren--store nil
      "Internal variable used to restore the value of `blink-matching-paren'
after `multiple-cursors-mode' is quit.")

    ;; The `multiple-cursors-mode-enabled-hook' and
    ;; `multiple-cursors-mode-disabled-hook' are run in the
    ;; `multiple-cursors-mode' minor mode definition, but they are not declared
    ;; (not `defvar'd). So do that first before using `add-hook'.
    (defvar multiple-cursors-mode-enabled-hook nil
      "Hook that is run after `multiple-cursors-mode' is enabled.")
    (defvar multiple-cursors-mode-disabled-hook nil
      "Hook that is run after `multiple-cursors-mode' is disabled.")

    (defun modi/mc-when-enabled ()
      "Function to be added to `multiple-cursors-mode-enabled-hook'."
      (setq modi/mc-blink-matching-paren--store blink-matching-paren)
      (setq blink-matching-paren nil))

    (defun modi/mc-when-disabled ()
      "Function to be added to `multiple-cursors-mode-disabled-hook'."
      (setq blink-matching-paren modi/mc-blink-matching-paren--store))

    (add-hook 'multiple-cursors-mode-enabled-hook #'modi/mc-when-enabled)
    (add-hook 'multiple-cursors-mode-disabled-hook #'modi/mc-when-disabled)))

(use-package expand-region
  :ensure t
  :bind ("C-," . er/expand-region))




                                        ; org-mode
                                        ; TODO - speed-keys?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (require 'org)
;; (require 'org-bullets)

(use-package org-bullets
  :ensure t
  :hook org
  :config
  (setq org-ellipsis "⤵"))

(use-package org
  :ensure t
  :bind (("\C-cl" . org-store-link)
         ("\C-cl" . org-store-link)
         ("\C-cb" . org-iswitchb))
  :config
  (progn
    (add-hook 'org-mode-hook
              (lambda ()
                (org-bullets-mode t)))
    (setq org-M-RET-may-split-line nil)
    (setq org-src-fontify-natively t)
    (setq org-src-tab-acts-natively t)
    (setq org-edit-src-content-indentation 0)
    (setq org-src-window-setup 'current-window)
    (add-to-list 'org-babel-load-languages '(emacs-lisp . t))
    (add-to-list 'org-babel-load-languages '(dot . t))
    (add-to-list 'org-babel-load-languages '(ditaa . t))
    (add-to-list 'org-babel-load-languages '(ipython . t))
    (add-to-list 'org-babel-load-languages '(python . t))
    (add-to-list 'org-babel-load-languages '(C . t))
    (add-to-list 'org-babel-load-languages '(shell . t))

    (org-babel-do-load-languages
     'org-babel-load-languages
     '((C . t) (python . t) (emacs-lisp . t) (gnuplot . t) (shell .t)))

    (setq org-confirm-babel-evaluate nil)
    ;; Org-capture management + Tasks
    (setq org-directory "~/Dropbox/org/")

    (defun org-file-path (filename)
      "Return absolute address of an org file give its relative name."
      (concat (file-name-as-directory org-directory) filename))

    (setq org-inbox-file "~/Dropbox/inbox.org")
    (setq org-index-file (org-file-path "index.org"))
    (setq org-personal-file (org-file-path "personal.org"))
    (setq org-archive-location
          (concat (org-file-path "archive.org") "::* From %s"))


    ;; I keep all of my todos in =~/org/index.org= so I derive my
    ;; agenda from there
    (setq org-agenda-files (list org-index-file org-personal-file))
    
    (setq org-agenda-tags-column 80)
;; Bind C-c C-x C-s to mark todo as done and archive it
    (defun lp/mark-done-and-archive ()
      "Mark the state of an org-mode item as DONE and archive it"
      (interactive)
      (org-todo 'done)
      (org-archive-subtree))
    (define-key org-mode-map (kbd "C-c C-x C-s") 'lp/mark-done-and-archive)
    (setq org-log-done 'time) ; also record when the TODO was archived

    (setq org-capture-templates
          '(("r" "to-read"
             checkitem
             (file "~/Dropbox/org/to-read.org"))
            ("i" "Ideas"
             entry
             (file "~/Dropbox/org/ideas.org")
             "* %?\n")
            ("j" "Journal"
             entry
             (file "~/Dropbox/org/journal.org")

             "** %u :journal: \n %?")
            ("t" "Todo"
             entry
             (file+headline org-index-file "Tasks")
             "* TODO %?\n")
            ("p" "Personal todo"
             entry
             (file+headline org-personal-file "general")
             "* TODO %?\n")))

;;; Org Keybindings
    ;; Useful keybinds
    (define-key global-map (kbd "C-c a") 'org-agenda)
    (define-key global-map (kbd "C-c c") 'org-capture)

    ;; Hit C-c i to open up my todo list.
    (defun lp/open-index-file ()
      "Open the org TODO list."
      (interactive)
      (find-file org-index-file)
      (flycheck-mode -1)
      (end-of-buffer))

    (global-set-key (kbd "C-c i") 'lp/open-index-file)

    (defun lp/org-capture-todo ()
      (interactive)
      (org-capture :keys "t"))

    (defun lp/open-full-agenda()
      (interactive)
      (org-agenda :keys "n")
      (delete-other-windows))

    (global-set-key (kbd "M-n") 'lp/org-capture-todo)
    (global-set-key (kbd "<f1>") 'lp/open-full-agenda)


    ;; Auto wrap paragraphs in some modes (auto-fill-mode)
    (add-hook 'text-mode-hook 'turn-on-auto-fill)
    (add-hook 'org-mode-hook 'turn-on-auto-fill)

    ;; sometimes i don't want to wrap text though, so we will toggle
    ;; with C-c q
    (global-set-key (kbd "C-c q") 'auto-fill-mode)))

;; When editing code snippet/ block, use syntax highlighting for that
;; language Also don't open new window for src blocks
                                        ; research with org-mode!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; pdf-tools init
(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install))

;; org-ref

(use-package bibtex-utils
  :ensure t)
(use-package biblio
  :ensure t)

;;(require 'pubmed)
;;(require 'arxiv)
;;(require 'sci-id)

(autoload 'helm-bibtex "helm-bibtex" "" t)

(use-package org-ref
  :ensure t
  :config
  (progn
    (require 'doi-utils)
    (setq org-ref-notes-directory "~/Dropbox/res"
          org-ref-bibliography-notes "~/Dropbox/res/notes.org"
          org-ref-default-bibliography '("~/Dropbox/res/index.bib")
          org-ref-pdf-directory "~/Dropbox/res/lib/")))

(use-package helm-bibtex
  :ensure t
  :config
  (setq helm-bibtex-bibliography "~/Dropbox/res/index.bib" ;; where your references are stored
        helm-bibtex-library-path "~/Dropbox/res/lib/"
        bibtex-completion-library-path '("~/Dropbox/res/lib/") ;; where your pdfs etc are stored
        helm-bibtex-notes-path "~/Dropbox/res/notes.org" ;; where your notes are stored
        bibtex-completion-bibliography "~/Dropbox/res/index.bib" ;; writing completion
        bibtex-completion-notes-path "~/Dropbox/res/notes.org"))

(defun lp/open-paper-notes ()
  "Open the org TODO list."
  (interactive)
  (find-file "~/Dropbox/res/notes.org")
  (flycheck-mode -1))
(global-set-key  (kbd "C-c r") 'lp/open-paper-notes)

                                        ; markdown
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))


                                        ; tex
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq TeX-PDF-mode t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq TeX-save-query nil)
(set-default 'preview-scale-function 2.0)
;; i don't know what this is
(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-source-correlate-start-server t)

;; revert pdf-view after compilation
(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)



                                        ; elfeed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package elfeed
  :ensure t
  :bind (:map elfeed-search-mode-map
              ("A" . bjm/elfeed-show-all)
              ("E" . bjm/elfeed-show-emacs)
              ("D" . bjm/elfeed-show-daily)))
(global-set-key (kbd "C-x w") 'elfeed)
(setq shr-width 80)

(setq-default elfeed-search-filter "@2-weeks-ago +unread ")
(use-package elfeed-org
  :ensure t
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list "~/.emacs.d/elfeed.org")))


(defun lp/elfeed-show-all ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-all"))
(defun lp/elfeed-show-emacs ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-emacs"))
(defun lp/elfeed-show-daily ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-daily"))

;; Entries older than 2 weeks are marked as readn
(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :before "2 weeks ago"
                              :remove 'unread))


;; code to add and remove a starred tag to elfeed article
;; based on http://matt.hackinghistory.ca/2015/11/22/elfeed/

;; add a star
(defun bjm/elfeed-star ()
  "Apply starred to all selected entries."
  (interactive )
  (let* ((entries (elfeed-search-selected))
         (tag (intern "starred")))

    (cl-loop for entry in entries do (elfeed-tag entry tag))
    (mapc #'elfeed-search-update-entry entries)
    (unless (use-region-p) (forward-line))))

;; remove a start
(defun bjm/elfeed-unstar ()
  "Remove starred tag from all selected entries."
  (interactive )
  (let* ((entries (elfeed-search-selected))
         (tag (intern "starred")))

    (cl-loop for entry in entries do (elfeed-untag entry tag))
    (mapc #'elfeed-search-update-entry entries)
    (unless (use-region-p) (forward-line))))

;; face for starred articles
(defface elfeed-search-starred-title-face
  '((t :foreground "#f77"))
  "Marks a starred Elfeed entry.")

(push '(starred elfeed-search-starred-title-face) elfeed-search-face-alist)
(eval-after-load 'elfeed-search
  '(define-key elfeed-search-mode-map (kbd "*") 'bjm/elfeed-star))
(eval-after-load 'elfeed-search
  '(define-key elfeed-search-mode-map (kbd "8") 'bjm/elfeed-unstar))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (defalias 'elfeed-toggle-star
;;   (elfeed-expose #'elfeed-search-toggle-all 'star))

;; (eval-after-load 'elfeed-search
;;   '(define-key elfeed-search-mode-map (kbd "m") 'elfeed-toggle-star))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                                        ; writing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; highlights bad word choices and does stuff
(use-package writegood-mode
  :ensure t
  :bind (("C-c g" . writegood-mode)
         ("\C-c\C-gg" . writegood-grade-level)
         ("\C-c\C-ge" . writegood-reading-ease))
  :config
  (add-to-list 'writegood-weasel-words "actionable"))


                                        ; toy areas of computer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun lp/open-challenges-notes ()
  "Open the org TODO list."
  (interactive)
  (find-file "~/code/dailies/dailies.org")
  (flycheck-mode -1))

(global-set-key  (kbd "C-c y") 'lp/open-challenges-notes)


                                        ; w3m and internet
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;; TAB to jump from link to link.
    ;; RETURN to follow a link
    ;; SPACE to move down the page
    ;; b to move up the page
    ;; B to move back in the history
    ;; M to open the URL in Firefox
    ;; I to open the image if it didn’t show up correctly
    ;; c to copy the URL of the current page in the kill ring.
    ;; u to copy the URL of the link in the kill ring.
    ;; a to bookmark this page
    ;; v to look at the bookmarks
    ;; s to look through the page history for this session.

(use-package w3m
  :commands w3m-goto-url w3m-search
  :init
  (setq browse-url-browser-function 'w3m-browse-url)
  (setq w3m-use-cookies t)

  ;; clean up the w3m buffers:
  (add-hook 'w3m-display-functions 'w3m-hide-stuff)
  (add-hook 'w3m-mode 'ace-link-mode)

  (global-set-key (kbd "C-c w w") 'w3m-goto-url)
  (global-set-key (kbd "C-c w l") 'browse-url-at-point)
  (global-set-key (kbd "C-c w g") 'w3m-search)

  :config
  (define-key w3m-mode-map (kbd "&") 'w3m-view-url-with-external-browser))

(defun ha-switch-default-browser ()
  "Switches the default browser between the internal and external web browser."
  (interactive)
  ;;         | Variable                  | Function
  (if (equal browse-url-browser-function 'browse-url-default-browser)
      (if (fboundp 'w3m)
          (setq browse-url-browser-function 'w3m-browse-url)
        (setq browse-url-browser-function 'eww-browse-url))
    (setq browse-url-browser-function 'browse-url-default-browser))

  ;; Now we need to display the current setting. The variables are
  ;; pretty typical and have the goodies, but I just need to get rid
  ;; of the word "url" or "browser", and the results are pretty close:
  (cl-flet ((remove-bad-parts (l)
                              (-filter (lambda (s) (pcase s
                                                ("url"     nil)
                                                ("browse"  nil)
                                                ("browser" nil)
                                                (_  t))) l)))
    (message "Browser set to: %s"
             (-> (symbol-name browse-url-browser-function)
                 (split-string "-")
                 remove-bad-parts
                 car))))

(global-set-key (kbd "C-c w d") 'ha-switch-default-browser)

(defun w3m-skip-in-google ()
  "For a Google Search, skip to the first result."
  (beginning-of-buffer)
  (search-forward-regexp "[0-9, ]+ results")
  (forward-line 2)
  (recenter-top-bottom 0))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#eaeaea" "#d54e53" "DarkOliveGreen3" "#e7c547" "DeepSkyBlue1" "#c397d8" "#70c0b1" "#181a26"))
 '(custom-enabled-themes (quote (cyberpunk)))
 '(custom-safe-themes
   (quote
    ("d6922c974e8a78378eacb01414183ce32bc8dbf2de78aabcc6ad8172547cb074" "cc60d17db31a53adf93ec6fad5a9cfff6e177664994a52346f81f62840fe8e23" "28ec8ccf6190f6a73812df9bc91df54ce1d6132f18b4c8fcc85d45298569eb53" "e1994cf306356e4358af96735930e73eadbaf95349db14db6d9539923b225565" "eea01f540a0f3bc7c755410ea146943688c4e29bea74a29568635670ab22f9bc" default)))
 '(fci-rule-color "#14151E")
 '(package-selected-packages
   (quote
    (w3m cyberpunk-theme doi-utils cherry-blossom-theme afternoon-theme auto-yasnippet eclipse-theme academic-phrases expand-region writegood-mode use-package tuareg smex slime rainbow-delimiters projectile powerline paredit org-ref org-link-minor-mode org-bullets multiple-cursors monokai-theme monokai-alt-theme merlin markdown-mode magit interleave ido-vertical-mode ido-completing-read+ helm-ag flycheck flx-ido elpy elfeed-org diminish diff-hl counsel bibtex-utils bibretrieve auto-compile ag adafruit-wisdom ace-window)))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#d54e53")
     (40 . "goldenrod")
     (60 . "#e7c547")
     (80 . "DarkOliveGreen3")
     (100 . "#70c0b1")
     (120 . "DeepSkyBlue1")
     (140 . "#c397d8")
     (160 . "#d54e53")
     (180 . "goldenrod")
     (200 . "#e7c547")
     (220 . "DarkOliveGreen3")
     (240 . "#70c0b1")
     (260 . "DeepSkyBlue1")
     (280 . "#c397d8")
     (300 . "#d54e53")
     (320 . "goldenrod")
     (340 . "#e7c547")
     (360 . "DarkOliveGreen3"))))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")
;; ## end of OPAM user-setup addition for emacs / base ## keep this line

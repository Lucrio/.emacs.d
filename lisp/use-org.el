(require 'use-package)
                                        ; org-mode
                                        ; TODO speed-keys?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org-bullets
  :ensure t
  :config
  (setq org-ellipsis "⤵"))

(use-package org
  :ensure t
  :bind (("\C-cl" . org-store-link)
         ("\C-cl" . org-store-link)
         ("\C-cb" . org-iswitchb))
  :config
  (add-hook 'org-mode-hook
            (lambda ()
              (org-bullets-mode t)))

  ;; use enter to follow links instead of C-c C-o
  (setq org-return-follows-link t)

  ;; NOTE: If this isn't working, make sure to delete /
  ;; byte-recompile the /elpa/org/.. directory!
  ;; enable language compiles
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((C . t)
     (python . t)
     (shell . t)
     (emacs-lisp . t)
     (gnuplot . t)
     (R . t)))
  (setq org-confirm-babel-evaluate nil)
  (setq org-M-RET-may-split-line nil)
  (setq org-src-fontify-natively t)
  (setq org-src-tab-acts-natively t)
  (setq org-edit-src-content-indentation 0)
  (setq org-src-window-setup 'current-window)


;;;;;;;; file directory setup
  ;; Org-capture management + Tasks
  (setq org-directory "~/Dropbox/org/")

  (defun org-file-path (filename)
    "Return absolute address of an org file give its relative name."
    (concat (file-name-as-directory org-directory) filename))

  (setq org-inbox-file "~/Dropbox/inbox.org")
  (setq org-index-file (org-file-path "index.org"))
  (setq org-personal-file (org-file-path "personal.org"))
  (setq org-school-file (org-file-path "school.org"))
  (setq org-projects-file (org-file-path "projects.org"))
  (setq org-notes-file (org-file-path "notes.org"))
  (setq org-journal-file (org-file-path "journal.org"))
  (setq org-monthly-file (org-file-path "monthly.org"))
  (setq org-archive-location
        (concat (org-file-path "archive.org") "::* From %s"))

  ;; I keep all of my todos in =~/Dropbox/org/index.org= so I derive my
  ;; agenda from there
  (setq org-agenda-files
        (list org-index-file org-personal-file org-school-file org-projects-file org-notes-file org-journal-file (org-file-path "to-read.org")))
  (setq all-org-files
        (list org-index-file org-personal-file org-school-file org-projects-file org-notes-file org-journal-file (org-file-path "to-read.org")))

  ;; refiling!
  ;; refiling
  ;; I like to look at pretty much just up to 3 levels of targets
  (setq org-refile-targets '((all-org-files :maxlevel . 3)))

  ;; only look at top level headings. Since org-mode represents
  ;; these as files, this also means that the highest level heading
  ;; will be the first "file" so to speak
  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)

  ;; allow creating new parents on refile
  (setq org-refile-allow-creating-parent-nodes 'confirm)
                                        ; todo stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq org-todo-keywords
        (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
                (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

  (setq org-todo-keyword-faces
        (quote (("TODO" :foreground "red" :weight bold)
                ("NEXT" :foreground "DeepSkyBlue1" :weight bold)
                ("DONE" :foreground "forest green" :weight bold)
                ("WAITING" :foreground "orange" :weight bold)
                ("HOLD" :foreground "magenta" :weight bold)
                ("CANCELLED" :foreground "forest green" :weight bold)
                ("MEETING" :foreground "forest green" :weight bold)
                ("PHONE" :foreground "forest green" :weight bold))))

  (setq org-todo-state-tags-triggers
        (quote (("CANCELLED" ("CANCELLED" . t))
                ("WAITING" ("WAITING" . t))
                ("HOLD" ("WAITING") ("HOLD" . t))
                (done ("WAITING") ("HOLD"))
                ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
                ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
                ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

  ;; Place tags close to the right-hand side of the window
  (add-hook 'org-finalize-agenda-hook 'place-agenda-tags)
  (defun place-agenda-tags ()
    "Put the agenda tags by the right border of the agenda window."
    (setq org-agenda-tags-column (- 4 (window-width)))
    (org-agenda-align-tags))
  ;; Changing a task state is done with C-c C-t KEY
  ;; where KEY is the appropriate fast todo state selection key as defined in org-todo-keywords.
  ;; The setting

  (setq org-use-fast-todo-selection t)

  ;; allows changing todo states with S-left and S-right skipping all of
  ;; the normal processing when entering or leaving a todo state. This
  ;; cycles through the todo states but skips setting timestamps and
  ;; entering notes which is very convenient when all you want to do is
  ;; fix up the status of an entry.
  (setq org-treat-S-cursor-todo-selection-as-state-change nil)
  (setq to-read-tags '(":learning:" ":books:" ":emacs:" ":research:" ":manga:" ":anime:"
                       ":ml:" ":sites:" ":games:" ":music:"))
  (defun lp/refile-to (file headline)
    "refile to specific spot (headline) in file"
    (let ((pos (save-excursion
                 (find-file file)
                 (org-find-exact-headline-in-buffer headline))))
      (org-refile nil nil (list headline file nil pos))))

  (defun lp/refile-to-file-with-tag (tag file headline)
    " Helper function to refile a group of tags to a certain file's headline"
    (while (not (equal nil (search-forward tag nil t)))
      (beginning-of-visual-line)
      (lp/refile-to file headline))
    (switch-to-buffer "index.org"))

  (defun lp/refile-school ()
    (lp/refile-to-file-with-tag ":school:" org-school-file "inbox"))

  (defun lp/refile-personal ()
    (lp/refile-to-file-with-tag ":personal:" org-personal-file "inbox"))

  (defun lp/refile-all-in-index ()
    (interactive)
    (beginning-of-buffer)
    (lp/refile-school)
    (beginning-of-buffer)
    (lp/refile-personal)
    (universal-argument) ;; universal argument is the C-u prefix!
    (save-some-buffers))

  (defun lp/refile-to-read ()
    " Invoke on headline of inbox in to-read.org. refiles all tagged entries to respective header"
    (interactive)
    ;; do for each tag in our "to-read" tags
    (dotimes (i (length to-read-tags))
      ;; Search forward until we can't anymore (no more items with this tag
      (let ((tag (nth i to-read-tags)))
        (save-excursion
          (while (not (equal nil (search-forward tag nil t)))
            (beginning-of-visual-line)
            (lp/refile-to (org-file-path "to-read.org") (substring tag 1 -1)))))
      ))


  ;;   (setq-default org-preview-latex-default-process 'dvisvgm
  ;;                 org-latex-packages-alist '(("" "tikz" t)
  ;;                                            ("american,siunitx,smartlabels" "circuitikz" t)
  ;;                                            ("" "mathtools" t))
  ;;                 org-latex-preview-ltxpng-directory (locate-user-emacs-file "Latex Previews/")
  ;;                 org-format-latex-options
  ;;                 '(:foreground default :background default :scale 1.7
  ;;                               :html-foreground "Black" :html-background "Transparent" :html-scale 1.0
  ;;                               :matchers ("begin" "$1" "$" "$$" "\\(" "\\["))
  ;;                 org-preview-latex-process-alist
  ;;                 '((dvisvgm :programs ("latex" "dvisvgm")
  ;;                            :description "dvi > svg"
  ;;                            :message "you need to install the programs: latex and dvisvgm."
  ;;                            :use-xcolor t
  ;;                            :image-input-type "dvi"
  ;;                            :image-output-type "svg"
  ;;                            :image-size-adjust (1.7 . 1.5)
  ;;                            :latex-compiler ("latex -interaction nonstopmode -output-directory %o %f")
  ;;                            :image-converter ("dvisvgm %f -n -b 1 -c %S -o %O"))
  ;;                   (imagemagick :programs ("latex" "convert")
  ;;                                :description "pdf > png"
  ;;                                :message "you need to install the programs: latex and imagemagick."
  ;;                                :use-xcolor t
  ;;                                :image-input-type "pdf"
  ;;                                :image-output-type "png"
  ;;                                :image-size-adjust (1.0 . 1.0)
  ;;                                :latex-compiler ("pdflatex -interaction nonstopmode -output-directory %o %f")
  ;;                                :image-converter ("convert -density %D -trim -antialias %f -quality 100 %O"))
  ;;                   (dvipng :programs ("latex" "dvipng")
  ;;                           :description "dvi > png"
  ;;                           :message "you need to install the programs: latex and dvipng."
  ;;                           :image-input-type "dvi"
  ;;                           :image-output-type "png"
  ;;                           :image-size-adjust (1.0 . 1.0)
  ;;                           :latex-compiler ("latex -interaction nonstopmode -output-directory %o %f")
  ;;                           :image-converter ("dvipng -fg %F -bg %B -D %D -T tight -o %O %f")))
  ;;                 org-format-latex-header
  ;;                 "\\documentclass{article}
  ;; \\usepackage[usenames]{color}
  ;; [PACKAGES]
  ;; [DEFAULT-PACKAGES]
  ;; \\pagestyle{empty}
  ;; \\setlength{\\textwidth}{\\paperwidth}
  ;; \\addtolength{\\textwidth}{-3cm}
  ;; \\setlength{\\oddsidemargin}{1.5cm}
  ;; \\addtolength{\\oddsidemargin}{-2.54cm}
  ;; \\setlength{\\evensidemargin}{\\oddsidemargin}
  ;; \\setlength{\\textheight}{\\paperheight}
  ;; \\addtolength{\\textheight}{-\\headheight}
  ;; \\addtolength{\\textheight}{-\\headsep}
  ;; \\addtolength{\\textheight}{-\\footskip}
  ;; \\addtolength{\\textheight}{-3cm}
  ;; \\setlength{\\topmargin}{1.5cm}
  ;; \\addtolength{\\topmargin}{-2.54cm}
  ;; \\tikzset{every picture/.style={color=fg}}")

  ;; NOTE(nox): Get different latex fragments for different themes
                                        ; agenda stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq org-agenda-tags-column 80)
  ;; Do not dim blocked tasks
  (setq org-agenda-dim-blocked-tasks nil)
  ;; Compact the block agenda view
  (setq org-agenda-compact-blocks t) ;; nil為加上分隔線，t為去掉
  ;; 用describe-char來查你想要的seperator char code
  (setq org-agenda-block-separator 45)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; NOX'S SHIT
  (defun nox/org-agenda-finalize ()
    ;; NOTE(nox): Reset project hierarchy builder helper variable
    (setq nox/org-agenda-first-project t)

    ;; NOTE(nox): Remove empty blocks
    (save-excursion
      (goto-char (point-min))
      (let ((prev (if (get-text-property (point-min) 'org-agenda-structural-header)
                      (point-min)
                    (next-single-property-change (point-min) 'org-agenda-structural-header)))
            next)
        (while (and prev (/= prev (point-max)))
          (setq next
                (or (next-single-property-change (next-single-property-change prev 'org-agenda-structural-header)
                                                 'org-agenda-structural-header)
                    (point-max)))
          (if (or (and (< next (point-max)) (< (count-lines prev next) 4))
                  (and (= next (point-max)) (< (count-lines prev next) 2)))
              (delete-region prev next)
            (setq prev next)))))

    ;; NOTE(nox): Turn root projects bold
    (save-excursion
      (while (search-forward (char-to-string ?\u200B) nil t)
        (add-face-text-property (line-beginning-position) (1+ (line-end-position)) '(:weight bold)))))
  ;; Custom functions to find the tasks that were done in a file for the past month
  (require 'calendar)

  (defun jtc-org-tasks-closed-in-month (&optional month year match-string)
    "Produces an org agenda tags view list of the tasks completed
in the specified month and year. Month parameter expects a number
from 1 to 12. Year parameter expects a four digit number. Defaults
to the current month when arguments are not provided. Additional search
criteria can be provided via the optional match-string argument "
    (interactive)
    (let* ((today (calendar-current-date))
           (for-month (or month (calendar-extract-month today)))
           (for-year  (or year  (calendar-extract-year today))))
      (org-tags-view nil
                     (concat
                      match-string
                      (format "+CLOSED>=\"[%d-%02d-01]\""
                              for-year for-month)
                      (format "+CLOSED<=\"[%d-%02d-%02d]\""
                              for-year for-month
                              (calendar-last-day-of-month for-month for-year))))))

  (defun jtc-foo-tasks-last-month ()
    "Produces an org agenda tags view list of all the tasks completed
last month with the Category Foo."
    (interactive)
    (let* ((today (calendar-current-date))
           (for-month (calendar-extract-month today))
           (for-year  (calendar-extract-year today)))
      (calendar-increment-month for-month for-year -1)
      (jtc-org-tasks-closed-in-month
       for-month for-year "+TODO=\"DONE\"")))

  (setq-default
   org-agenda-custom-commands
   '(("n" "Agenda"
      ((agenda ""
               ((org-agenda-files (list org-index-file org-personal-file org-school-file org-projects-file org-notes-file org-journal-file org-monthly-file))
                (org-agenda-skip-scheduled-if-deadline-is-shown t)))
       (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!-DONE-HOLD"
                  ((org-agenda-overriding-header "To-File Files (index.org)")
                   (org-tags-match-list-sublevels nil)
                   (org-agenda-files (list org-index-file))))
       (tags "cs73|cs87"
             ((org-agenda-overriding-header "CS Work")
              (org-tags-match-list-sublevels nil)
              (org-agenda-files (list org-school-file))))
       (tags "jpns"
             ((org-agenda-overriding-header "JPNS")
              (org-tags-match-list-sublevels nil)
              (org-agenda-files (list org-school-file))))
       (tags "kizuna|smash|outsiders"
             ((org-agenda-overriding-header "Clubs")
              (org-tags-match-list-sublevels nil)
              (org-agenda-files (list org-school-file))))
       (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!-DONE-HOLD"
                  ((org-agenda-overriding-header "Personal Stuff")
                   (org-tags-match-list-sublevels nil)
                   (org-agenda-files (list org-personal-file))))))
     ("t" "To Read Stuff"
      ((tags-todo "music/!-DONE-HOLD"
                  ((org-agenda-overriding-header "Music")
                   (orgs-tags-match-list-sublevels nil)
                   (org-agenda-files (list (org-file-path "to-read.org")))))
       (tags-todo "anime/!-DONE-HOLD"
                  ((org-agenda-overriding-header "Anime")
                   (orgs-tags-match-list-sublevels nil)
                   (org-agenda-files (list (org-file-path "to-read.org")))))
       (tags-todo "sites/!-DONE-HOLD"
                  ((org-agenda-overriding-header "Sites ")
                   (orgs-tags-match-list-sublevels nil)
                   (org-agenda-files (list (org-file-path "to-read.org")))))
       (tags-todo "research/!-DONE-HOLD"
                  ((org-agenda-overriding-header "Research Papers")
                   (orgs-tags-match-list-sublevels nil)
                   (org-agenda-files (list (org-file-path "to-read.org")))))
       (tags-todo "manga/!-DONE-HOLD"
                  ((org-agenda-overriding-header "Manga")
                   (orgs-tags-match-list-sublevels nil)
                   (org-agenda-files (list (org-file-path "to-read.org")))))
       (tags-todo "learning/!-DONE-HOLD"
                  ((org-agenda-overriding-header "Things to Learn")
                   (orgs-tags-match-list-sublevels nil)
                   (org-agenda-files (list (org-file-path "to-read.org")))))
       (tags-todo "books-learning/!-DONE-HOLD-WAITING"
                  ((org-agenda-overriding-header "Books")
                   (orgs-tags-match-list-sublevels nil)
                   (org-agenda-files (list (org-file-path "to-read.org"))))))))
   org-agenda-span 'week
   org-agenda-prefix-format '((agenda . "  %?-12t% s")
                              (todo   . "  ")
                              (tags   . "  ")
                              (search . "  "))
   org-agenda-skip-deadline-prewarning-if-scheduled 'pre-scheduled
   org-agenda-tags-todo-honor-ignore-options t
   org-agenda-clockreport-parameter-plist `(:link t :maxlevel 6 :fileskip0 t :compact t :narrow 100)
   org-agenda-dim-blocked-tasks nil
   org-agenda-block-separator ""
                                        ;   org-agenda-time-grid '((daily today require-timed) nil "......" "----------------")
   )
  ;; Custom agenda command definitions
                                        ; ((org-agenda-finalize-hook 'nox/org-agenda-finalize))
  (setq org-tags-match-list-sublevels t)



  ;; Function to skip tag
  ;; From http://stackoverflow.com/questions/10074016/org-mode-filter-on-tag-in-agenda-view

  ;; Bind C-c C-x C-s to mark todo as done and archive it
  (defun lp/mark-done-and-archive ()
    "Mark the state of an org-mode item as DONE and archive it"
    (interactive)
    (org-todo 'done)
    (org-archive-subtree))


  (define-key org-mode-map (kbd "C-c C-x C-s") 'lp/mark-done-and-archive)
  (setq org-log-done 'time)             ; also record when the TODO was archived

  (setq org-capture-templates
        '(("g" "Groceries"
           entry
           (file "~/Dropbox/org/groceries.org")
           "- [ ] %?\n")
          ("i" "Ideas"
           entry
           (file+headline "~/Dropbox/org/ideas.org" "Project Ideas")
           "** [#%^{9}] %?\n")
          ("j" "Journal"
           entry
           (file+datetree "~/Dropbox/org/journal.org")
           "** %U :journal:\n%?")
          ("t" "to-read"
           entry
           (file+headline "~/Dropbox/org/to-read.org" "inbox")
           "** TODO %^{to-read}  %^g\n %U")
          ("z" "Todo"
           entry
           (file+headline org-index-file "Tasks")
           "* TODO %^{Task} %^G\n %U\n%?")
          ("p" "Personal todo"
           entry
           (file+headline org-personal-file "general")
           "* TODO %^{Task} %^g\n %?")))

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
    (org-capture :keys "z"))

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
  (global-set-key (kbd "C-c q") 'auto-fill-mode))
                                        ; clocking!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ; setup helpers

                                        ; ok back to clocking
;;;;;;;;;;;;;;;;;;;;

;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
;;
;; Show lot of clocking history so it's easy to pick items off the C-F11 list
(setq org-clock-history-length 23)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change tasks to NEXT when clocking in
(setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
;; Save clock data and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist t)
;; Do not prompt to resume an active clock
(setq org-clock-persist-query-resume nil)
;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)

;; hugo because why not

(use-package ox-hugo
  :ensure t)

(provide 'use-org)
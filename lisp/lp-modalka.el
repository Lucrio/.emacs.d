;; Yoinked from https://github.com/mrkkrp/dot-emacs/blob/9d2a3a77aa3e06cfd48ebefd53c984bf5cf5d914/mk/mk-packages.el
(require 'use-package)

(use-package modalka
  :disabled 
  :straight t
  :init
  (setq-default
   modalka-cursor-type 'box)
  :config
  (modalka-define-kbd "SPC" "C-SPC")
  ;; ' (handy as self-inserting)
  ;; " (handy as self-inserting)
  (modalka-define-kbd "," "C-,")
  ;; - (handy as self-inserting)
  (modalka-define-kbd "/" "M-.")
  (modalka-define-kbd "." "C-.")
  (modalka-define-kbd ":" "M-:")
  (modalka-define-kbd ";" "C-;")
  (modalka-define-kbd "?" "M-,")
  (modalka-define-kbd "u" "C-/")

  (modalka-define-kbd "0" "C-0")
  (modalka-define-kbd "1" "C-1")
  (modalka-define-kbd "2" "C-2")
  (modalka-define-kbd "3" "C-3")
  (modalka-define-kbd "4" "C-4")
  (modalka-define-kbd "5" "C-5")
  (modalka-define-kbd "6" "C-6")
  (modalka-define-kbd "7" "C-7")
  (modalka-define-kbd "8" "C-8")
  (modalka-define-kbd "9" "C-9")

  (modalka-define-kbd "a" "C-a")
  (modalka-define-kbd "b" "C-b")
  (modalka-define-kbd "c b" "C-c C-b")
  (modalka-define-kbd "c c" "C-c C-c")
  (modalka-define-kbd "c k" "C-c k")
  (modalka-define-kbd "c l" "C-c C-l")
  (modalka-define-kbd "c n" "C-c C-n")
  (modalka-define-kbd "c p f" "C-c p f") ;; projectile keymap
  (modalka-define-kbd "c s" "C-c C-s")
  (modalka-define-kbd "c t" "C-c C-t")
  (modalka-define-kbd "c u" "C-c C-u")
  (modalka-define-kbd "c v" "C-c C-v")
  (modalka-define-kbd "c x" "C-c C-x")
  (modalka-define-kbd "d" "C-d")
  (modalka-define-kbd "e" "C-e")
  (modalka-define-kbd "f" "C-f")

  (modalka-define-kbd "g g" "M-g g") ;;consult binds from lp-consult.el
  (modalka-define-kbd "g m" "M-g m")
  (modalka-define-kbd "g k" "M-g k")
  (modalka-define-kbd "g e" "M-g e")
  (modalka-define-kbd "g o" "M-g o")
  (modalka-define-kbd "g i" "M-g i")
  (modalka-define-kbd "g l" "M-g l")

  (modalka-define-kbd "h" "M-h")
  (modalka-define-kbd "i" "C-i")
  (modalka-define-kbd "j" "M-j")
  (modalka-define-kbd "k" "C-k")
  (modalka-define-kbd "l" "C-l")
  (modalka-define-kbd "m" "C-m")
  (modalka-define-kbd "n" "C-n")
  (modalka-define-kbd "o" "C-o")
  (modalka-define-kbd "p" "C-p")
  ;; useful for q to be self-inserting
  ;; (modalka-define-kbd "q" "M-q")
  (modalka-define-kbd "r" "C-r")
  (modalka-define-kbd "s" "C-s")
  (modalka-define-kbd "t" "C-t")
  (modalka-define-kbd "v" "C-v")
  (modalka-define-kbd "w" "C-w")
  (modalka-define-kbd "x SPC" "C-x SPC")
  (modalka-define-kbd "x 3" "C-x 3")
  (modalka-define-kbd "x 0" "C-x 0")
  (modalka-define-kbd "x ;" "C-x C-;")
  (modalka-define-kbd "x b" "C-x b")
  (modalka-define-kbd "x e" "C-x C-e")
  (modalka-define-kbd "x f" "C-x C-f") ;; i do NOT want to change fill lmfao
  (modalka-define-kbd "x g" "C-x g")
  (modalka-define-kbd "x o" "C-x C-o")
  (modalka-define-kbd "x q" "C-x C-q")
  (modalka-define-kbd "x r r" "C-x r r")
  (modalka-define-kbd "x r S" "C-x r S")
  (modalka-define-kbd "x r L" "C-x r L")
  (modalka-define-kbd "x r n" "C-x r n") ;; registers
  (modalka-define-kbd "x r s" "C-x r s")
  (modalka-define-kbd "x r r" "C-x r r")
  (modalka-define-kbd "x r SPC" "C-x r SPC")
  (modalka-define-kbd "x r w" "C-x r w")
  (modalka-define-kbd "x r i" "C-x r i")
  (modalka-define-kbd "x r j" "C-x r j")
  (modalka-define-kbd "x r +" "C-x r +")
  (modalka-define-kbd "x r f" "C-x r f")
  
  (modalka-define-kbd "x s" "C-x C-s")
  ;; macros :)
  (modalka-define-kbd "x k s" "C-x C-k s") ;;start macro
  (modalka-define-kbd "x k k" "C-x C-k C-k") ;;stop macro
  (modalka-define-kbd "x e" "C-x e")
  (modalka-define-kbd "x t b" "C-x t b") ;; tab buffers
  (modalka-define-kbd "x t 0" "C-x t 0")
  (modalka-define-kbd "x t 1" "C-x t 1")
  (modalka-define-kbd "x t 2" "C-x t 2")
  (modalka-define-kbd "x t b" "C-x t b")
  (modalka-define-kbd "x t d" "C-x t d")
  (modalka-define-kbd "x t f" "C-x t f")
  (modalka-define-kbd "x t o" "C-x t o")
  (modalka-define-kbd "y" "C-y")
  (modalka-define-kbd "z" "M-z")

  (modalka-define-kbd "M-SPC" "C-M-@")
  (modalka-define-kbd "A" "M-SPC")
  (modalka-define-kbd "B" "M-b")
  (modalka-define-kbd "C" "M-c")
  (modalka-define-kbd "D" "M-d")
  (modalka-define-kbd "E" "M-e")
  (modalka-define-kbd "F" "M-f")
  (modalka-define-kbd "G" "M-g")
  (modalka-define-kbd "H" "M-H")
  ;; I (bound elsewhere)
  ;; J (bound elsewhere)
  (modalka-define-kbd "K" "M-k")
  (modalka-define-kbd "L" "M-l")
  (modalka-define-kbd "M" "M-m")
  (modalka-define-kbd "N" "M-n")
  (modalka-define-kbd "O" "M-o")
  (modalka-define-kbd "P" "M-p")
  ;; Q (bound elsewhere)
  (modalka-define-kbd "R" "M-r")
  (modalka-define-kbd "S i" "M-s i")
  (modalka-define-kbd "S f" "M-s f")
  (modalka-define-kbd "S s" "M-s s")
  (modalka-define-kbd "S l" "M-s l")

  (modalka-define-kbd "T" "M-t")
  (modalka-define-kbd "U" "M-u")
  (modalka-define-kbd "V" "M-v")
  (modalka-define-kbd "W" "M-w")
  ;; X (not bound)
  (modalka-define-kbd "X" "M-X")
  (modalka-define-kbd "Y" "M-y")
  (modalka-define-kbd "Z" "M-Z")

  (defun mk-modalka-mode-no-git-commit ()
    "Enable ‘modalka-mode’ unless get edit git commit message."
    (unless (string-equal (buffer-name) "COMMIT_EDITMSG")
      (modalka-mode 1)))

  (defun mk-open-default-dir ()
    "Open default directory."
    (interactive)
    (find-file default-directory))

  :bind
  (("<backtab>" . modalka-mode)
   ;; :map
   ;; modalka-mode-map
   ;; ("Q" . mk-sort-lines-dwim)
   ;; ("X" . mk-open-default-dir)
   )
  :hook
  ((compilation-mode-hook . modalka-mode)
   (conf-toml-mode-hook . modalka-mode)
   (conf-unix-mode-hook . modalka-mode)
   (gitignore-mode-hook . modalka-mode)
   (haskell-cabal-mode-hook . modalka-mode)
   (help-mode-hook . modalka-mode)
   (info-mode-hook . modalka-mode)
   (prog-mode-hook . modalka-mode)
   (proof-mode-hook . modalka-mode)
   (text-mode-hook . mk-modalka-mode-no-git-commit)
   (yaml-mode-hook . modalka-mode)
   )

  )
(provide 'lp-modalka)

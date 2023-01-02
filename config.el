;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; TODO: add script to repo to download external deps (eg. dotnet, fsac, pyls...)

;; NOTE: Attempt to use --with-natural-title-bar.
;;      see - https://notes.alexkehayias.com/emacs-natural-title-bar-with-no-text-in-macos/

;; NOTE: see previous config (now at ~/.emacs.d.backup)

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Stelios Georgiou")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;; Fonts
;; TODO: Set up as described by Doom, and set up non-monospace
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
(set-frame-font "JetBrains Mono 14" nil t)
(set-fontset-font "fontset-default" 'unicode "Apple Color Emoji" nil 'prepend)

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord)

;; TODO: set up all the icons dired and treemacs - https://emacs.stackexchange.com/questions/71269/all-the-icons-are-all-white-in-dired
(use-package! all-the-icons-dired
  :after all-the-icons
  :hook (dired-mode . all-the-icons-dired-mode)
  :config (setq all-the-icons-dired-monochrome nil))

(setq doom-themes-treemacs-theme "doom-colors")
;; TODO: create a binding under C-c search for avy-goto-char
;; TODO: Set up org file paths, org-projectile, org-bullets

;; macOS keyboard fixes
;; TODO: find out why other keyboard modifications are affected in Doom Emacs (eg #)
;;      > this was because karabiner sends an "alt" key. By mapping `super' to the
;;      > "alt" key, karabiner breaks.
(setq mac-command-modifier      'meta
      ns-command-modifier       'meta
      mac-option-modifier       'super
      ns-option-modifier        'super
      mac-right-option-modifier 'nil
      ns-right-option-modifier  'nil)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(setq confirm-nonexistent-file-or-buffer  t)
(setq save-interprogram-paste-before-kill t)
(setq visible-bell                        nil)
(setq ring-bell-function                  'ignore)
(setq minibuffer-prompt-properties
      '(read-only t point-entered minibuffer-avoid-prompt face minibuffer-prompt))
(setq select-enable-clipboard            t)
(setq history-length                     1000)
(setq +python-ipython-repl-args '("-i" "--simple-prompt"))

;; Set title bar
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; Set initial window size
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(defun duplicate-line()
  "Duplicate a line"
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank))

;; Keybindings
(map! "C-c C-d" `duplicate-line)
(map! "C-{" #'switch-to-prev-buffer)
(map! "C-}" #'switch-to-next-buffer)
(map! "<C-tab>" #'next-window-any-frame)
(map! "<C-S-tab>" #'previous-window-any-frame)
(move-lines-binding)  ;  see alternative move region: https://www.emacswiki.org/emacs/MoveRegion

;; iESS R console colour fix
;; see - https://github.com/emacs-ess/ESS/issues/1193
(defun my-inferior-ess-init ()
  (setq-local ansi-color-for-comint-mode 'filter)
  (smartparens-mode 1))
(add-hook 'inferior-ess-mode-hook 'my-inferior-ess-init)

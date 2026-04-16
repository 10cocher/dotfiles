;;; init.el --- Initialization file for Emacs
;;; Commentary: Emacs Startup File --- initialization for Emacs

;;; Code:

;; ===================================
;; Performance & Garbage Collection
;; ===================================

(setq gc-cons-threshold (* 100 1024 1024)) ;; 100mb during startup
(setq read-process-output-max (* 1024 1024)) ;; 1mb

(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1024 1024)))) ;; 2mb normal operation


;; ===================================
;; Basic Customization
;; ===================================

(setq inhibit-startup-message t)    ;; Hide the startup message
(scroll-bar-mode -1)                ;; Disable visible scrollbar
(tool-bar-mode -1)                  ;; Disable the toolbar
(tooltip-mode -1)                   ;; Disable tooltips
(menu-bar-mode -1)                  ;; Disable the menu bar

;; line/column numbers
(setq column-number-mode t)         ;; Always show column numbers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'display-fill-column-indicator-mode)
(setq-default display-fill-column-indicator-column 88)

(setq make-backup-files nil)        ;; remove backup files

;; ===================================
;; Package Infrastructure
;; ===================================
;; Enables basic packaging support
(require 'package)

;; Adds the Melpa archive to the list of available repositories
(setq package-archives '(("melpa" . "http://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initializes the package infrastructure
(package-initialize)

;; If there are no archived package contents, refresh them
(when (not package-archive-contents)
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

;; ===================================
;; Environment variables
;; ===================================

(use-package exec-path-from-shell
  :ensure t
  :config
  (when (daemonp)
    (exec-path-from-shell-initialize)))

(use-package direnv
  :ensure t
  :config
  (direnv-mode))

;; ===================================
;; Visuals & Themes
;; ===================================;
(use-package better-defaults
  :ensure t)

(use-package material-theme
  :ensure t)
(load-theme 'material t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "JetBrains Mono Nerd Font" :foundry "JB" :slant normal :weight normal :height 120 :width normal)))))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package dashboard
  :ensure t
  :delight
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo)
  )


;; =================================
;; Consult and autocompletion
;; =================================

(use-package consult
  :ensure t)

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
  )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :ensure t
  :init
  (savehist-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :ensure t
  :init (marginalia-mode))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; ===================================
;; Projectile
;; ===================================

(use-package projectile
  :ensure t
  :init
  :bind (:map projectile-mode-map
              ("C-c p" . projectile-command-map))
  :config
  ;; (setq projectile-keymap-prefix (kbd "C-c p"))
  (setq projectile-project-search-path '("~/jca/" "~/aoc/" ("~/github" . 1)))
  )

;; ===================================
;; Treemacs
;; ===================================

(use-package treemacs
  :ensure t
  :defer t
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                2000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-header-scroll-indicators        '(nil . "^^^^^^")
          treemacs-hide-dot-git-directory          t
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-project-follow-into-home        nil
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)
    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    (treemacs-resize-icons 14)
    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))
  
    (pcase (cons (not (null (executable-find "git")))
		 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil)))

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
 :after (treemacs magit)
 :ensure t)

;; ===================================
;; Git Integration
;; ===================================

(use-package magit
  :ensure t)

;; ===================================
;; Development Setup
;; ===================================

;; automatically trim trailing whitespaces
(use-package ws-butler
  :ensure t
  :hook
  (prog-mode . ws-butler-mode)
  (yaml-mode . ws-butler-mode)
  )

;; ===================================
;; python
;; ===================================

;; This remaps standard python-mode to the faster python-ts-mode
(setq major-mode-remap-alist
  '((python-mode . python-ts-mode)
    (yaml-mode . yaml-ts-mode)
    (json-mode . json-ts-mode)))


(use-package python
  :ensure t
  :custom
  (python-shell-interpreter "python")
  (python-shell-interpreter-args "-i")
  (python-indent-offset 4)
  :config
  (setq-default display-fill-column-indicator-column 89)
  )

(use-package pip-requirements
  :ensure t
  )

(use-package pyenv-mode
  :ensure t
  ;; The package will only load if this condition is true at runtime
  :if (executable-find "pyenv")
  :hook (python-mode . pyenv-mode))

(use-package numpydoc
  :ensure t
  :after python
  :bind (:map python-mode-map
	      ("C-c d" . numpydoc-generate))
  )

;; ===================================
;; Rust
;; ===================================

(use-package rustic
  :ensure t
  :config
  ;; uncomment for less flashiness
  ;; (setq lsp-eldoc-hook nil)
  ;; (setq lsp-enable-symbol-highlighting nil)
  ;; (setq lsp-signature-auto-activate nil)
  ;; comment to disable rustfmt on save
  (setq rustic-format-on-save t)
  )

;; ===================================
;; Language Server Protocol
;; ===================================

(use-package lsp-mode
  :ensure t
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (
         (python-ts-mode . lsp-deferred)
         (python-mode . lsp-deferred)
         (rust-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration)
         ;; This hook ensure that whenever LSP is active,
         ;; it attempts to format the buffer before writing to disk
         (lsp-mode . (lambda ()
                       (add-hook 'before-save-hook #'lsp-format-buffer nil t))))

  :commands (lsp lsp-deferred)
  :custom
  (lsp-restart 'ignore)
  (lsp-keep-workspace-alive nil)
  (lsp-idle-delay 0.5)
  ;; hints
  (lsp-inlay-hint-enable nil)
  (lsp-lens-enable nil)
  ;;
  (lsp-disabled-clients '(pyright ruff ruff-lsp mypy))
  ;;
  ;; linters
  (lsp-pylsp-plugins-pydocstyle-enabled nil)
  (lsp-pylsp-plugins-pycodestyle-enabled nil)
  (lsp-pylsp-plugins-black-enabled nil)
  (lsp-pylsp-plugins-ruff-enabled t)
  (lsp-pylsp-plugins-ruff-format-enabled t)
  (lsp-pylsp-plugins-ruff-unsorted-imports-enabled t)
  (lsp-pylsp-plugins-ruff-command ["ruff"])
  ;;
  ; formatters
  (lsp-pylsp-plugins-flake8-enabled nil)
  (lsp-pylsp-plugins-autopep8-enabled nil)
  (lsp-pylsp-plugins-yapf-enabled nil)
  :config
  ;; Optimization for large files
  (setq lsp-enable-file-watchers nil))

(use-package lsp-ui
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable nil) ;; Disable doc popups to stop UI clutter/slowness
  (lsp-ui-sideline-enable nil)
  (lsp-ui-sideline-show-hover nil))


;(use-package lsp-mode
;  :ensure t
;  :commands lsp
;  :custom
;  ;; (lsp-eldoc-render-all t)
;  (lsp-idle-delay 0.6)
;  ;; enable / disable the hints as you prefer:
;  (lsp-inlay-hint-enable t);

;  ;; python
;  (lsp-pyls-plugins-flake8-enabled t)
;  ;; rust-analyzer
;  ;; These are optional configurations. See https://emacs-lsp.github.io/lsp-mode/page/lsp-rust-analyzer/#lsp-rust-analyzer-display-chaining-hints for a full list
;  ;; what to use when checking on-save. "check" is default, I prefer "clippy"
;  (lsp-rust-analyzer-cargo-watch-command "check")
;  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
;  (lsp-rust-analyzer-display-chaining-hints t)
;  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
;  (lsp-rust-analyzer-display-closure-return-type-hints t)
;  (lsp-rust-analyzer-display-parameter-hints nil)
;  (lsp-rust-analyzer-display-reborrow-hints nil)
;  :config
;  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
;  ;; (lsp-register-custom-settings
;  ;;  '(("pyls.plugins.pyls_mypy.enabled" t t)
;  ;;    ("pyls.plugins.pyls_pypy.live_mode" nil t)
;  ;;    ("pyls.plugins.pyls_black.enabled" t t)
;  ;;    ("pyls.plugins.pyls_isort.enabled" t t)))
;  :hook
;  ;;(python-mode . lsp-mode)
;  (rust-mode . lsp-mode)
;  ;; (js-mode . lsp-mode)
;  )

;(use-package lsp-ui
;  :ensure t
;  :commands lsp-ui-mode
;  :custom
;  (lsp-ui-peek-always-show t)
;  ;; sideline
;  (lsp-ui-sideline-show-hover t)
;  (lsp-ui-sideline-delay 0.5)
;  (lsp-ui-sideline-ignore-duplicates nil)
;  ;; doc
;  (lsp-ui-doc nil)
;  (lsp-ui-doc-delay 5)
;  (lsp-ui-doc-header nil)
;  (lsp-ui-doc-include-signature t)
;  (lsp-ui-doc-use-childframe t)
;  (lsp-ui-doc-show-with-cursor nil)
;  )

;; ===================================
;; json
;; ===================================
(use-package json-mode
  :ensure t
  :custom
  (setq js-indent-level 2)
  )

;; Enable elpy
;; (elpy-enable)
(setq exec-path (append exec-path '("~/.pyenv/bin")))
(pyenv-mode)
;; (setq elpy-rpc-virtualenv-path 'current)

;; (setq indent-tabs-mode nil)

;; ===================================
;; js / react
;; ===================================

(use-package rjsx-mode
  :ensure t
  :mode "\\.js\\'"
  :config
  (setq-default js-indent-level 2)
  (setq-default js2-basic-offset 2)
  (setq sgml-basic-offset 2) ;; keeps HTML tags at 2 spaces
  (add-hook 'rjsx-mode-hook
            (lambda ()
              (setq indent-tabs-mode nil))))


;; ===================================
;; d2
;; ===================================

(use-package d2-mode
  :ensure t
  :mode "\\.d2\\'")

;; ===================================
;; chezmoi
;; ===================================

(use-package chezmoi
  :ensure t)

;; ===================================
;; Company
;; ===================================

(use-package company
  :ensure t
  :after lsp-mode
  :hook
  (lsp-mode . company-mode)
  :custom
  (company-idle-delay 0.5) ;; how long to wait until popup
  (company-minimum-prefix-length 1)
  ;; (company-begin-commands nil) ;; uncomment to disable popup
  )

;; ===================================
;; Flycheck
;; ===================================
(use-package flycheck
  :ensure t
  :config
  (setq flycheck-display-errors-delay 0.1)
  :hook
  (prog-mode . flycheck-mode)
  )

(add-to-list 'display-buffer-alist
             `(,(rx bos "*Flycheck errors*" eos)
              (display-buffer-reuse-window
               display-buffer-in-side-window)
              (side            . bottom)
              (reusable-frames . visible)
              (window-height   . 0.2)))


;; =========
;; emacs
;; =========
(use-package auctex
  :ensure t)



;; User-Defined init.el ends here
;;(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
; '(ispell-dictionary nil)
; '(package-selected-packages
;   '(direnv treemacs-magit magit rainbow-delimiters treemacs-icons-dired treemacs rustic rustic-mode lsp-ui lsp-mode exec-path-from-shell consult pyenv-mode web-mode rjsx-mode docker-compose-mode dockerfile-mode markdown-mode))
; '(sh-basic-offset 4))


;; ===================================
;; tree-sitter
;; ===================================
;(setq treesit-language-source-alist
;  '((bash "https://github.com/tree-sitter/tree-sitter-bash")
;    (cmake "https://github.com/uyha/tree-sitter-cmake")
;    (css "https://github.com/tree-sitter/tree-sitter-css")
;    (elisp "https://github.com/Wilfred/tree-sitter-elisp")
;    (go "https://github.com/tree-sitter/tree-sitter-go")
;    (html "https://github.com/tree-sitter/tree-sitter-html")
;    (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
;    (json "https://github.com/tree-sitter/tree-sitter-json")
;    (make "https://github.com/alemuller/tree-sitter-make")
;    (markdown "https://github.com/ikatyang/tree-sitter-markdown")
;    (python "https://github.com/tree-sitter/tree-sitter-python")
;    (toml "https://github.com/tree-sitter/tree-sitter-toml")
;    (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
;    (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
;    (yaml "https://github.com/ikatyang/tree-sitter-yaml")))




;;;(provide 'init)

;;; init.el ends here

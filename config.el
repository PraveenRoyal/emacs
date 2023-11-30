(require 'package)
(setq package-archives nil)
(setq package-ebable-at-startup nil)
(package-initialize)

(set-frame-parameter nil 'alpha-backgroud 95)
(add-to-list 'default-frame-alist '(alpha-background . 95))
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(display-battery-mode t)
(display-time-mode t)

(use-package default-font-presets
  :commands
  (default-font-presets-forward
   default-font-presets-backward
   default-font-presets-choose
   default-font-presets-scale-increase
   default-font-presets-scale-decrease
   default-font-presets-scale-fit
   default-font-presets-scale-reset)
  :config
  (setq default-font-presets-list
	(list
	 "Iosevka Nerd Font Mono:spacing=90"
	 "NotoSans Nerd Font Propo"
	 "FiraCode Nerd Font"
	 "BlexMono Nerd Font"
	 "JetBrainsMono Nerd Font"
	 "VictorMono Nerd Font"
	 "DejaVu Sans Mono"
	 "RobotoMono Nerd Font Propo"
	 "Victor Mono Nerd Font")))

(global-set-key (kbd "C-=") 'default-font-presets-scale-increase)
(global-set-key (kbd "C--") 'default-font-presets-scale-decrease)
(global-set-key (kbd "C-0") 'default-font-presets-scale-reset)

(global-set-key (kbd "<C-mouse-4>") 'default-font-presets-scale-increase)
(global-set-key (kbd "<C-mouse-5>") 'default-font-presets-scale-decrease)

(define-key global-map (kbd "<M-prior>") 'default-font-presets-forward)
(define-key global-map (kbd "<M-next>") 'default-font-presets-backward)

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-nord t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config)
  (doom-themes-neotree-config)
  (doom-themes-treemacs-config))
(setq doom-themes-neotree-file-icons t)

(require 'doom-modeline)
(doom-modeline-mode 1)
(setq doom-modeline-lsp t)
(setq doom-modeline-minor-modes t)
(setq doom-modeline-battery t)
(setq doom-modeline-env-version t)
(setq doom-modeline-time t)

(use-package which-key
:init
(which-key-mode 1)
:config
(setq which-key-side-window-location 'right
      which-key-sort-order #'which-key-key-order-alpha
      which-key-sort-uppercase-first nil
      which-key-add-column-padding 1
      which-key-max-display-columns nil
      which-key-min-display-lines 6
      which-key-side-window-slot -10
      which-key-side-window-max-height 0.25
      which-key-idle-delay 0.8
      which-key-max-description-length 25
      which-key-allow-imprecise-window-fit t
      which-key-seperator "nf-md-hand_pointing_right"))

(use-package vertico
       :init
       (vertico-mode)
       (setq vertico-resize t)
       (setq vertico-cycle t))

(use-package corfu
	   :custom
		(corfu-auto t)
		(corfu-quit-no-match 'separator)
		(corfu-cycle t)
		(corfu-echo-documentation nil)
		(corfu-popupinfo-mode t)

	    :bind (:map corfu-map
			("<return>" . corfu-insert)
			([tab] . corfu-next)
			([backtab] . corfu-previous)
			("C-h"      . corfu-info-documentation)
			("TAB"      . corfu-next)
			("S-TAB"    . corfu-previous))
	    :init
	    (global-corfu-mode))

(use-package emacs
    :init
    (setq completion-cycle-threshold 3)
    (setq tab-always-indent 'complete))

(use-package orderless
     :init
     (setq completion-styles '(orderless basic)
	      completion-category-defaults nil
	      completion-category-overides '((file (styles partial-completion)))))

(use-package dabbrev
  :bind (("M-/" . dabbrev-completion)
	 ("C-M-/" . dabbrev-expand))
  :custom
  (dabbrev-ignored-buffer-regexps '("\\.\\(?:pdf\\|jpe?g\\|png)\\'")))

(require 'yasnippet)
(yas-reload-all)
(add-hook 'prog-mode-hook #'yas-minor-mode)

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))
(add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup)
(require 'nerd-icons-completion)
(nerd-icons-completion-mode)

(use-package embark
	     :ensure t
	     :bind
	     (("C-.". embark-act)
	      ("C-;". embark-dwim)
	      ("C-h B" . embark-bindings))
	     :init
	     (setq prefix-help-command #'embark-prefix-help-command)
	     (add-hook 'eldoc-documentataion-functions #'embark-eldoc-first-target)
	     :config
	     (add-to-list 'display-buffer-alist
			  '("\\'\\*Embark Collect \\(Live\\|Completions\\)\\*"
			    nil
			    (window-parameters (mode-line-format . none))))
	     (add-to-list 'marginalia-prompt-categories '("Help" . describe-function)))

(use-package embark-consult
	     :ensure t
	     :hook
	     (embark-collect-mode . embark-consult-preview-minor-mode))

;;(require 'eldoc-box)
;;(add-hook 'eglot-managed-mode-hook #'eldoc-box-hover-at-point-mode t)

(use-package eglot
  :config
  (add-to-list 'eglot-server-programs '(python-mode . ("pylsp")))
  (setq-default eglot-workspace-configuration
		'((:pylsp . (:configurationSources ["flake8"] :plugins ( :flake8 (:enabled t)))))))

(add-hook 'python-mode-hook 'eglot-ensure)
(add-hook 'python-mode-hook 'python-docstring-mode)
(add-hook 'python-mode-hook (lambda ()
			      (require 'sphinx-doc)
			      (sphinx-doc-mode t)))

(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)

(add-to-list 'auto-mode-alist '("\\.pl\\'" . prolog-mode))

(require 'nix-mode)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))
(add-to-list 'eglot-server-programs '(nix-mode . ("rnix-lsp")))
(add-hook 'nix-mode-hook 'eglot-ensure)

(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-ibuffer)

(autoload 'typing-of-emacs "typing" "The Typing Of Emacs, a game." t)
(require 'monkeytype)
(require 'speed-type)

(global-set-key (kbd "<M-f2>") 'clipmon-autoinsert-toggle)
(global-undo-tree-mode)

(electric-pair-mode t)
(show-paren-mode t)
(electric-indent-mode nil)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

(modify-all-frames-parameters
 '((right-divider-width . 10)
   (internal-border-width . 10)))
(dolist (face '(window-divider
		window-divider-first-pixel
		window-divider-last-pixel))
  (face-spec-reset-face face)
  (set-face-foreground face (face-attribute 'default :background)))
(set-face-background 'fringe(face-attribute 'default :background))

(global-org-modern-mode)
(require 'org-tempo)
(setq org-startup-folded t)

(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/Desktop/Org-Raom-Knowledgebase"))
  (org-roam-complete-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n g" . org-roam-graph)
	 ("C-c n i" . org-roam-node-insert)
	 ("C-c n c" . org-roam-capture)
	 ("C-c n j" . org-roam-dailies-capture-today)
	 :map org-mode-map
	 ("C-M-i"   . completion-at-point)))

(use-package org-roam
  :custom
  (org-roam-capture-templates
   '(("d" "default" plain
      "%?"
      :target (file+head "%<%Y%m%d%H%M%S>-${pr}.org" "#+title: ${title}\n")
      :unnarrowed t)
     ("l" "programming language" plain
     "* Characteristics\n\n- Family: %?\n- Inspired by: \n\n* Reference:\n\n"
     :target (file+head "%<%Y%m%d%H%M%S>-${pr}.org" "#+title: ${title}\n")
     :unnarrowed t))))

(require 'dashboard)
(dashboard-setup-startup-hook)

(beacon-mode 1)

(use-package direnv
  :config
  (direnv-mode))

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((ipython . t)
   (prolog . t)))

(tab-bar-mode t)



(use-package all-the-icons
  :ensure t)
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
(setq neo-theme (if (display-graphic-p) 'icons))

(setq inferior-lisp-program "sbcl")

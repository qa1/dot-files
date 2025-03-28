;; My theme and setting for powerline

;; include original powerline
(require 'powerline)
;; theme
;; (powerline-default-theme) ;; old theme
;; (powerline-center-evil-theme)

;;; Code:

(defface MCSH-powerline-active1 '((t (:inherit mode-line-inactive)))
  "Powerline bg 1."
  :group 'powerline)
(defface MCSH-powerline-active2 '((t (:inherit powerline-active2)))
  "Powerline bg 2."
  :group 'powerline)

(defface MCSH-powerline-inactive1 '((t (:inherit powerline-inactive1)))
  "Powerline bg 1."
  :group 'powerline)
(defface MCSH-powerline-inactive2 '((t (:inherit powerline-inactive2)))
  "Powerline bg 2."
  :group 'powerline)

(defface MCSH-evil-active-default '((t (;:background "grey11"
                                        :inherit mode-line)))
  "Powerline face1 MCSH."
  :group 'powerline)

(defface MCSH-evil-inactive-default
  '((t (;:background "grey22"
        :inherit mode-line-inactive)))
  "Powerline face inactive MCSH 1."
  :group 'powerline)

(defface MCSH-evil-active-normal '((t (:background "goldenrod" :inherit mode-line)))
  "Powerline face1 MCSH."
  :group 'powerline)

;;(defface MCSH-evil-inactive-normal
;;  '((t (:background "goldenrod" :inherit mode-line-inactive)))
;;  "Powerline face inactive MCSH 1."
 ;; :group 'powerline)

(defface MCSH-evil-active-insert '((t (:background "blue" :inherit mode-line)))
  "Powerline face1 MCSH."
  :group 'powerline)

 ;;(defface MCSH-evil-inactive-insert
 ;; '((t (:background "blue" :inherit mode-line-inactive)))
  ;;"Powerline face inactive MCSH 1."
  ;;:group 'powerline)

(defface MCSH-evil-active-replace '((t (:background "magenta" :inherit mode-line)))
  "Powerline face1 MCSH."
  :group 'powerline)

 ;;(defface MCSH-evil-inactive-replace
 ;; '((t (:background "magenta" :inherit mode-line-inactive)))
 ;; "Powerline face inactive MCSH 1."
 ;; :group 'powerline)

(defface MCSH-evil-active-visual '((t (:background "DarkGoldenrod4" :inherit mode-line)))
  "Powerline face1 MCSH."
  :group 'powerline)

 ;;(defface MCSH-evil-inactive-visual
 ;; '((t (:background "DarkGoldenrod4" :inherit mode-line-inactive)))
  ;;"Powerline face inactive MCSH 1."
  ;;:group 'powerline)

(defface MCSH-evil-active-operator '((t (:background "cyan" :inherit mode-line)))
  "Powerline face1 MCSH."
  :group 'powerline)

 ;;(defface MCSH-evil-inactive-operator
 ;; '((t (:background "cyan" :inherit mode-line-inactive)))
 ;; "Powerline face inactive MCSH 1."
 ;; :group 'powerline)

(defface MCSH-evil-active-motion '((t (:background "tan2" :inherit mode-line)))
  "Powerline face1 MCSH."
  :group 'powerline)

 ;;(defface MCSH-evil-inactive-motion
 ;; '((t (:background "tan2" :inherit mode-line-inactive)))
 ;; "Powerline face inactive MCSH 1."
 ;; :group 'powerline)

(defface MCSH-evil-active-emacs '((t (:background "violet" :inherit mode-line)))
  "Powerline face1 MCSH."
  :group 'powerline)

 ;;(defface MCSH-evil-inactive-emacs
 ;; '((t (:background "violet" :inherit mode-line-inactive)))
 ;; "Powerline face inactive MCSH 1."
 ;; :group 'powerline)

(defun MCSH-evil-face (active)
  (interactive)
  "Get face for current mode"
  (let* ((face (intern (concat "MCSH-evil-" (if active "active" "inactive") "-" (symbol-name evil-state) ))))
    (if (facep face) face (intern (concat "MCSH-evil-" (if active "active" "inactive")  "-default")))
  ))


;; my custom theme
(defun powerline-evil-MCSH-theme ()
  "Setup a mode-line with major, evil, and minor modes centered."
  (interactive)
  (setq-default mode-line-format
		'("%e"
		  (:eval
		   (let* ((active (powerline-selected-window-active))
			  (mode-line (if active 'mode-line 'mode-line-inactive))
			  (face1 (if active 'MCSH-powerline-active1 'MCSH-powerline-inactive1))
			  (face2 (if active 'MCSH-powerline-active2 'MCSH-powerline-inactive2))
			  (facemode (MCSH-evil-face active))
			  (separator-left (intern (format "powerline-%s-%s"
							  (powerline-current-separator)
							  (car powerline-default-separator-dir))))
			  (separator-right (intern (format "powerline-%s-%s"
							   (powerline-current-separator)
							   (cdr powerline-default-separator-dir))))
			  (lhs (list (powerline-raw "%*" nil 'l)
				     (powerline-buffer-size nil 'l)
				     (powerline-buffer-id nil 'l)
				     (powerline-raw " ")
				     (funcall separator-left mode-line face1)
				     (powerline-narrow face1 'l)
				     (powerline-vc face1)))
			  (rhs (list (powerline-raw global-mode-string face1 'r)
				     (powerline-raw "%4l" face1 'r)
				     (powerline-raw ":" face1)
				     (powerline-raw "%3c" face1 'r)
				     (funcall separator-right face1 mode-line)
				     (powerline-raw " ")
				     (powerline-raw "%6p" nil 'r)
				     (powerline-hud face2 face1)
				     ))
			  (center (append (list (powerline-raw " " face1)
						(funcall separator-left face1 face2)
						(when (and (boundp 'erc-track-minor-mode) erc-track-minor-mode)
						  (powerline-raw erc-modified-channels-object face2 'l))
						(powerline-major-mode face2 'l)
						(powerline-process face2)
						(powerline-raw " " face2))
					  (if (split-string (format-mode-line minor-mode-alist))
					      (append (if evil-mode
							  (list (funcall separator-right face2 facemode)
								(powerline-raw evil-mode-line-tag facemode 'l)
								(powerline-raw " " facemode)
								(funcall separator-left facemode face2)))
						      ;(list (powerline-minor-modes face2 'l)
							    ;(powerline-raw " " face2)
							    ;(funcall separator-right face2 face1))
                                                      (list
                                                       (powerline-raw " " face2)
                                                       (funcall separator-right face2 face1)))
					    (list (powerline-raw evil-mode-line-tag face2)
						  (funcall separator-right face2 face1))
                                            ))))
		     (concat (powerline-render lhs)
			     (powerline-fill-center face1 (/ (powerline-width center) 2.0))
			     (powerline-render center)
			     (powerline-fill face1 (powerline-width rhs))
			     (powerline-render rhs)))))))

(powerline-evil-MCSH-theme)

(provide 'powerline-MCSH)

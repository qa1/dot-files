(setq org-todo-keywords
      '((sequence "TODO(t)" "IN PROGRESS(i)" "WAIT(r)" "|" "DONE(d)" "CANCELLED(c)")
        ;;(sequence "TASK(f)" "WAIT(r)" "|" "DONE(d)")
        (sequence "MAYBE(m)" "|" "CANCELLED(c)")))

 (setq org-todo-keyword-faces
      '(("TODO" . (:foreground "DarkSlateGray1" :weight bold))
        ("MAYBE" . (:foreground "sea green"))
        ("DONE" . (:foreground "light sea green"))
        ("CANCELLED" . (:foreground "forest green"))
        ("TASK" . (:foreground "DeepSkyBlue"))))

(setq org-tag-faces
      '(
        ("writing" . (:foreground "dark orange"))
        ("school" . (:foreground "gray"))
        ("personal" . (:foreground "sienna"))
        ("reading" . (:foreground "deep sky blue"))
        ("research" . (:foreground "goldenrod1"))
        ("hobby" . (:foreground "forest green"))
        ))

(setq org-agenda-custom-commands
      '(("r" "School work" tags-todo "school" )
        ("h" "Hobby" tags-todo "hobby")
        ("p" "Personal"
         ((agenda "" ((org-agenda-span 7)))
          (tags-todo "personal"))
         ((org-agenda-tag-filter-preset '("+personal"))))
        ("n" "All"
         ((agenda "" ((org-agenda-span 7)))
          (tags "-personal"))
         ((org-agenda-tag-filter-preset '("-personal"))))
        ("m" "All w\\ Personal"
         ((agenda "" ((org-agenda-span 7)))
          (todo)))
        ))

;; TODO Complete this

(provide 'org-team)

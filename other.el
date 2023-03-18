;;; other.el -*- lexical-binding: t; -*-

(emacs-version)

;; ibuffer-jump-offer-only-visible-buffers
(defcustom my-jump-offer-only-visible-buffers t
  "If non-nil, only offer buffers visible in the Ibuffer buffer
in completion lists of the `my-jump-to-buffer' command."
  :type 'boolean)


(setq ibuffer-jump-offer-only-visible-buffers t)


(defun my-jump-to-buffer (name)
  "Move point to the buffer whose name is NAME.

If called interactively, prompt for a buffer name and go to the
corresponding line in the Ibuffer buffer.  If said buffer is in a
hidden group filter, open it.



If `ibuffer-jump-offer-only-visible-buffers' is non-nil, only offer
visible buffers in the completion list.  Calling the command with
a prefix argument reverses the meaning of that variable."
  (interactive (list
		(let ((only-visible my-jump-offer-only-visible-buffers))
		  (when current-prefix-arg
		    (setq only-visible (not only-visible)))
		  (if only-visible
                      (let ((table (mapcar (lambda (x)
                                             (buffer-name (car x)))
					   (ibuffer-current-state-list))))
			(when (null table)
			  (error "No buffers!"))
			(completing-read "Jump to buffer: "
					 table nil t))
		    (read-buffer "Jump to buffer: " nil t)))))
  (when (not (string= "" name))
    (let (buf-point)
      ;; Blindly search for our buffer: it is very likely that it is
      ;; not in a hidden filter group.
      (ibuffer-map-lines (lambda (buf _marks)
                           (when (string= (buffer-name buf) name)
                             (setq buf-point (point))
                             nil))
			 t nil)
      (when (and
	     (null buf-point)
	     (not (null ibuffer-hidden-filter-groups)))
	;; We did not find our buffer.  It must be in a hidden filter
	;; group, so go through all hidden filter groups to find it.
	(catch 'found
	  (dolist (group ibuffer-hidden-filter-groups)
	    (ibuffer-jump-to-filter-group group)
	    (ibuffer-toggle-filter-group)
            (ibuffer-map-lines (lambda (buf _marks)
                                 (when (string= (buffer-name buf) name)
                                   (setq buf-point (point))
                                   nil))
			       t group)
	    (if buf-point
		(throw 'found nil)
	      (ibuffer-toggle-filter-group)))))
      (if (null buf-point)
	  ;; Still not found even though we expanded all hidden filter
	  ;; groups: that must be because it's hidden by predicate:
	  ;; we won't bother trying to display it.
	  (error "No buffer with name %s" name)
	(goto-char buf-point)))))


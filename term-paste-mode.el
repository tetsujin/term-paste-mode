;;; term-paste-mode.el --- Paste some text on emacs in a terminal correctly.

;; Copyright (C) 2009  tetsujin

;; Author: tetsujin <tetsujin85 (at) gmail.com>
;; Keywords: terminals, convinience
;; URL: http://github.com/tetsujin/term-paste-mode/
;; Version: 0.1

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; This extension provides paste some text on emacs in a terminal correctly.
;; usually paste will be broken on emacs in a terminal
;;  - brake indent if bind key [Enter] to `newline-and-indent'
;;  - unwished `key-chord' execution happen if you are using it
;; term-paste-mode provides clean keymap and set higher priority that.
;;
;; Sorry my English sucks...

;;; Installation:
;;
;; require libraries:
;;   - `undo-group.el'  http://www.mahalito.net/~harley/elisp/undo-group.el
;;
;; Put undo-group.el and term-paste-mode.el files to your load-path.
;; And add the following code to your ~/.emacs
;;
;;   (require 'term-paste-mode)
;;

;;; Usage
;;
;; * Before pasting. activate term-paste-mode
;;
;;     M-x `term-paste-mode'
;;
;; * Paste
;;
;; * After pasting. deactivate term-paste-mode
;;
;;     M-x `term-paste-mode'
;;
;; * If you would undo all pasted text.
;;
;;     M-x `undo-group'

;;; Tips
;;
;; Some information from: http://d.hatena.ne.jp/Tetsujin/20090623
;;
;; * Toggle key-chord with term-paste-mode
;;
;;     (add-hook 'term-paste-mode-on-hook (lambda () (key-chord-mode 0)))
;;     (add-hook 'term-paste-mode-off-hook (lambda () (key-chord-mode 1)))
;;
;; * To type `term-paste-mode' is too long...
;;
;;     (defalias 'p 'term-paste-mode)
;;
;;     M-x p

;;; History:
;;
;; 2009-09-30 tetsujin
;;   - term-paste-mode.el 0.1.0 released
;;

;;; Code:

(require 'undo-group)

(defgroup term-paste nil
  "Paste some text on emacs in a terminal correctly."
  :group 'convenience
  :prefix "term-paste-")

(defvar term-paste-mode-map
  (let ((map (make-keymap))
        (i ? ))
    (while (< i ?~) ;; set self-insert-command to ASCII characters
      (define-key map (char-to-string i) 'self-insert-command)
      (setq i (1+ i)))
    (define-key map "\C-m" 'newline)
    map))

(defcustom term-paste-mode-on-hook nil
  "Hook to run when term-paste-mode is activated."
  :group 'term-paste
  :type 'hook)

(defcustom term-paste-mode-off-hook nil
  "Hook to run when term-paste-mode is deactivated."
  :group 'term-paste
  :type 'hook)

(define-minor-mode term-paste-mode
  "Minor mode for pasting some text from terminal correctly."
  :lighter " Paste"
  :group 'term-paste
  (cond (term-paste-mode
         ;; raise priority term-paste-mode-map
         (let ((tpm (assq 'term-paste-mode minor-mode-map-alist)))
           (setq minor-mode-map-alist (cons tpm (delete tpm minor-mode-map-alist))))
         (undo-group-boundary)
         (run-hooks 'term-paste-mode-on-hook))
        (t
         (run-hooks 'term-paste-mode-off-hook)
         )))

(provide 'term-paste-mode)

;;; term-paste-mode.el ends here
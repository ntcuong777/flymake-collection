;;; flymake-collection-staticcheck.el --- Staticcheck diagnostic function -*- lexical-binding: t -*-

;; Copyright (c) 2026 Cuong-Tien Nguyen

;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;;; Commentary:

;; `flymake' syntax checker for Go using Staticcheck.

;;; Code:

(require 'flymake)
(require 'flymake-collection)

(eval-when-compile
  (require 'flymake-collection-define))

(defcustom flymake-collection-staticcheck-args nil
  "Command line arguments always passed to `flymake-collection-staticcheck'."
  :type '(repeat string)
  :group 'flymake-collection)

(defun flymake-collection-staticcheck--project-root (file)
  "Find the Go project root for FILE."
  (or (locate-dominating-file file "go.work")
      (locate-dominating-file file "go.mod")))

;;;###autoload (autoload 'flymake-collection-staticcheck "flymake-collection-staticcheck")
(flymake-collection-define-rx flymake-collection-staticcheck
  "A Go linter using Staticcheck.

See URL `https://staticcheck.dev/'."
  :title "staticcheck"
  :pre-let ((staticcheck-exec (executable-find "staticcheck"))
            (source-file (buffer-file-name flymake-collection-source))
            (project-root (and source-file
                               (flymake-collection-staticcheck--project-root
                                source-file)))
            (target (when project-root
                      (let ((rel (file-relative-name
                                  (file-name-directory source-file)
                                  project-root)))
                        (if (member rel '("" "."))
                            "."
                          rel))))
            (default-directory (or project-root default-directory)))
  :pre-check (progn
               (unless staticcheck-exec
                 (error "Cannot find staticcheck executable"))
               (unless source-file
                 (error "Checker requires a file-backed buffer"))
               (unless project-root
                 (error "Cannot find go.mod or go.work for %s" source-file)))
  :write-type 'file
  :source-inplace t
  :command `(,staticcheck-exec
             "-f" "text"
             ,@flymake-collection-staticcheck-args
             ,(or target "."))
  :regexps
  ((warning bol file-name ":" line ":" column ": " (message)
            (? " (" (id (one-or-more (not (any ")")))) ")")
            eol)))

(provide 'flymake-collection-staticcheck)

;;; flymake-collection-staticcheck.el ends here

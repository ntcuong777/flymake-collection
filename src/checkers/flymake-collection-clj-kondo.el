;;; flymake-collection-clj-kondo.el --- Clj-kondo diagnostic function -*- lexical-binding: t -*-

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

;; `flymake' syntax checker for Clojure using clj-kondo.

;;; Code:

(require 'flymake)
(require 'flymake-collection)

(eval-when-compile
  (require 'flymake-collection-define))

(defcustom flymake-collection-clj-kondo-args nil
  "Command line arguments always passed to `flymake-collection-clj-kondo'."
  :type '(repeat string)
  :group 'flymake-collection)

(defconst flymake-collection-clj-kondo--pattern
  "::{{level}} file={{filename}},line={{row}},col={{col}}::{{message}}"
  "Output pattern used by `flymake-collection-clj-kondo'.")

;;;###autoload (autoload 'flymake-collection-clj-kondo "flymake-collection-clj-kondo")
(flymake-collection-define-rx flymake-collection-clj-kondo
  "A Clojure linter using clj-kondo.

See URL `https://github.com/clj-kondo/clj-kondo'."
  :title "clj-kondo"
  :pre-let ((clj-kondo-exec (executable-find "clj-kondo")))
  :pre-check (unless clj-kondo-exec
               (error "Cannot find clj-kondo executable"))
  :write-type 'file
  :command `(,clj-kondo-exec
             "--lint" ,flymake-collection-temp-file
             "--config" ,(format "{:output {:pattern %S}}"
                                 flymake-collection-clj-kondo--pattern)
             ,@flymake-collection-clj-kondo-args)
  :regexps
  ((error bol "::error file=" file-name ",line=" line ",col=" column "::" (message) eol)
   (warning bol "::warn file=" file-name ",line=" line ",col=" column "::" (message) eol)
   (warning bol "::warning file=" file-name ",line=" line ",col=" column "::" (message) eol)
   (note bol "::info file=" file-name ",line=" line ",col=" column "::" (message) eol)))

(provide 'flymake-collection-clj-kondo)

;;; flymake-collection-clj-kondo.el ends here

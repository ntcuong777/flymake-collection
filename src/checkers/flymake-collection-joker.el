;;; flymake-collection-joker.el --- Joker diagnostic function -*- lexical-binding: t -*-

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

;; `flymake' syntax checker for Clojure using Joker.

;;; Code:

(require 'flymake)
(require 'flymake-collection)

(eval-when-compile
  (require 'flymake-collection-define))

(defcustom flymake-collection-joker-args nil
  "Command line arguments always passed to `flymake-collection-joker'."
  :type '(repeat string)
  :group 'flymake-collection)

(defcustom flymake-collection-joker-dialect "clj"
  "Dialect to use with Joker.
Valid values include \"clj\", \"cljs\", \"cljc\", and \"edn\"."
  :type 'string
  :group 'flymake-collection)

;;;###autoload (autoload 'flymake-collection-joker "flymake-collection-joker")
(flymake-collection-define-rx flymake-collection-joker
  "A Clojure linter using Joker.

See URL `https://github.com/candid82/joker'."
  :title "joker"
  :pre-let ((joker-exec (executable-find "joker")))
  :pre-check (unless joker-exec
               (error "Cannot find joker executable"))
  :write-type 'file
  :command `(,joker-exec
             "--lint"
             "--dialect" ,flymake-collection-joker-dialect
             ,@flymake-collection-joker-args
             ,flymake-collection-temp-file)
  :regexps
  ((warning bol file-name ":" line ":" column ": " (message) eol)))

(provide 'flymake-collection-joker)

;;; flymake-collection-joker.el ends here

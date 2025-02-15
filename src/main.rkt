#lang racket/base
(require racket/list racket/pretty racket/system)

(module+ test
  (require rackunit))

;; Notice
;; To install (from within the package directory):
;;   $ raco pkg install
;; To install (once uploaded to pkgs.racket-lang.org):
;;   $ raco pkg install <<name>>
;; To uninstall:
;;   $ raco pkg remove <<name>>
;; To view documentation:
;;   $ raco docs <<name>>
;;
;; For your convenience, we have included LICENSE-MIT and LICENSE-APACHE files.
;; If you would prefer to use a different license, replace those files with the
;; desired license.
;;
;; Some users like to add a `private/` directory, place auxiliary files there,
;; and require them in `main.rkt`.
;;
;; See the current version of the racket style guide here:
;; http://docs.racket-lang.org/style/index.html

;; Code here



(module+ test
  ;; Any code in this `test` submodule runs when this file is run using DrRacket
  ;; or with `raco test`. The code here does not run when this file is
  ;; required by another module.
  (displayln "Running tests...")
  (require "lib/files-test.rkt")
  (require "lib/parse-test.rkt")
)

(module+ main
  (require "lib/files.rkt" "lib/parse.rkt" "lib/rankings.rkt")
  ;; (Optional) main submodule. Put code here if you need it to be executed when
  ;; this file is run using DrRacket or the `racket` executable.  The code here
  ;; does not run when this file is required by another module. Documentation:
  ;; http://docs.racket-lang.org/guide/Module_Syntax.html#%28part._main-and-test%29

  ; (require racket/cmdline)
  ; (define who (box "world"))
  ; (command-line
  ;   #:program "my-program"
  ;   #:once-each
  ;   [("-n" "--name") name "Who to say hello to" (set-box! who name)]
  ;   #:args ()
  ;   (printf "hello ~a~n" (unbox who))))
  (define (main-loop fileNames filePathsByName)
    ; Get the user selection
    (define selection (get-file-selection fileNames))
    (define filePath (get-file-path selection filePathsByName))
    ; Read the file and clean it up
    (define lines (read-file filePath))
    (define fileWords
      (foldl
        (lambda (line acc)
          (append (split-line line) acc)
        )
      '() lines)
    )
    (define fileWordsClean (map clean-punctuation fileWords))
    (define fileWordsCleanWithoutStopWords
      (filter
        (lambda (word)
          (not
            (or
              (list-includes wordsToRemove word)
              (equal? word "")
              (equal? word " ")
            )
          )
        )
      fileWordsClean)
    )
    ; Count the words
    (define uniqueWords (remove-duplicates fileWordsCleanWithoutStopWords))
    (define wordCountMapEntries
      (map
        (lambda (word)
          (list (string->symbol word) (count-words word fileWordsCleanWithoutStopWords))
        )
        uniqueWords
      )
    )
    ; Get the top 10
    (define topTen (get-top-rankings wordCountMapEntries 10))
    ; Display the results
    (pretty-display topTen)
    (define shouldContinue (prompt-to-continue))
    (if shouldContinue
      (main-loop fileNames filePathsByName)
      (displayln "Goodbye!")
    )
  )

  ; Build a map from file names to file paths
  (define filesDirPath (get-input-files-dir (get-run-dir)))
  (define fileNames (directory-list filesDirPath))
  (define filePathsByName (build-file-map fileNames filesDirPath))

  ; Get the words to remove
  (define wordsToRemove (read-words-to-remove))

  ; Start the main loop
  (main-loop fileNames filePathsByName)
)

(define (count-words word lst) 
  (length (filter (lambda (x) (equal? x word)) lst))
)

(define (get-run-dir)
  (path->directory-path
    (find-system-path 'run-file)
  )
)

(define (get-input-files-dir runDirPath)
  (simplify-path
    (build-path
      runDirPath 'up 'up "files"
    )
  )
)

(define (prompt-to-continue)
  (displayln "Would you like to continue? (y/n)")
  (define continue (read))
  (system "clear")
  (if (or (equal? continue 'y) (equal? continue 'Y))
    #t
    #f
  )
)

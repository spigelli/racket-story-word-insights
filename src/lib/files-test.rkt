#lang racket/base

(require rackunit "files.rkt")

(define files-tests
  (test-suite "Files module tests"

    (test-case "build-file-map test"
      (check-equal?
        (build-file-map (list "a" "b" "c") "/path/to/files")
        (make-hash
          (list
            (list "a" (string->path "/path/to/files/a"))
            (list "b" (string->path "/path/to/files/b"))
            (list "c" (string->path "/path/to/files/c"))
          )
        )
      )
    )

  )
)

(require rackunit/text-ui)
(run-tests files-tests)
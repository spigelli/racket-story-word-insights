#lang racket

(define (readFiles)
  (define filesDirPath (
    simplify-path (
      build-path
        (path->directory-path (find-system-path 'run-file)) 'up 'up "files"
    )
  ))
  (directory-list filesDirPath)
)

(define (main)
  (displayln (readFiles))
)

(main)
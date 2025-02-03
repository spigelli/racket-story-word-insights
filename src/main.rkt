#lang racket

(define (read-files)
  (define filesDirPath (
    simplify-path (
      build-path
        (path->directory-path (find-system-path 'run-file)) 'up 'up "files"
    )
  ))
  (directory-list filesDirPath)
)

(define (get-file-selection fileNames)
  ; clear the screen
  (system "clear")
  (displayln "Select a file to read:")
  (for-each (lambda (fileName index)
    (displayln (string-append (number->string index) ". " (path->string fileName)))
  ) fileNames (range (length fileNames)))
  (display "Enter the number of the file you want to read: ")
  (let ([fileIndex (read)])
    (if (and (integer? fileIndex) (<= 0 fileIndex) (< fileIndex (length fileNames)))
      (list-ref fileNames fileIndex)
      (begin
        (displayln "Invalid selection. Please try again.")
        (get-file-selection fileNames)
      )
    )
  )
)



(define (main)
  ; (displayln (readFiles))
  (displayln (get-file-selection (read-files)))
)

(main)
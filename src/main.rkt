#lang racket

; Takes a list of file names and returns the file name selected by the user
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

; Takes the list of file names and the directory path where the files are located
(define (build-file-map fileNames filesDirPath)
  (define mapEntries (
    map ( lambda (fileName)
      (list fileName (build-path filesDirPath fileName))
    ) fileNames
  ))

  (make-hash mapEntries)
)

; Takes the file name and the hash map of file names to file paths and returns the file path
(define (get-file-path fileName filePathsByName)
  (first (hash-ref filePathsByName fileName))
)

; Reads the file at provided path and prints the contents
(define (read-file filePath)
  (displayln "TODO...")
)

(define (main)
  (define filesDirPath (
    simplify-path (
      build-path
        (path->directory-path (find-system-path 'run-file)) 'up 'up "files"
    )
  ))
  (define fileNames (directory-list filesDirPath))
  (define filePathsByName (build-file-map fileNames filesDirPath))
  (define selection (get-file-selection fileNames))
  (define filePath (get-file-path selection filePathsByName))
  (displayln (string-append "Reading file: " (path->string filePath)))
  ; (read-file filePath)
)

(main)
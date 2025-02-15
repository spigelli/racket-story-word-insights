#lang racket

(provide 
  build-file-map
  get-file-selection
  get-file-path
  read-file
  read-words-to-remove
)

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

(define (lower-case str)
  (string-downcase str)
)

; Parses a line
(define (parse-line line)
  (define lineParts (string-split line "\n"))
  (cond
    [(>= (length lineParts) 1) (lower-case (first lineParts))]
    [else ""]
  )
  ; (define firstPart (first lineParts))
)

; Reads the file at provided path and prints the contents
(define (read-file filePath)
  (define file (open-input-file filePath #:mode 'text))
  (define lines (port->lines file #:line-mode 'return))
  (define linesParsed (map parse-line lines))
  linesParsed
)

; Reads the words that must be removed from the file
(define (read-words-to-remove)
  (define filePath (
  simplify-path (
    build-path
      (path->directory-path (find-system-path 'run-file)) 'up 'up "stop_words_english-1.txt"
    )
  ))
  (read-file filePath)
)
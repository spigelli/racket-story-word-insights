#lang racket
(provide 
  clean-punctuation
  split-line
  remove-banned-char-excepts-quotes
)

(require
  data/collection
  racket/trace
)

; Takes a line and splits it into words
(define (split-line line)
  (string-split line " ")
)

; A list of allowed characters
(define allowedChars '(
  "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
  "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"
  "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" " "
  "'"
))

; Tests if a list includes a value
(define (includes list value)
  (cond
    [(empty? list) false]
    [(equal? (first list) value) true]
    [else (includes (rest list) value)]
  )
)

; Removes all characters that are not in allowedChars except single quotes,
; which will be handled separately
(define (remove-banned-char-excepts-quotes word)
  (define charList (string->list word))
  (sequence->list (
      filter (lambda (char)
        (includes allowedChars (string char))
      ) charList
    )
  )
)

; For the given word
; - Remove all punctuation except single quote
; - If a word ends with a single quote and starts with a single quote, remove both quotes
; - If a word starts with a single quote, and does not end with a single quote, remove the starting quote
(define (clean-punctuation word)
  (define semiCleanedCharList
    (remove-banned-char-excepts-quotes word)
  )
  (define isFirstCharSingleQuote (char=? (first semiCleanedCharList) #\'))
  (define isLastCharSingleQuote (char=? (last semiCleanedCharList) #\'))
  (define lengthWithSurroundQuotes (length semiCleanedCharList))
  (define cleanedCharList
    (cond
      [(empty? semiCleanedCharList) (list)]
      [(and isFirstCharSingleQuote (not isLastCharSingleQuote)) (
        sequence->list (subsequence semiCleanedCharList 1 lengthWithSurroundQuotes)
      )]
      [(and isFirstCharSingleQuote isLastCharSingleQuote) (
        sequence->list (subsequence semiCleanedCharList 1 (- lengthWithSurroundQuotes 1))
      )]
      [else semiCleanedCharList]
    )
  )
  (list->string cleanedCharList)
)

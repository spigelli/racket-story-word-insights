#lang racket
(provide 
  clean-punctuation
  split-line
)

(require data/collection)

; Takes a line and splits it into words
(define (split-line line)
  (string-split line " ")
)

(define allowedChars (list
  "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
  "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"
  "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" " "
  "'"
))

; For the given word
; - Remove all punctuation except single quote
; - If a word ends with a single quote and starts with a single quote, remove both quotes
; - If a word starts with a single quote, and does not end with a single quote, remove the starting quote
(define (clean-punctuation word)
  (define charList (string->list word))
  ; list of allowed chars in word without handling for single quotes yet
  (define semiCleanedCharList (
    filter (lambda (char)
      (or (member (string char) allowedChars) (char=? char #\space))
    ) charList
  ))
  (define isFirstCharSingleQuote (char=? (first semiCleanedCharList) #\'))
  (define isLastCharSingleQuote (char=? (last semiCleanedCharList) #\'))
  (define lengthWithSurroundQuotes (length semiCleanedCharList))
  (define cleanedCharList (
    (cond
      [(and isFirstCharSingleQuote isLastCharSingleQuote) (
        (sequence->list (subsequence semiCleanedCharList 1 (- lengthWithSurroundQuotes 1)))
      )]
    )
    
  ))

  (displayln "asdf")
)

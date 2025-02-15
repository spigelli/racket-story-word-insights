#lang racket/base
(require racket/list racket/pretty)

(provide
  get-top-rankings
)

(define (make-rankings-acc rankings isFinishedCheckingTie)
  (list
    (list 'rankingsList rankings)
    (list 'finishedCheckingTie isFinishedCheckingTie)
  )
)

(define (get-rankings rankingsAcc)
  (second (first rankingsAcc))
)

(define (is-finished-checking-for-tie rankingsAcc)
  (second (second rankingsAcc))
)

(define (get-last-ranking rankingsList)
  (if
    (empty? rankingsList)
    0
    (first (last rankingsList))
  )
)

(define (get-last-ranking-count rankingsList)
  (last (last rankingsList))
)

(define (make-ranking-item rank item)
  (append (list rank) item)
)

(define (add-ranking-item-to-rankings rankings rankingItem)
  (append rankings (list rankingItem))
)

(define (add-ranking-to-acc rankingsAcc item)
  (define prevRankings (get-rankings rankingsAcc))
  (define prevRank (get-last-ranking prevRankings))
  (define newRank (+ prevRank 1))
  (define newRankingsItem (make-ranking-item newRank item))
  (define newRankingsList (add-ranking-item-to-rankings prevRankings newRankingsItem))
  (make-rankings-acc newRankingsList #f)
)

(define (check-for-tie rankingsAcc item)
  (define prevRankings (get-rankings rankingsAcc))
  (define prevRank (get-last-ranking prevRankings))
  (define prevRankingCount (get-last-ranking-count prevRankings))
  (define itemCount (second item))
  (if (= prevRankingCount itemCount)
    (make-rankings-acc
      (add-ranking-item-to-rankings prevRankings (make-ranking-item prevRank item))
      #f
    )
    (make-rankings-acc prevRankings #t)
  )
)

(define (skip rankingsAcc item)
  rankingsAcc
)

; Gets the top ranking items from a list of map entries
; - lst: the list of map entries
; - topCount: the number of top items to return
; > If a tie occurs for the last spot, all items in the tie will be included
; (
;   ('rankingsList ((rank1, word1, count1), (rank2, word2, count2), ...) )
;   ('finishedCheckingTie #f)
; )
(define (get-top-rankings lst maxRank)
  ; Sort the list by count (The second value in each tuple of lst)
  (define sortedList (sort lst (lambda (a b) (> (second a) (second b)))))
  (define sortedListWithRanks
    (foldl
      (lambda (item rankingsAcc)
        ; (pretty-print (list (list 'item item) (list 'rankingsAcc rankingsAcc)))
        (define prevRankings (get-rankings rankingsAcc))
        (define prevRank (get-last-ranking prevRankings))
        (define isFinishedCheckingTie (is-finished-checking-for-tie rankingsAcc))
        (define howToHandle
          (cond 
            [(< prevRank maxRank) 'add]
            [(= prevRank maxRank) 'checkForTie]
            [else (if isFinishedCheckingTie 'skip 'checkForTie)]
          )
        )
        (cond
          [(equal? howToHandle 'add) (add-ranking-to-acc rankingsAcc item)]
          [(equal? howToHandle 'checkForTie) (check-for-tie rankingsAcc item)]
          [else (skip rankingsAcc item)]
        )
      )
      (make-rankings-acc '() #f)
      sortedList
    )
  )
  (second (first sortedListWithRanks))
)
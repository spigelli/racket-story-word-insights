#lang racket/base

(require
  rackunit
  raco/testing
  "parse.rkt"
)

(define parse-tests
  (test-suite
    "Parse module tests"

    (test-case "Removes banned chars except single quote"
      (define result (remove-banned-char-excepts-quotes "a'b,c.d!e?f'g"))
      (define expected (string->list "a'bcdef'g"))
      (check-equal?
        result
        expected
        "Removes punctuation except single quote"
      )
    )

    (test-case "Cleans punctuation"
      (check-equal?
        (clean-punctuation "a'b,c.d!e?f'g")
        "a'bcdef'g"
        "Removes no quotes and all punctuation when there are multiple single quotes in the middle of a word"
      )
      (check-equal?
        (clean-punctuation "'a'b,c.d!e?f'g'")
        "a'bcdef'g"
        "Removes surrounding single quotes and all punctuation when there are multiple single quotes in the middle of a word"
      )
      (check-equal?
        (clean-punctuation "'a'b,c.d!e?f'g")
        "a'bcdef'g"
        "Removes starting single quote and all punctuation when there word does not end with single quote"
      )
      (check-equal?
        (clean-punctuation "a'b,c.d!e?f'g'")
        "a'bcdef'g'"
        "Does not remove ending single quote when there are multiple single quotes in the middle of a word and does not start with single quote"
      )
    )

  )
)

(require rackunit/text-ui)
(run-tests parse-tests)
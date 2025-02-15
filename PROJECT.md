# Project Write-up

## Sources

- StackOverflow
  - https://stackoverflow.com/questions/38688853/using-cons-car-vs-append-to-create-lists-in-racket
  - https://stackoverflow.com/questions/36070321/checking-if-element-is-present-in-list-in-racket
  - https://stackoverflow.com/questions/61710006/how-to-get-rackunit-to-display-stack-trace
  - https://stackoverflow.com/questions/43298809/is-there-a-way-to-display-info-messages-for-any-dr-racket-exception
  - https://stackoverflow.com/questions/48548687/require-vs-load-vs-include-vs-import-in-racket
  - https://stackoverflow.com/questions/62822997/is-there-a-list-all-files-procedure-in-scheme
  - https://stackoverflow.com/questions/61334446/how-to-provide-full-path-in-require-in-racket
- Racket Documentation
- GitHub Copilot
  > Not able to provide prompts for this, but just used the line-completion feature to help me write code faster.

## Discussion

I initialized the project with `raco pkg new` and use `raco/unit` for initial testing.
Halfway through the project, I gave up on learning all the Racket tooling and extra racket language features since I won't be using racket in the future and this class is about functional programming not racket. 

I also gave up on testing for time constraints but modules `src/lib/files-test.rkt` and `src/lib/parse-test.rkt` contain tests for their corresponding modules.
These can be run with `./test-all` or `./test-trace src/lib/files-test.rkt` and `./test-trace src/lib/parse-test.rkt`.

The program is not very performant because of heavy use of list operations. To make it faster I would use hashtables instead of lists. Where applicable.

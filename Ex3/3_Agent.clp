;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT (import MAIN ?ALL) (import GAME ?ALL) (export ?ALL))

(deffunction user-first-guess ()
  (printout t "Please enter your first guess: ")
  (bind ?input (readline))
  (return (explode$ ?input))
)

(defrule human-player
  ?status <- (status (step ?s) (mode human))
  (agent-first)
  =>
  (printout t "Generating random first guess..." crlf)
  (bind $?colorsguess (user-first-guess))
  (assert (guess (step ?s) (g $?colorsguess) ))
  (modify ?status (mode computer))
  (printout t "--- GUESS " ?s " ---- " ?colorsguess crlf)
  (pop-focus)
)



 
 




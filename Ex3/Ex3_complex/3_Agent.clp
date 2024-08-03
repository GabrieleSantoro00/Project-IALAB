;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT (import MAIN ?ALL) (import GAME ?ALL) (export ?ALL))


(deffunction user-first-guess ()
 (printout t "Please enter your first guess: ")
 (bind ?input (readline))
 (return (explode$ ?input))
)

(deffunction generate-new-color (?color1 ?color2 ?color3 ?color4 $?excluded-colors)
 (bind ?available-colors (create$ blue green red yellow orange white black purple))
 (foreach ?exclude ?excluded-colors
   (bind ?available-colors (delete-member$ ?available-colors ?exclude))
 )
 (bind ?newColor nil)
 (foreach ?color ?available-colors
   (if (and (not (member$ ?color (create$ ?color1 ?color2 ?color3 ?color4))) (not (eq ?color ?newColor)))
     then
     (bind ?newColor ?color)
     (break)
   )
 )
 (return ?newColor)
)


(defrule human-player
 ?status <- (status (step ?s) (mode human))
 (agent-first)
 =>
 (printout t " 🔴 = Rightplaced, ⚪ = Missplaced " crlf)
 ;(printout t "Generating random first guess..." crlf)
 (bind $?colorsguess (user-first-guess))
 (assert (guess (step ?s) (g $?colorsguess) ))
 (modify ?status (mode computer))
 (printout t "---- GUESS " ?s " ---- " ?colorsguess crlf)
 (pop-focus)
)


(defrule handle-feedback-3-right-placed-0-miss-placed
  ?feedback <- (answer (step ?s) (right-placed 3) (miss-placed 0))
  ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
  =>
  (printout t "----ANSWER " ?s "---- 3 🔴 - 0 ⚪" crlf)
  (retract ?feedback)
  (bind ?newColor (generate-new-color ?c1 ?c2 ?c3 ?c4))
  (assert (guess (step (+ ?s 1)) (g ?c1 ?c2 ?c3 ?newColor)))
  ;(assert (new-attempt ?c1 ?c2 ?c3 ?newColor))
  (printout t "-----GUESS " (+ ?s 1) "---- " ?c1 " " ?c2 " " ?c3 " " ?newColor crlf))


(defrule handle-feedback-2-right-placed-0-miss-placed
   ?feedback <- (answer (step ?s) (right-placed 2) (miss-placed 0))
   ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
   =>
   (printout t "----ANSWER " ?s "---- 2 🔴 - 0 ⚪" crlf)
   (retract ?feedback)
   (bind ?newColor1 (generate-new-color ?c1 ?c2 ?c3 ?c4))
   (bind ?newColor2 (generate-new-color ?c1 ?c2 ?c3 ?c4 ?newColor1))
   (assert (guess (step (+ ?s 1)) (g ?c1 ?c2 ?newColor1 ?newColor2)))
   ;(assert (new-attempt ?c1 ?c2 ?newColor1 ?newColor2))
   (printout t "-----GUESS " (+ ?s 1) "---- " ?c1 " " ?c2 " " ?newColor1 " " ?newColor2 crlf)
   )
(defrule handle-feedback-1-right-placed-0-miss-placed
 ?feedback <- (answer (step ?s) (right-placed 1) (miss-placed 0))
 ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
 =>
 (printout t "----ANSWER " ?s "---- 1 🔴 - 0 ⚪" crlf)
 (retract ?feedback)
 (bind ?newColor1 (generate-new-color ?c1 ?c2 ?c3 ?c4))
 (bind ?newColor2 (generate-new-color ?c1 ?c2 ?c3 ?c4 ?newColor1))
 (bind ?newColor3 (generate-new-color ?c1 ?c2 ?c3 ?c4 ?newColor1 ?newColor2))
 (assert (guess (step (+ ?s 1)) (g ?c1 ?newColor1 ?newColor2 ?newColor3)))
 ;(assert (new-attempt ?c1 ?newColor1 ?newColor2 ?newColor3))
 (printout t "-----GUESS " (+ ?s 1) "---- " ?c1 " " ?newColor1 " " ?newColor2 " " ?newColor3 crlf)
 )
 (defrule handle-feedback-1-right-placed-1-miss-placed
   ?feedback <- (answer (step ?s) (right-placed 1) (miss-placed 1))
   ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
   =>
   (printout t "----ANSWER " ?s "---- 1 🔴 - 1 ⚪" crlf)
   (retract ?feedback)
   (bind ?newColor1 (generate-new-color ?c1 ?c2 ?c3 ?c4))
   (bind ?newColor2 (generate-new-color ?c1 ?c2 ?c3 ?c4 ?newColor1))
   (bind ?newColor3 (generate-new-color ?c1 ?c2 ?c3 ?c4 ?newColor1 ?newColor2))
   (assert (guess (step (+ ?s 1)) (g ?c1 ?newColor1 ?newColor2 ?newColor3)))
   ;(assert (new-attempt ?c1 ?newColor1 ?newColor2 ?newColor3))
   (printout t "-----GUESS " (+ ?s 1) "---- " ?c1 " " ?newColor1 " " ?newColor2 " " ?newColor3 crlf)
   )
(defrule handle-feedback-0-right-placed-0-miss-placed
   ?feedback <- (answer (step ?s) (right-placed 0) (miss-placed 0))
   ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
   =>
   (printout t "----ANSWER " ?s "---- 0 🔴 - 0 ⚪" crlf)
   (retract ?feedback)
   (bind ?newColor1 (generate-new-color ?c1 ?c2 ?c3 ?c4))
   (bind ?newColor2 (generate-new-color ?c1 ?c2 ?c3 ?c4 ?newColor1))
   (bind ?newColor3 (generate-new-color ?c1 ?c2 ?c3 ?c4 ?newColor1 ?newColor2))
   (bind ?newColor4 (generate-new-color ?c1 ?c2 ?c3 ?c4 ?newColor1 ?newColor2 ?newColor3))
   (assert (guess (step (+ ?s 1)) (g ?newColor1 ?newColor2 ?newColor3 ?newColor4)))
   (printout t "-----GUESS " (+ ?s 1) "---- " ?newColor1 " " ?newColor2 " " ?newColor3 " " ?newColor4 crlf)
   )


(defrule handle-feedback-4-right-placed
 ?feedback <- (answer (step ?s) (right-placed 4) (miss-placed 0))
 ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
 =>
 (printout t "You have discovered the secret code!" crlf)
 ;(retract (guess (step ?s))) ; Optionally remove the guess
 )


(defrule handle-feedback-2-right-placed-2-miss-placed
 ?feedback <- (answer (step ?s) (right-placed 2) (miss-placed 2))
 ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
 =>
 (printout t "----ANSWER " ?s "---- 2 🔴 - 2 ⚪" crlf)
 (retract ?feedback)
 (assert (guess (step (+ ?s 1)) (g ?c1 ?c2 ?c4 ?c3)))
 (printout t "-----GUESS " (+ ?s 1) "---- " ?c1 " " ?c2 " " ?c4 " " ?c3 crlf)
)


(defrule handle-feedback-2-right-placed-1-miss-placed
 ?feedback <- (answer (step ?s) (right-placed 2) (miss-placed 1))
 ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
 =>
 (printout t "----ANSWER " ?s "---- 2 🔴 - 1 ⚪" crlf)
 (retract ?feedback)
 (bind ?newColor (generate-new-color ?c1 ?c2 ?c3 ?c4))
 (assert (guess (step (+ ?s 1)) (g ?c1 ?c2 ?c4 ?newColor)))
 (printout t "-----GUESS " (+ ?s 1) "---- " ?c1 " " ?c2 " " ?c4 " " ?newColor crlf)
)


(defrule handle-feedback-1-right-placed-3-miss-placed
 ?feedback <- (answer (step ?s) (right-placed 1) (miss-placed 3))
 ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
 =>
 (printout t "----ANSWER " ?s "---- 1 🔴 - 3 ⚪" crlf)
 (retract ?feedback)
 (assert (guess (step (+ ?s 1)) (g ?c1 ?c4 ?c3 ?c2)))
 (printout t "-----GUESS " (+ ?s 1) "---- " ?c1 " " ?c4 " " ?c3 " " ?c2 crlf)
)


(defrule handle-feedback-1-right-placed-2-miss-placed
 ?feedback <- (answer (step ?s) (right-placed 1) (miss-placed 2))
 ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
 =>
 (printout t "----ANSWER " ?s "---- 1 🔴 - 2 ⚪" crlf)
 (retract ?feedback)
 (bind ?newColor (generate-new-color ?c1 ?c2 ?c3 ?c4))
 (assert (guess (step (+ ?s 1)) (g ?c1 ?c4 ?c3 ?newColor)))
 (printout t "-----GUESS " (+ ?s 1) "---- " ?c1 " " ?c4 " " ?c3 " " ?newColor crlf)
)


(defrule handle-feedback-0-right-placed-4-miss-placed
 ?feedback <- (answer (step ?s) (right-placed 0) (miss-placed 4))
 ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
 =>
 (printout t "----ANSWER " ?s "---- 0 🔴 - 4 ⚪" crlf)
 (retract ?feedback)
 (assert (guess (step (+ ?s 1)) (g ?c4 ?c3 ?c2 ?c1)))
 (printout t "-----GUESS " (+ ?s 1) "---- " ?c4 " " ?c3 " " ?c2 " " ?c1 crlf)
)


(defrule handle-feedback-0-right-placed-3-miss-placed
 ?feedback <- (answer (step ?s) (right-placed 0) (miss-placed 3))
 ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
 =>
 (printout t "----ANSWER " ?s "---- 0 🔴 - 3 ⚪" crlf)
 (retract ?feedback)
 (bind ?newColor (generate-new-color ?c1 ?c2 ?c3 ?c4))
 (assert (guess (step (+ ?s 1)) (g ?c2 ?c3 ?c4 ?newColor)))
 (printout t "-----GUESS " (+ ?s 1) "---- " ?c2 " " ?c3 " " ?c4 " " ?newColor crlf)
)


(defrule handle-feedback-0-right-placed-2-miss-placed
 ?feedback <- (answer (step ?s) (right-placed 0) (miss-placed 2))
 ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
 =>
 (printout t "----ANSWER " ?s "---- 0 🔴 - 2 ⚪" crlf)
 (retract ?feedback)
 (bind ?newColor1 (generate-new-color ?c1 ?c2 ?c3 ?c4))
 (bind ?newColor2 (generate-new-color ?c1 ?c2 ?c3 ?c4 ?newColor1))
 (assert (guess (step (+ ?s 1)) (g ?c3 ?c4 ?newColor1 ?newColor2)))
 (printout t "-----GUESS " (+ ?s 1) "---- " ?c3 " " ?c4 " " ?newColor1 " " ?newColor2 crlf)
)


(defrule handle-feedback-0-right-placed-1-miss-placed
 ?feedback <- (answer (step ?s) (right-placed 0) (miss-placed 1))
 ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
 =>
 (printout t "----ANSWER " ?s "---- 0 🔴 - 1 ⚪" crlf)
 (retract ?feedback)
 (bind ?newColor1 (generate-new-color ?c1 ?c2 ?c3 ?c4))
 (bind ?newColor2 (generate-new-color ?c1 ?c2 ?c3 ?c4 ?newColor1))
 (bind ?newColor3 (generate-new-color ?c1 ?c2 ?c3 ?c4 ?newColor1 ?newColor2))
 (assert (guess (step (+ ?s 1)) (g ?c1 ?newColor1 ?newColor2 ?newColor3)))
 (printout t "-----GUESS " (+ ?s 1) "---- " ?c1 " " ?newColor1 " " ?newColor2 " " ?newColor3 crlf)
)


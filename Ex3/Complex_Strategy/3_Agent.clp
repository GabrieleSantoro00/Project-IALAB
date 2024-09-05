;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT (import MAIN ?ALL) (import GAME ?ALL) (export ?ALL))


(deftemplate secret-code
  (multislot code (allowed-values blue green red yellow orange white black purple) (cardinality 4 4))
)


(deffacts codice-segreto
 (secret-code (code black green yellow orange))
)

(defglobal ?*best-right-placed* = 0)
(defglobal ?*best-miss-placed* = 0)

(deftemplate score
 (slot step (type INTEGER))
 (slot value (type INTEGER))
)
;; Template per memorizzare il best attempt
(deftemplate best-attempt
  (slot step (type INTEGER))
  (multislot g (allowed-values blue green red yellow orange white black purple))
  (slot score (type INTEGER))
)


(defglobal ?*tried-colors* = (create$))
(defglobal ?*best-attempt* = (create$))
(defglobal ?*best-score* = 0)
(defglobal ?*best-attempt-case* = "")
(defglobal ?*best-feedback* = "")


(deffunction generate-new-color (?color1 ?color2 ?color3 ?color4 $?excluded-colors)
  (bind ?available-colors (create$ blue green red yellow orange white black purple))
  (foreach ?exclude ?excluded-colors
     (bind ?available-colors (delete-member$ ?available-colors ?exclude))
  )
  (bind ?newColor nil)
  (foreach ?color ?available-colors
     (if (and (not (member$ ?color (create$ ?color1 ?color2 ?color3 ?color4)))
              (not (eq ?color ?newColor)))
        then
        (bind ?newColor ?color)
        (return ?newColor)
     )
  )
  (if (eq ?newColor nil)
     then
     (if (eq (length$ ?available-colors) 0)
        then
        (bind ?*tried-colors* (create$)) ; Reset tried colors
        (return (generate-new-color ?color1 ?color2 ?color3 ?color4 $?excluded-colors)) ; Retry generating a new color
     )
     (return (nth$ 1 ?available-colors)) ; Return the first available color as a fallback
  )
  (return ?newColor)
)


(deffunction user-first-guess ()
  (printout t "Please enter your first guess: ")
  (bind ?input (readline))
  (return (explode$ ?input))
)


(defrule human-player
  ?status <- (status (step ?s) (mode human))
  (agent-first)
=>
  (printout t " 🔴 = Rightplaced, ⚪ = Missplaced " crlf)
  (bind $?colorsguess (user-first-guess))
  (assert (guess (step ?s) (g $?colorsguess)))
  (modify ?status (mode computer))
  (printout t "--- GUESS " ?s " ---- " $?colorsguess crlf)
  (pop-focus)
)




;; Template per memorizzare i tentativi precedenti
(deftemplate attempt
  (slot step (type INTEGER))
  (multislot g (allowed-values blue green red yellow orange white black purple))
  (slot score (type INTEGER))
)


;; Calcolo del punteggio
(defrule calculate-score
 ?feedback <- (answer (step ?s) (right-placed ?rp) (miss-placed ?mp))
 =>
 (bind ?score (+ (* 2 ?rp) ?mp))
 (assert (score (step ?s) (value ?score)))
 (printout t "Score for step " ?s " is: " ?score crlf)
 (printout t "Score attuale: " ?score " best-score is: " ?*best-score* crlf)
)

(defrule update-best-attempt
 ?score <- (score (step ?s) (value ?v))
 ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
 ?feedback <- (answer (step ?s) (right-placed ?rp) (miss-placed ?mp))
 =>
  ;; Memorizza il tentativo precedente
 (bind ?last-combination (create$ ?c1 ?c2 ?c3 ?c4))
 (if (> ?v ?*best-score*)
 then
   (bind ?*best-score* ?v)
   (bind ?*best-attempt* (create$ ?c1 ?c2 ?c3 ?c4))
   (bind ?*best-right-placed* ?rp)
   (bind ?*best-miss-placed* ?mp)
   (bind ?best-attempt-str (str-cat ?c1 " " ?c2 " " ?c3 " " ?c4))
   (bind ?feedback-str (str-cat ?rp "r-" ?mp "m"))
   (bind ?*best-feedback* ?feedback-str)
   (printout t "New best attempt with score: " ?v crlf)
   (printout t "Best attempt combination: " ?best-attempt-str crlf)
   (printout t "Best feedback: " ?feedback-str crlf)
 else
   (if (< ?v ?*best-score*)
   then
    (bind ?feedback-str (str-cat ?*best-right-placed* "r-" ?*best-miss-placed* "m"))
    (bind ?*best-feedback* ?feedback-str)
    (bind ?last-combination ?*best-attempt*)
    (printout t "Generating new attempt based on best attempt " ?last-combination crlf)
    (printout t "Best feedback: " ?*best-feedback* crlf)
    (assert (answer (step ?s) (right-placed ?rp) (miss-placed ?mp)))
    (printout t "rightplaced " ?*best-right-placed* " missplaced: " ?*best-miss-placed* crlf)
    (assert (guess (step ?s) (g ?last-combination)))
   )
 )
)
;; Regole di feedback esistenti
;; (Includi tutte le regole di feedback che hai fornito precedentemente)


(defrule handle-feedback-3-right-placed-0-miss-placed
  ?score <- (score (step ?s) (value ?v))
  ?feedback <- (answer (step ?s) (right-placed 3) (miss-placed 0))
  ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
  =>
  (printout t "----ANSWER " ?s "----: 3 🔴 - 0 ⚪" crlf)
  (retract ?feedback)
  (bind ?newColor (generate-new-color ?c1 ?c2 ?c3 ?c4 ?*tried-colors*))
  (assert (guess (step (+ ?s 1)) (g ?c1 ?c2 ?c3 ?newColor)))
  (bind ?*tried-colors* (create$ ?*tried-colors* ?newColor))
  (printout t "-----GUESS " (+ ?s 1) "---- " ?c1 " " ?c2 " " ?c3 " " ?newColor crlf)
)




(defrule handle-feedback-2-right-placed-0-miss-placed
?feedback <- (answer (step ?s) (right-placed 2) (miss-placed 0))
?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
=>
(printout t "----ANSWER " ?s "----: 2 🔴 - 0 ⚪" crlf)
(retract ?feedback)
(bind ?newColor1 (generate-new-color ?c1 ?c2 ?c3 ?c4))
(bind ?newColor2 (generate-new-color ?c1 ?c2 ?c3 ?c4 ?newColor1))
(while (or (member$ (create$ ?c1 ?c2 ?newColor1 ?newColor2) ?*tried-colors*)
          (member$ (create$ ?c1 ?c2 ?newColor2 ?newColor1) ?*tried-colors*)
          (eq ?newColor1 ?newColor2))
 (bind ?newColor1 (generate-new-color ?c1 ?c2 ?c3 ?c4))
 (bind ?newColor2 (generate-new-color ?c1 ?c2 ?c3 ?c4 ?newColor1)))
(assert (guess (step (+ ?s 1)) (g ?c1 ?c2 ?newColor1 ?newColor2)))
(bind ?*tried-colors* (create$ ?*tried-colors* (create$ ?c1 ?c2 ?newColor1 ?newColor2)))
(printout t "-----GUESS " (+ ?s 1) "---- " ?c1 " " ?c2 " " ?newColor1 " " ?newColor2 crlf)
)




(defrule handle-feedback-1-right-placed-0-miss-placed
?feedback <- (answer (step ?s) (right-placed 1) (miss-placed 0))
?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
=>
(printout t "----ANSWER " ?s "----: 1 🔴 - 0 ⚪" crlf)
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
(printout t "----ANSWER " ?s "----: 1 🔴 - 1 ⚪" crlf)
(retract ?feedback)
(bind ?newColor1 (generate-new-color ?c1 ?c2 ?c3 ?c4))
(bind ?newColor2 (generate-new-color ?c1 ?c2 ?c3 ?c4 ?newColor1))
(while (member$ (create$ ?c1 ?newColor1 ?newColor2 ?c4) ?*tried-colors*)
 (bind ?newColor1 (generate-new-color ?c1 ?c2 ?c3 ?c4))
 (bind ?newColor2 (generate-new-color ?c1 ?c2 ?c3 ?c4 ?newColor1)))
(assert (guess (step (+ ?s 1)) (g ?c1 ?newColor1 ?newColor2 ?c4)))
(bind ?*tried-colors* (create$ ?*tried-colors* (create$ ?c1 ?newColor1 ?newColor2 ?c4)))
(printout t "-----GUESS " (+ ?s 1) "---- " ?c1 " " ?c4 " " ?newColor2 " " ?newColor1 crlf)
)




(defrule handle-feedback-0-right-placed-0-miss-placed
 ?feedback <- (answer (step ?s) (right-placed 0) (miss-placed 0))
 ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
 =>
 (printout t "----ANSWER " ?s "----: 0 🔴 - 0 ⚪" crlf)
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
)








(defrule handle-feedback-2-right-placed-2-miss-placed
?feedback <- (answer (step ?s) (right-placed 2) (miss-placed 2))
?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
=>
(printout t "----ANSWER " ?s "----: 2 🔴 - 2 ⚪" crlf)
(retract ?feedback)
(assert (guess (step (+ ?s 1)) (g ?c1 ?c2 ?c4 ?c3)))
(printout t "-----GUESS " (+ ?s 1) "---- " ?c1 " " ?c2 " " ?c4 " " ?c3 crlf)
)








(defrule handle-feedback-2-right-placed-1-miss-placed
?feedback <- (answer (step ?s) (right-placed 2) (miss-placed 1))
?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
=>
(printout t "----ANSWER " ?s "----: 2 🔴 - 1 ⚪" crlf)
(retract ?feedback)
(bind ?newColor (generate-new-color ?c1 ?c2 ?c3 ?c4))
(assert (guess (step (+ ?s 1)) (g ?c1 ?c2 ?c4 ?newColor)))
(printout t "-----GUESS " (+ ?s 1) "---- " ?c1 " " ?c2 " " ?c4 " " ?newColor crlf)
)








(defrule handle-feedback-1-right-placed-3-miss-placed
?feedback <- (answer (step ?s) (right-placed 1) (miss-placed 3))
?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
=>
(printout t "----ANSWER " ?s "----: 1 🔴 - 3 ⚪" crlf)
(retract ?feedback)
(assert (guess (step (+ ?s 1)) (g ?c1 ?c4 ?c3 ?c2)))
(printout t "-----GUESS " (+ ?s 1) "---- " ?c1 " " ?c4 " " ?c3 " " ?c2 crlf)
)








(defrule handle-feedback-1-right-placed-2-miss-placed
?feedback <- (answer (step ?s) (right-placed 1) (miss-placed 2))
?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
=>
(printout t "----ANSWER " ?s "----: 1 🔴 - 2 ⚪" crlf)
(retract ?feedback)
(bind ?newColor (generate-new-color ?c1 ?c2 ?c3 ?c4))
(assert (guess (step (+ ?s 1)) (g ?c1 ?c4 ?c3 ?newColor)))
(printout t "-----GUESS " (+ ?s 1) "---- " ?c1 " " ?c4 " " ?c3 " " ?newColor crlf)
)








(defrule handle-feedback-0-right-placed-4-miss-placed
?feedback <- (answer (step ?s) (right-placed 0) (miss-placed 4))
?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
=>
(printout t "----ANSWER " ?s "----: 0 🔴 - 4 ⚪" crlf)
(retract ?feedback)
(assert (guess (step (+ ?s 1)) (g ?c2 ?c3 ?c4 ?c1)))
(printout t "-----GUESS " (+ ?s 1) "---- " ?c2 " " ?c3 " " ?c4 " " ?c1 crlf)
)








(defrule handle-feedback-0-right-placed-3-miss-placed
?feedback <- (answer (step ?s) (right-placed 0) (miss-placed 3))
?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
=>
(printout t "----ANSWER " ?s "----: 0 🔴 - 3 ⚪" crlf)
(retract ?feedback)
(bind ?newColor (generate-new-color ?c1 ?c2 ?c3 ?c4))
(assert (guess (step (+ ?s 1)) (g ?c2 ?c3 ?c4 ?newColor)))
(printout t "-----GUESS " (+ ?s 1) "---- " ?c2 " " ?c3 " " ?c4 " " ?newColor crlf)
)








(defrule handle-feedback-0-right-placed-2-miss-placed
?feedback <- (answer (step ?s) (right-placed 0) (miss-placed 2))
?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
=>
(printout t "----ANSWER " ?s "----: 0 🔴 - 2 ⚪" crlf)
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
(printout t "----ANSWER " ?s "----: 0 🔴 - 1 ⚪" crlf)
(retract ?feedback)
(bind ?newColor1 (generate-new-color ?c1 ?c2 ?c3 ?c4))
(bind ?newColor2 (generate-new-color ?c1 ?c2 ?c3 ?c4 ?newColor1))
(bind ?newColor3 (generate-new-color ?c1 ?c2 ?c3 ?c4 ?newColor1 ?newColor2))
(assert (guess (step (+ ?s 1)) (g ?c1 ?newColor1 ?newColor2 ?newColor3)))
(printout t "-----GUESS " (+ ?s 1) "---- " ?c1 " " ?newColor1 " " ?newColor2 " " ?newColor3 crlf)
)








(defrule for-computer-gameover
(declare (salience -15))
?status <- (status (step ?s&:(>= ?s 9)) (mode computer))
?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
?code <- (secret-code (code ?sc1 ?sc2 ?sc3 ?sc4))
(test (or (neq ?c1 ?sc1) (neq ?c2 ?sc2) (neq ?c3 ?sc3) (neq ?c4 ?sc4)))
=>
(printout t "GAME OVER!!" crlf)
(printout t "The secret code was: " ?sc1 " " ?sc2 " " ?sc3 " " ?sc4 crlf)
)






















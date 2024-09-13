;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT (import MAIN ?ALL) (import GAME ?ALL) (export ?ALL))

(deftemplate secret-code
  (multislot code (allowed-values blue green red yellow orange white black purple) (cardinality 4 4))
)


;La variabile globale ?*tried-colors* tiene traccia delle combinazioni di colori già provate, non dei singoli colori.
;Questo significa che un colore può essere riutilizzato in una nuova combinazione, purché la combinazione stessa non sia già stata tentata.
(defglobal ?*tried-colors* = (create$))


; Funzione con lo scopo di generare un nuovo colore che non sia già presente in un insieme di colori dati e che non sia in una lista di colori esclusi

(deffunction generate-new-color (?color1 ?color2 ?color3 ?color4 $?excluded-colors)
  (bind ?available-colors (create$ blue green red yellow orange white black purple))
  (foreach ?exclude ?excluded-colors
     (bind ?available-colors (delete-member$ ?available-colors ?exclude)) ;I colori esclusi sono quelli passati come argomento alla funzione generate-new-color
     ;tramite il parametro $?excluded-colors. Questo parametro rappresenta una lista di colori che non devono essere considerati tra i colori
     ;disponibili per la generazione di un nuovo colore.
  )
  (bind ?newColor nil)
  (foreach ?color ?available-colors ;Itera sui colori disponibili e seleziona il primo colore che non è già presente nell'insieme di colori dati e che non è uguale a ?newColor.
     (if (and (not (member$ ?color (create$ ?color1 ?color2 ?color3 ?color4)))
              (not (eq ?color ?newColor)))
        then
        (bind ?newColor ?color)
        (return ?newColor)
     )
  )
  (if (eq ?newColor nil). ;Se ?newColor è nil e non ci sono colori disponibili, resetta la lista dei colori provati e richiama la funzione.
                           ;Se ci sono ancora colori disponibili, ritorna il primo colore disponibile.
     then
     (if (eq (length$ ?available-colors) 0)
        then
        (bind ?*tried-colors* (create$))
        (return (generate-new-color ?color1 ?color2 ?color3 ?color4 $?excluded-colors))
     )
     (return (nth$ 1 ?available-colors))
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


(defrule handle-feedback-3-right-placed-0-miss-placed
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
(bind ?*tried-colors* (create$ ?*tried-colors* (create$ ?c1 ?c2 ?newColor1 ?newColor2))) ;viene generata una nuova combinazione di colori e viene verificato se
                                            ;questa combinazione è già presente in ?*tried-colors*. Se la combinazione è nuova, viene aggiunta alla lista dei tentativi
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


(deffacts codice-segreto
 (secret-code (code black green yellow orange))
)



















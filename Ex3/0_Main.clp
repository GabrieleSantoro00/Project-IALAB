(defmodule MAIN (export ?ALL))



(deftemplate status (slot step) 
                    (slot mode (allowed-values human computer)) 
)


;Se esiste un fatto maxduration e un fatto status dove il valore di step è minore di maxduration, 
;allora il focus viene spostato sul modulo AGENT.
(defrule go-on-agent  (declare (salience 30))
   (maxduration ?d)
   (status (step ?s&:(< ?s ?d)) )

 =>

    ;(printout t crlf crlf)
    ;(printout t "vado ad agent  step" ?s)
    (focus AGENT)
)

;Se esiste un fatto maxduration e un fatto status dove il valore di step è minore di maxduration,
;allora il focus viene spostato sul modulo GAME.
(defrule go-on-env  (declare (salience 30))
   (maxduration ?d)
  ?f1<-	(status (step ?s&:(< ?s  ?d)))

=>

  ; (printout t crlf crlf)
  ; (printout t "vado a GAME  step" ?s)
  (focus GAME)

)

;Se esiste un fatto maxduration e un fatto status dove il valore di step è minore di maxduration,
;allora il valore di step viene incrementato di 1.
(defrule next-step  (declare (salience 20))
   (maxduration ?d)
  ?f1<-	(status (step ?s&:(< ?s  ?d)))

=>
  
 (bind ?s2 (+ ?s 1))
 (modify ?f1 (step ?s2))

)

;Se esiste un fatto maxduration e un fatto status dove il valore di step è uguale a maxduration,
;allora il focus viene spostato sul modulo GAME.
(defrule game-over
	(maxduration ?d)
	(status (step ?s&:(>= ?s ?d)))
=>
	(focus GAME)
)

;Definisce un insieme di fatti iniziali 
(deffacts initial-facts
	(maxduration 10)
	(status (step 0) (mode human))
	;;(status (step 0) (mode computer))
	(agent-first)
)


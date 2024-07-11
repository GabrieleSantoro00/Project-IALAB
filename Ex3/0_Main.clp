(defmodule MAIN (export ?ALL))



(deftemplate status (slot step) (slot mode (allowed-values human computer)) )



(defrule go-on-agent  (declare (salience 30))
   (maxduration ?d)
   (status (step ?s&:(< ?s ?d)) )

 =>

    ;(printout t crlf crlf)
    ;(printout t "vado ad agent  step" ?s)
    (focus AGENT)
)


(defrule go-on-env  (declare (salience 30))
   (maxduration ?d)
  ?f1<-	(status (step ?s&:(< ?s  ?d)))

=>

  ; (printout t crlf crlf)
  ; (printout t "vado a GAME  step" ?s)
  (focus GAME)

)

(defrule next-step  (declare (salience 20))
   (maxduration ?d)
  ?f1<-	(status (step ?s&:(< ?s  ?d)))

=>
  
 (bind ?s2 (+ ?s 1))
 (modify ?f1 (step ?s2))

)

(defrule game-over
	(maxduration ?d)
	(status (step ?s&:(>= ?s ?d)))
=>
	(focus GAME)
)

(deffacts initial-facts
	(maxduration 10)
	(status (step 0) (mode human))
	;;(status (step 0) (mode computer))
	(agent-first)
)


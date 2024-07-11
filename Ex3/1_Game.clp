(defmodule GAME (import MAIN ?ALL) (export deftemplate guess answer))


(deftemplate secret-code
	(multislot code (allowed-values blue green red yellow orange white black purple) (cardinality 4 4))
)

(deftemplate guess
	(slot step (type INTEGER))
	(multislot g (allowed-values blue green red yellow orange white black purple) (cardinality 4 4))
)

(deftemplate answer
	(slot step (type INTEGER))
	(slot right-placed (type INTEGER))
	(slot miss-placed (type INTEGER))
)



(defrule check-mate (declare (salience 100))
  (status (step ?s))
  ?f <- (guess (step ?s) (g ?k1 ?k2 ?k3 ?k4))
  (secret-code (code ?k1 ?k2 ?k3 ?k4) )
  =>
  (printout t "You have discovered the secrete code!" crlf)
  (retract ?f)
  (halt) 
)

(defrule prepare-answer
   (status (step ?s))
   (guess (step ?s))
=>
   (assert (answer (step ?s) (right-placed 0) (miss-placed 0)))
)      

(defrule check-repeated-colors (declare (salience 100))
  (status (step ?s))
  ?g <- (guess (step ?s) (g $?prima ?k $?durante ?k $?dopo))
=>
  (retract ?g)
  (pop-focus)
)

(defrule check-miss-placed
  (status (step ?s))
  (secret-code (code $?prima ?k $?dopo) )
  (guess (step ?s) (g $?prima2 ?k $?dopo2))
  (test (neq (length$ $?prima2) (length$ $?prima)))
  (test (neq (length$ $?dopo2) (length$ $?dopo)))
=>
  (bind ?new (gensym*))
  (assert (missplaced ?new))
)

(defrule count-missplaced
  (status (step ?s))
  ?a <- (answer (step ?s) (miss-placed ?mp))
  ?m <- (missplaced ?)
=>
  (retract ?m)
  (bind ?new-mp (+ ?mp 1))
  (modify ?a (miss-placed ?new-mp))  
)

(defrule check-right-placed
  (status (step ?s))
  (secret-code (code $?prima ?k $?dopo) )
  (guess (step ?s) (g $?prima2  ?k $?dopo2))
  (test (eq (length$ $?prima2) (length$ $?prima)))
  (test (eq (length$ $?dopo2) (length$ $?dopo)))   
=>
  (bind ?new (gensym*))
  (assert (rightplaced ?new))
)

(defrule count-rightplaced
  (status (step ?s))
  ?a <- (answer (step ?s) (right-placed ?rp) (miss-placed ?mp))
  ?r <- (rightplaced ?)
=>
  (retract ?r)
  (bind ?new-rp (+ ?rp 1))
  (modify ?a (right-placed ?new-rp))
)

(defrule for-humans (declare (salience -10))
  (status (step ?s) (mode human))
  (answer (step ?s) (right-placed ?rp) (miss-placed ?mp)) 
=>
   (printout t "Right placed " ?rp " missplaced " ?mp crlf)
)  


(defrule for-humans-gameover (declare (salience -15))
  (status (step ?s) (mode human))
  (maxduration ?d&:(>= ?s ?d))
  (secret-code (code $?code))
=>
   (printout t "GAME OVER!! " crlf)
   (printout t "The secret code was: " $?code crlf)
)  

(defrule  random-start (declare (salience 100))
	(random)
	(not (secret-code (code $?)))
=>
	(assert (secret-code (code (create$))))
)	
	

(defrule random-code (declare (salience 100))
	(random)
	(colors $?cls)
	(secret-code (code $?colors))
	(test (neq (length$ $?colors) 4))
=>
	(bind ?roll (random 1 8))
	(bind ?c-sym (nth$ ?roll $?cls))
	(assert (try ?c-sym))		
)

(defrule try-new-color-yes (declare (salience 100))
	(random)
	?s <- (secret-code (code $?colors))
	(test (neq (length$ $?colors) 4))
	?t <- (try ?c-sym)
	(test (not (member$ ?c-sym $?colors)))
=>
	(retract ?t)
	(modify ?s (code $?colors ?c-sym))	
)

(defrule try-new-color-no (declare (salience 100))
	(random)
	?s <- (secret-code (code $?colors))
	(test (neq (length$ $?colors) 4))
	?t <- (try ?c-sym)
	(test (member$ ?c-sym $?colors))
=>
	(retract ?t)
	(retract ?s)
	(assert (secret-code (code $?colors)))
)



(deffacts my-colors
 (colors blue green red yellow orange white black purple)
 )



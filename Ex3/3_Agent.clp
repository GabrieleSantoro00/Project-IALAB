;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT (import MAIN ?ALL) (import GAME ?ALL) (export ?ALL))

(defrule human-player
  (status (step ?s) (mode human))
  =>
  (printout t "Your guess at step " ?s crlf)
  (bind $?input (readline)) ;legge l'input dell'utente
  (assert (guess (step ?s) (g  (explode$ $?input)) )) ;explode$ converte la stringa in una lista di caratteri (divisi da spazi)
    (pop-focus)
 )

 ; ----------------- PARTE AGGIUNTA DA ME -----------------

 
 




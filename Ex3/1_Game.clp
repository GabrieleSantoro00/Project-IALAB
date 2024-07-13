 (defmodule GAME (import MAIN ?ALL) (export deftemplate guess answer))


(deftemplate secret-code
	(multislot code (allowed-values blue green red yellow orange white black purple) (cardinality 4 4))
)

;Definisce un template per le ipotesi dei giocatori, includendo il passo di gioco e 4 colori indovinati
(deftemplate guess
	(slot step (type INTEGER))
	(multislot g (allowed-values blue green red yellow orange white black purple) (cardinality 4 4))
)

(deftemplate answer
	(slot step (type INTEGER))
	(slot right-placed (type INTEGER))  ;rossi
	(slot miss-placed (type INTEGER))   ;bianchi
)

(deffacts my-colors
 (colors blue green red yellow orange white black purple)
 )
 
; Caso vincente
(defrule check-mate (declare (salience 100))
  (status (step ?s))
  ?f <- (guess (step ?s) (g ?k1 ?k2 ?k3 ?k4))   ;confronto fatto tramite pattern matching
  (secret-code (code ?k1 ?k2 ?k3 ?k4))
  =>
  (printout t "You have discovered the secrete code!" crlf)
  (retract ?f)  ;rimuove il tentativo
  (halt)  ;fine del gioco se indovina il codice
)

;Prepara la situazione iniziale del gioco con 0 colori indovinati e 0 colori indovinati ma non al posto giusto
(defrule prepare-answer
   (status (step ?s))
   (guess (step ?s))
=>
   (assert (answer (step ?s) (right-placed 0) (miss-placed 0)))   ;viene asserito un fatto answer con 0 colori indovinati e 0 colori indovinati ma non al posto giusto
)      

 ;Controlla se ci sono colori ripetuti
(defrule check-repeated-colors (declare (salience 100))
  (status (step ?s))
  ?g <- (guess (step ?s) (g $?prima ?k $?durante ?k $?dopo))
=>
  (retract ?g)
  (pop-focus)     ;toglie il focus da Agent e lo rimette su Game
)

(defrule check-miss-placed ;bianchi
  (status (step ?s))
  (secret-code (code $?prima ?k $?dopo))
  (guess (step ?s) (g $?prima2 ?k $?dopo2))
  ;test è un'alternativa ai field constraint
  (test (neq (length$ $?prima2) (length$ $?prima)))   ;la lunghezza di $?prima2 deve esser diversa da quella di $?prima
  (test (neq (length$ $?dopo2) (length$ $?dopo)))
=>
  (bind ?new (gensym*))
  (assert (missplaced ?new))
)

;Nella regola check-miss-placed, la funzione length$ viene utilizzata per determinare il numero di elementi nelle liste 
;rappresentate dalle variabili ?$prima, ?$dopo, ?$prima2, e ?$dopo2. Questo confronto di lunghezza serve a identificare 
;se un colore (?k) nella posizione corrente del tentativo di indovinare (guess) è presente nel codice segreto 
;(secret-code), ma in una posizione diversa. Ecco come funziona:
;?$prima e ?$dopo rappresentano le liste dei colori prima e dopo il colore corrente ?k nel codice segreto.
;?$prima2 e ?$dopo2 rappresentano le liste dei colori prima e dopo il colore corrente ?k nel tentativo di indovinare.
;L'uso di length$ per confrontare le lunghezze di queste liste aiuta a stabilire se il colore ?k è stato spostato da 
;una posizione all'altra tra il codice segreto e il tentativo di indovinare. Se le lunghezze delle liste corrispondenti 
;sono diverse ((test (neq (length$ $?prima2) (length$ $?prima))) e (test (neq (length$ $?dopo2) (length$ $?dopo)))), 
;significa che il colore ?k è presente in entrambi, ma la sua posizione relativa è cambiata, indicando così che è 
;stato "mispiazzato".  

;Incrementa il numero di colori mal posizionati
(defrule count-missplaced
  (status (step ?s))
  ?a <- (answer (step ?s) (miss-placed ?mp))
  ?m <- (missplaced ?)    ;? deve contenere un valore (wildcard singoletta)
=>
  (retract ?m)
  (bind ?new-mp (+ ?mp 1))
  (modify ?a (miss-placed ?new-mp))  ;?a contiene ?new-mp
)

;Controlla i rossi
(defrule check-right-placed
  (status (step ?s))
  (secret-code (code $?prima ?k $?dopo) )
  (guess (step ?s) (g $?prima2  ?k $?dopo2))
  (test (eq (length$ $?prima2) (length$ $?prima)))
  (test (eq (length$ $?dopo2) (length$ $?dopo)))   
=>
  (bind ?new (gensym*)) ;crea variabili ?new1, ?new2, ?new3, ?new4, ecc...
  (assert (rightplaced ?new))
)

;L'uso di gensym* (vedi regola sopra) nella regola check-right-placed serve a creare un identificatore unico 
;per ogni fatto rightplaced asserito, garantendo che ogni fatto possa essere identificato e gestito individualmente, 
;anche se più fatti rightplaced vengono generati durante l'esecuzione del programma. 
;Questo è particolarmente utile in contesti dove è necessario tracciare o riferirsi a specifici eventi o condizioni 
;che si verificano durante l'esecuzione. 
;I fatti generati con gensym* vengono utilizzati nelle regole count-missplaced e count-rightplaced per contare il 
;numero di colori posizionati correttamente (rightplaced) e quelli posizionati in modo errato (missplaced) rispetto 
;al codice segreto. Quando un fatto missplaced o rightplaced viene identificato, viene asserito con un identificatore 
;unico generato da gensym*. Questi fatti vengono poi retraessi (retract) nelle regole count-missplaced e 
;count-rightplaced dopo aver aggiornato il conteggio nel fatto answer corrispondente, assicurando che ogni colore venga 
;contato una sola volta. Questo processo aiuta a mantenere un conteggio accurato dei colori correttamente e 
;erroneamente posizionati in ogni tentativo di indovinare il codice segreto.

;Conta i rossi
(defrule count-rightplaced
  (status (step ?s))
  ?a <- (answer (step ?s) (right-placed ?rp) (miss-placed ?mp))
  ?r <- (rightplaced ?)
=>
  (retract ?r)
  (bind ?new-rp (+ ?rp 1))
  (modify ?a (right-placed ?new-rp))
)

;Stampa il numero di colori correttamente posizionati e mal posizionati per l'agente (feedback)
(defrule for-humans (declare (salience -10))
  (status (step ?s) (mode human))
  (answer (step ?s) (right-placed ?rp) (miss-placed ?mp)) 
=>
   (printout t "Right placed " ?rp " missplaced " ?mp crlf)
)  

; Quando i tentativi sono >= del massimo numero di tentativi, il gioco termina
(defrule for-humans-gameover (declare (salience -15))
  (status (step ?s) (mode human))
  (maxduration ?d&:(>= ?s ?d))
  (secret-code (code $?code))
=>
   (printout t "GAME OVER!! " crlf)
   (printout t "The secret code was: " $?code crlf)
)  

;Inizia il gioco con un codice segreto casuale (genera un colore alla volta)
(defrule  random-start (declare (salience 100))
	(random)
	(not (secret-code (code $?)))
=>
	(assert (secret-code (code (create$)))) ;crea lista con codice segreto
)	
	
;Genera un colore casuale da aggiungere al codice segreto se questo non ha ancora 4 colori
;Mentre random-start potrebbe servire come punto di partenza per stabilire l'esistenza del codice segreto, 
;random-code è responsabile di popolarlo progressivamente fino al raggiungimento di una condizione desiderata 
;(in questo caso, un codice composto da 4 colori)
(defrule random-code (declare (salience 100))
	(random)
	(colors $?cls)
	(secret-code (code $?colors))
	(test (neq (length$ $?colors) 4))
=>
	(bind ?roll (random 1 8))
	(bind ?c-sym (nth$ ?roll $?cls))  ;viene preso un colore casuale dalla lista dei colori
	(assert (try ?c-sym))		;try contiene il colore selezionato
)

;Aggiunge un nuovo colore al codice segreto se non è già presente
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

;Ritenta la generazione di un nuovo colore per il codice segreto se il colore generato è già presente
;Ciò impedisce che vengano aggiunti colori duplicati al codice segreto
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







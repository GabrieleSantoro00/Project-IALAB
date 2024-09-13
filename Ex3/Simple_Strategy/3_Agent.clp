;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT (import MAIN ?ALL) (import GAME ?ALL) (export ?ALL))

(deftemplate secret-code
(multislot code (allowed-values blue green red yellow orange white black purple) (cardinality 4 4))
)

(deffacts available-colors
(colors green blue red yellow orange white black purple)
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
(assert (guess (step ?s) (g $?colorsguess) ))
(modify ?status (mode computer))
(printout t "--- GUESS " ?s " ---- " ?colorsguess crlf)
(pop-focus)
)

;La regola si attiva se:
 ;1. quando viene inserito un feedback da parte del sistema che indica che il tentativo corrente è 3r-0m
 ;2. esiste un tentativo specifico (?guess) nel passo corrente (?s).
 ;3. si verifica che esista un fatto colors con la lista dei colori disponibili (?$colors).

(defrule handle-feedback-3-right-placed-0-miss-placed
  ?feedback <- (answer (step ?s) (right-placed 3) (miss-placed 0))
  ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
  (colors $?colors)
  =>
  (printout t "----ANSWER " ?s "----: 3 🔴 - 0 ⚪" crlf)
  ;; Aggiornare la lista dei colori disponibili eliminando quelli che sono già stati usati nella combinazione attuale
  (foreach ?c (create$ ?c1 ?c2 ?c3 ?c4)
     (bind $?colors (delete-member$ $?colors ?c))
  )
  ;; Sceglie una posizione random da 1 a 4 per sostituire il colore
  (bind ?r (random 1 4))
  ;; Sceglie un nuovo colore random dai colori rimanenti
  (bind ?cNew (nth$ (random 1 (length$ $?colors)) $?colors))
  ;; Crea una nuova combinazione sostituendo il colore alla posizione scelta
  (bind ?new-colors (replace$ (create$ ?c1 ?c2 ?c3 ?c4) ?r ?r ?cNew))
  ;; Asserisce il nuovo tentativo
  (assert (guess (step (+ ?s 1)) (g ?new-colors)))
  ;; Stampa la nuova combinazione
  (printout t "-----GUESS " (+ ?s 1) "---- " (nth$ 1 ?new-colors) " " (nth$ 2 ?new-colors) " " (nth$ 3 ?new-colors) " " (nth$ 4 ?new-colors) crlf)
)


(defrule handle-feedback-2-right-placed-0-miss-placed
  ?feedback <- (answer (step ?s) (right-placed 2) (miss-placed 0))
  ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
  (colors $?colors)
=>
  (printout t "----ANSWER " ?s "----: 2 🔴 - 0 ⚪" crlf)
  (retract ?feedback)
  ;; Rimuove i colori già presenti dalla lista dei colori disponibili
  (foreach ?c (create$ ?c1 ?c2 ?c3 ?c4)
     (bind $?colors (delete-member$ $?colors ?c))
  )
  ;; Sceglie due posizioni random da 1 a 4 per sostituire i colori
  (bind ?pos1 (random 1 4))
  (bind ?pos2 ?pos1)
  (while (eq ?pos2 ?pos1) do    ;l’obiettivo di questo blocco di codice è garantire che ?pos2 sia una posizione casuale differente da ?pos1
     (bind ?pos2 (random 1 4))
  )
  ;; Sceglie due nuovi colori random dai colori rimanenti

  (bind ?newColor1 (nth$ (random 1 (length$ $?colors)) $?colors))
  ;genera un numero intero casuale tra 1 e il numero totale di elementi nella lista ?$colors
  ;seleziona un colore casuale dalla lista e lo memorizza in ?newColor1.

  (bind ?newColor2 ?newColor1)
  (while (eq ?newColor2 ?newColor1) do
     (bind ?newColor2 (nth$ (random 1 (length$ $?colors)) $?colors))
  )
  ;inizialmente, ?newColor2 è impostato uguale a ?newColor1
  ;assicurarsi che ?newColor2 parta con lo stesso valore di ?newColor1, in modo da poter successivamente garantire che sia diverso
  ;il ciclo while continua a generare nuovi colori per ?newColor2 finché non è diverso da ?newColor1.


  ;; Crea una nuova combinazione sostituendo i colori alle posizioni scelte
  (bind ?new-colors (replace$ (replace$ (create$ ?c1 ?c2 ?c3 ?c4) ?pos1 ?pos1 ?newColor1) ?pos2 ?pos2 ?newColor2))
    ; 1. Crea una lista di 4 colori usando i valori ?c1, ?c2, ?c3 e ?c4.Questa lista rappresenta una combinazione di colori esistente
    ; 2. Sostituisci il colore alla posizione ?pos1 con il colore ?newColor1
    ; 3. Sostituisci il colore alla posizione ?pos2 con il colore ?newColor2
    ;4. Assegna il risultato finale (la combinazione di colori con entrambe le sostituzioni applicate) alla variabile ?new-colors
  (assert (guess (step (+ ?s 1)) (g ?new-colors)))
  (printout t "-----GUESS " (+ ?s 1) "---- " (nth$ 1 ?new-colors) " " (nth$ 2 ?new-colors) " " (nth$ 3 ?new-colors) " " (nth$ 4 ?new-colors) crlf)
)

;La regola si attiva se:
 ;1. quando viene inserito un feedback da parte del sistema che indica che il tentativo corrente è 1r-0m
 ;2. esiste un tentativo specifico (?guess) nel passo corrente (?s).
 ;3. si verifica che esista un fatto colors con la lista dei colori disponibili (?$colors).
(defrule handle-feedback-1-right-placed-0-miss-placed
  ?feedback <- (answer (step ?s) (right-placed 1) (miss-placed 0))
  ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
  (colors $?colors)
=>
  (printout t "----ANSWER " ?s "----: 1 🔴 - 0 ⚪" crlf)
  (retract ?feedback)
  (foreach ?c (create$ ?c1 ?c2 ?c3 ?c4)
     (bind $?colors (delete-member$ $?colors ?c))
  )
  ;; Sceglie una posizione random da 1 a 4 per mantenere il colore
  (bind ?pos1 (random 1 4))
  (bind ?pos2 ?pos1)
  (while (eq ?pos2 ?pos1) do ;l’obiettivo di questo blocco di codice è garantire che ?pos2 sia una posizione casuale differente da ?pos1
     (bind ?pos2 (random 1 4))
  )
  (bind ?pos3 ?pos1)
  (while (or (eq ?pos3 ?pos1) (eq ?pos3 ?pos2)) do ;l’obiettivo di questo blocco di codice è garantire che ?pos3 sia una posizione casuale differente da ?pos1 e ?pos2
     (bind ?pos3 (random 1 4))
  )
  ;; Sceglie tre nuovi colori random dai colori rimanenti
  (bind ?newColor1 (nth$ (random 1 (length$ $?colors)) $?colors)) ;genera un numero intero casuale tra 1 e il numero totale di elementi nella lista ?$colors
  (bind ?newColor2 ?newColor1) ;inizialmente, ?newColor2 è impostato uguale a ?newColor1
  (while (eq ?newColor2 ?newColor1) do ;assicurarsi che ?newColor2 parta con lo stesso valore di ?newColor1, in modo da poter successivamente garantire che sia diverso
     (bind ?newColor2 (nth$ (random 1 (length$ $?colors)) $?colors)) ;il ciclo while continua a generare nuovi colori per ?newColor2 finché non è diverso da ?newColor1.
  )
  (bind ?newColor3 ?newColor1)
  (while (or (eq ?newColor3 ?newColor1) (eq ?newColor3 ?newColor2)) do ;l’obiettivo di questo blocco di codice è garantire che ?newColor3 sia un colore casuale diverso da ?newColor1 e ?newColor2
     (bind ?newColor3 (nth$ (random 1 (length$ $?colors)) $?colors)) ;il ciclo while continua a generare nuovi colori per ?newColor3 finché non è diverso da ?newColor1 e ?newColor2.
  )
  ;; Crea una nuova combinazione sostituendo i colori alle posizioni scelte
  (bind ?new-colors (replace$ (replace$ (replace$ (create$ ?c1 ?c2 ?c3 ?c4) ?pos1 ?pos1 ?newColor1) ?pos2 ?pos2 ?newColor2) ?pos3 ?pos3 ?newColor3))
  (assert (guess (step (+ ?s 1)) (g ?new-colors)))
  (printout t "-----GUESS " (+ ?s 1) "---- " (nth$ 1 ?new-colors) " " (nth$ 2 ?new-colors) " " (nth$ 3 ?new-colors) " " (nth$ 4 ?new-colors) crlf)
)

;questa regola seleziona casualmente un colore da mantenere nella combinazione attuale,
;rimuove quel colore dalla lista dei colori disponibili e seleziona casualmente un'altra posizione per spostare un altro colore.

(defrule handle-feedback-1-right-placed-0-miss-placed
   ?feedback <- (answer (step ?s) (right-placed 1) (miss-placed 1))
   ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
   (colors $?colors)
=>
   (printout t "----ANSWER " ?s "----: 1 🔴 - 1 ⚪" crlf)
   (retract ?feedback)
   (foreach ?c (create$ ?c1 ?c2 ?c3 ?c4)
      (bind $?colors (delete-member$ $?colors ?c))
   )
   (bind ?keepPos (random 1 4)) ;
   (bind ?keepColor (nth$ ?keepPos (create$ ?c1 ?c2 ?c3 ?c4)))
   ;Estrae il colore dalla combinazione attuale alla posizione indicata da ?keepPos e lo memorizza nella variabile ?keepColor.
   ;La funzione nth$ recupera l'elemento alla posizione specificata dalla lista (create$ ?c1 ?c2 ?c3 ?c4).

   (bind $?colors (delete-member$ $?colors ?keepColor)) ;Questa linea rimuove ?keepColor dalla lista dei colori disponibili
   (bind ?movePos ?keepPos)
   (while (eq ?movePos ?keepPos) do
      (bind ?movePos (random 1 4))
   )
   (bind ?moveColor (nth$ ?movePos (create$ ?c1 ?c2 ?c3 ?c4)))
   (bind $?colors (delete-member$ $?colors ?moveColor))
   ;; Sceglie una nuova posizione per il colore spostato
   (bind ?newMovePos ?keepPos)
   (while (or (eq ?newMovePos ?keepPos) (eq ?newMovePos ?movePos)) do
      (bind ?newMovePos (random 1 4))
   )
   ;; Sceglie due nuovi colori random dai colori rimanenti
   (bind ?newColor1 (nth$ (random 1 (length$ $?colors)) $?colors))
   (bind ?newColor2 ?newColor1)
   (while (or (eq ?newColor2 ?newColor1) (eq ?newColor2 ?keepColor) (eq ?newColor2 ?moveColor)) do
      (bind ?newColor2 (nth$ (random 1 (length$ $?colors)) $?colors))
   )
   (bind ?newColor3 ?newColor1)
   (while (or (eq ?newColor3 ?newColor1) (eq ?newColor3 ?newColor2) (eq ?newColor3 ?keepColor) (eq ?newColor3 ?moveColor)) do
      (bind ?newColor3 (nth$ (random 1 (length$ $?colors)) $?colors))
   )
   ;; Crea una nuova combinazione mantenendo il colore alla posizione scelta e spostando un altro colore
   (bind ?new-colors (create$ ?newColor1 ?newColor2 ?newColor3 ?newColor1))
   (bind ?new-colors (replace$ ?new-colors ?keepPos ?keepPos ?keepColor))
   (bind ?new-colors (replace$ ?new-colors ?newMovePos ?newMovePos ?moveColor))

   (assert (guess (step (+ ?s 1)) (g ?new-colors)))

   (printout t "-----GUESS " (+ ?s 1) "---- " (nth$ 1 ?new-colors) " " (nth$ 2 ?new-colors) " " (nth$ 3 ?new-colors) " " (nth$ 4 ?new-colors) crlf)
)

(defrule handle-feedback-0-right-placed-0-miss-placed
   ?feedback <- (answer (step ?s) (right-placed 0) (miss-placed 0))
   ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
   (colors $?colors)
=>
   (printout t "----ANSWER " ?s "----: 0 🔴 - 0 ⚪" crlf)
   (retract ?feedback)
   (foreach ?c (create$ ?c1 ?c2 ?c3 ?c4)
      (bind $?colors (delete-member$ $?colors ?c))
   )
   (bind ?newColor1 (nth$ (random 1 (length$ $?colors)) $?colors))
   (bind ?newColor2 ?newColor1)
   (while (eq ?newColor2 ?newColor1) do
      (bind ?newColor2 (nth$ (random 1 (length$ $?colors)) $?colors))
   )
   (bind ?newColor3 ?newColor1)
   (while (or (eq ?newColor3 ?newColor1) (eq ?newColor3 ?newColor2)) do
      (bind ?newColor3 (nth$ (random 1 (length$ $?colors)) $?colors))
   )
   (bind ?newColor4 ?newColor1)
   (while (or (eq ?newColor4 ?newColor1) (eq ?newColor4 ?newColor2) (eq ?newColor4 ?newColor3)) do
      (bind ?newColor4 (nth$ (random 1 (length$ $?colors)) $?colors))
   )
   ;; Crea una nuova combinazione con i nuovi colori
   (bind ?new-colors (create$ ?newColor1 ?newColor2 ?newColor3 ?newColor4))

   (assert (guess (step (+ ?s 1)) (g ?new-colors)))

   (printout t "-----GUESS " (+ ?s 1) "---- " (nth$ 1 ?new-colors) " " (nth$ 2 ?new-colors) " " (nth$ 3 ?new-colors) " " (nth$ 4 ?new-colors) crlf)
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
  (printout t "----ANSWER " ?s "----: 2 🔴 - 2 ⚪" crlf)
  (retract ?feedback)
  ;; Sceglie due posizioni random da 1 a 4 per mantenere i colori
  (bind ?keepPos1 (random 1 4))
  (bind ?keepPos2 ?keepPos1)
  (while (eq ?keepPos2 ?keepPos1) do
     (bind ?keepPos2 (random 1 4))
  )
  ;; Ottiene i colori da mantenere
  (bind ?keepColor1 (nth$ ?keepPos1 (create$ ?c1 ?c2 ?c3 ?c4)))
  (bind ?keepColor2 (nth$ ?keepPos2 (create$ ?c1 ?c2 ?c3 ?c4)))
  ;; Ottiene le posizioni dei colori da scambiare
  (bind ?swapPos1 (if (eq ?keepPos1 1) then 2 else 1))
  (while (or (eq ?swapPos1 ?keepPos1) (eq ?swapPos1 ?keepPos2)) do
     (bind ?swapPos1 (+ ?swapPos1 1))
  )
  (bind ?swapPos2 (if (eq ?swapPos1 1) then 2 else 1))
  (while (or (eq ?swapPos2 ?keepPos1) (eq ?swapPos2 ?keepPos2) (eq ?swapPos2 ?swapPos1)) do
     (bind ?swapPos2 (+ ?swapPos2 1))
  )
  ;; Ottiene i colori da scambiare
  (bind ?swapColor1 (nth$ ?swapPos1 (create$ ?c1 ?c2 ?c3 ?c4)))
  (bind ?swapColor2 (nth$ ?swapPos2 (create$ ?c1 ?c2 ?c3 ?c4)))
  ;; Crea una nuova combinazione mantenendo i colori alle posizioni scelte e scambiando gli altri colori
  (bind ?new-colors (create$ ?c1 ?c2 ?c3 ?c4))
  (bind ?new-colors (replace$ ?new-colors ?keepPos1 ?keepPos1 ?keepColor1))
  (bind ?new-colors (replace$ ?new-colors ?keepPos2 ?keepPos2 ?keepColor2))
  (bind ?new-colors (replace$ ?new-colors ?swapPos1 ?swapPos1 ?swapColor2))
  (bind ?new-colors (replace$ ?new-colors ?swapPos2 ?swapPos2 ?swapColor1))

  (assert (guess (step (+ ?s 1)) (g ?new-colors)))

  (printout t "-----GUESS " (+ ?s 1) "---- " (nth$ 1 ?new-colors) " " (nth$ 2 ?new-colors) " " (nth$ 3 ?new-colors) " " (nth$ 4 ?new-colors) crlf)
)


(defrule handle-feedback-2-right-placed-1-miss-placed
  ?feedback <- (answer (step ?s) (right-placed 2) (miss-placed 1))
  ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
  (colors $?colors)
=>
  (printout t "----ANSWER " ?s "----: 2 🔴 - 1 ⚪" crlf)
  (retract ?feedback)

  (bind ?keepPos1 (random 1 4))
  (bind ?keepPos2 ?keepPos1)
  (while (eq ?keepPos2 ?keepPos1) do
     (bind ?keepPos2 (random 1 4))
  )

  ;; Ottiene i colori da mantenere
  (bind ?keepColor1 (nth$ ?keepPos1 (create$ ?c1 ?c2 ?c3 ?c4)))
  (bind ?keepColor2 (nth$ ?keepPos2 (create$ ?c1 ?c2 ?c3 ?c4)))

  ;; Sceglie una posizione random da 1 a 4 per spostare un altro colore
  (bind ?movePos ?keepPos1)
  (while (or (eq ?movePos ?keepPos1) (eq ?movePos ?keepPos2)) do
     (bind ?movePos (random 1 4))
  )
  (bind ?moveColor (nth$ ?movePos (create$ ?c1 ?c2 ?c3 ?c4)))

  ;; Rimuove i colori mantenuti e spostati dalla lista dei colori disponibili
  (bind $?colors (delete-member$ $?colors ?keepColor1))
  (bind $?colors (delete-member$ $?colors ?keepColor2))
  (bind $?colors (delete-member$ $?colors ?moveColor))

  ;; Sceglie una nuova posizione per il colore spostato
  (bind ?newMovePos ?keepPos1)
  (while (or (eq ?newMovePos ?keepPos1) (eq ?newMovePos ?keepPos2) (eq ?newMovePos ?movePos)) do
     (bind ?newMovePos (random 1 4))
  )
  ;; Sceglie un nuovo colore random dai colori rimanenti
  (bind ?newColor (nth$ (random 1 (length$ $?colors)) $?colors))
  ;; Crea una nuova combinazione mantenendo i colori alle posizioni scelte, spostando un colore e sostituendo l'altro
  (bind ?new-colors (create$ ?c1 ?c2 ?c3 ?c4))
  (bind ?new-colors (replace$ ?new-colors ?keepPos1 ?keepPos1 ?keepColor1))
  (bind ?new-colors (replace$ ?new-colors ?keepPos2 ?keepPos2 ?keepColor2))
  (bind ?new-colors (replace$ ?new-colors ?newMovePos ?newMovePos ?moveColor))
  (bind ?new-colors (replace$ ?new-colors ?movePos ?movePos ?newColor))

  ;; Asserisce il nuovo tentativo
  (assert (guess (step (+ ?s 1)) (g ?new-colors)))

  ;; Stampa la nuova combinazione
  (printout t "-----GUESS " (+ ?s 1) "---- " (nth$ 1 ?new-colors) " " (nth$ 2 ?new-colors) " " (nth$ 3 ?new-colors) " " (nth$ 4 ?new-colors) crlf)
)


(defrule handle-feedback-1-right-placed-3-miss-placed
  ?feedback <- (answer (step ?s) (right-placed 1) (miss-placed 3))
  ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
=>
  (printout t "----ANSWER " ?s "----: 1 🔴 - 3 ⚪" crlf)
  (retract ?feedback)

;Viene ottenuto il colore presente nella posizione ?keepPos dall'elenco di colori ?c1 ?c2 ?c3 ?c4.
;Quindi, ?keepColor rappresenta il colore che verrà mantenuto nella sua posizione originale.
  (bind ?keepPos (random 1 4))
  (bind ?keepColor (nth$ ?keepPos (create$ ?c1 ?c2 ?c3 ?c4)))

  ;; Ottiene le posizioni dei colori da scambiare
  (bind ?swapPos1 (if (eq ?keepPos 1) then 2 else 1)) ;Se la posizione mantenuta è 1, la posizione di scambio 1 è 2, altrimenti è 1
  (while (eq ?swapPos1 ?keepPos) do ;Il ciclo while garantisce che la posizione di scambio 1 sia diversa dalla posizione mantenuta
     (bind ?swapPos1 (+ ?swapPos1 1)) ;Se la posizione di scambio 1 è uguale alla posizione mantenuta, incrementa la posizione di scambio 1 di 1
  )
  (bind ?swapPos2 (if (eq ?swapPos1 1) then 2 else 1)). ;Se la posizione di scambio 1 è 1, la posizione di scambio 2 è 2, altrimenti è 1
  (while (or (eq ?swapPos2 ?keepPos) (eq ?swapPos2 ?swapPos1)) do ;Il ciclo while garantisce che la posizione di scambio 2 sia diversa dalla posizione mantenuta e dalla posizione di scambio 1
     (bind ?swapPos2 (+ ?swapPos2 1)) ;Se la posizione di scambio 2 è uguale alla posizione mantenuta o alla posizione di scambio 1, incrementa la posizione di scambio 2 di 1
  )
  (bind ?swapPos3 (if (eq ?swapPos2 1) then 2 else 1)) ;Se la posizione di scambio 2 è 1, la posizione di scambio 3 è 2, altrimenti è 1
  (while (or (eq ?swapPos3 ?keepPos) (eq ?swapPos3 ?swapPos1) (eq ?swapPos3 ?swapPos2)) do ;Il ciclo while garantisce che la posizione di scambio 3 sia diversa dalla posizione mantenuta, dalla posizione di scambio 1 e dalla posizione di scambio 2
     (bind ?swapPos3 (+ ?swapPos3 1)) ;Se la posizione di scambio 3 è uguale alla posizione mantenuta, alla posizione di scambio 1 o alla posizione di scambio 2, incrementa la posizione di scambio 3 di 1
  )

  ;; Ottiene i colori da scambiare
  (bind ?swapColor1 (nth$ ?swapPos1 (create$ ?c1 ?c2 ?c3 ?c4)))  ;Ottiene il colore alla posizione ?swapPos1 dalla lista dei colori ?c1 ?c2 ?c3 ?c4
  (bind ?swapColor2 (nth$ ?swapPos2 (create$ ?c1 ?c2 ?c3 ?c4))) ;Ottiene il colore alla posizione ?swapPos2 dalla lista dei colori ?c1 ?c2 ?c3 ?c4
  (bind ?swapColor3 (nth$ ?swapPos3 (create$ ?c1 ?c2 ?c3 ?c4)))  ;Ottiene il colore alla posizione ?swapPos3 dalla lista dei colori ?c1 ?c2 ?c3 ?c4

  ;; Crea una nuova combinazione mantenendo il colore alla posizione scelta e scambiando gli altri colori
  (bind ?new-colors (create$ ?c1 ?c2 ?c3 ?c4))
  (bind ?new-colors (replace$ ?new-colors ?keepPos ?keepPos ?keepColor)) ;Sostituisce il colore alla posizione ?keepPos con il colore ?keepColor
  (bind ?new-colors (replace$ ?new-colors ?swapPos1 ?swapPos1 ?swapColor2)) ;Sostituisce il colore alla posizione ?swapPos1 con il colore ?swapColor2
  (bind ?new-colors (replace$ ?new-colors ?swapPos2 ?swapPos2 ?swapColor3)) ;Sostituisce il colore alla posizione ?swapPos2 con il colore ?swapColor3
  (bind ?new-colors (replace$ ?new-colors ?swapPos3 ?swapPos3 ?swapColor1)) ;Sostituisce il colore alla posizione ?swapPos3 con il colore ?swapColor1

  ;; Asserisce il nuovo tentativo
  (assert (guess (step (+ ?s 1)) (g ?new-colors)))

  ;; Stampa la nuova combinazione
  (printout t "-----GUESS " (+ ?s 1) "---- " (nth$ 1 ?new-colors) " " (nth$ 2 ?new-colors) " " (nth$ 3 ?new-colors) " " (nth$ 4 ?new-colors) crlf)
)

(defrule handle-feedback-1-right-placed-2-miss-placed
  ?feedback <- (answer (step ?s) (right-placed 1) (miss-placed 2))
  ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
  (colors $?colors)
=>
  (printout t "----ANSWER " ?s "----: 1 🔴 - 2 ⚪" crlf)
  (retract ?feedback)
  ;; Sceglie una posizione random da 1 a 4 per mantenere il colore
  (bind ?keepPos (random 1 4))
  (bind ?keepColor (nth$ ?keepPos (create$ ?c1 ?c2 ?c3 ?c4)))
  ;; Ottiene le posizioni dei colori da scambiare
  (bind ?swapPos1 (random 1 4))
  (while (eq ?swapPos1 ?keepPos) do
     (bind ?swapPos1 (random 1 4))
  )
  (bind ?swapPos2 (random 1 4))
  (while (or (eq ?swapPos2 ?keepPos) (eq ?swapPos2 ?swapPos1)) do
     (bind ?swapPos2 (random 1 4))
  )
  ;; Ottiene i colori da scambiare
  (bind ?swapColor1 (nth$ ?swapPos1 (create$ ?c1 ?c2 ?c3 ?c4))) ;Ottiene il colore alla posizione ?swapPos1 dalla lista dei colori ?c1 ?c2 ?c3 ?c4
  (bind ?swapColor2 (nth$ ?swapPos2 (create$ ?c1 ?c2 ?c3 ?c4))) ;Ottiene il colore alla posizione ?swapPos2 dalla lista dei colori ?c1 ?c2 ?c3 ?c4

  ;; Rimuove i colori mantenuti e scambiati dalla lista dei colori disponibili
  (bind $?colors (delete-member$ $?colors ?keepColor))
  (bind $?colors (delete-member$ $?colors ?swapColor1))
  (bind $?colors (delete-member$ $?colors ?swapColor2))

  ;; Sceglie un nuovo colore random dai colori rimanenti
  (bind ?newColor (nth$ (random 1 (length$ $?colors)) $?colors))

  ;; Ottiene la posizione del colore da sostituire
  (bind ?replacePos (random 1 4))
  (while (or (eq ?replacePos ?keepPos) (eq ?replacePos ?swapPos1) (eq ?replacePos ?swapPos2)) do
     (bind ?replacePos (random 1 4))
  )

  ;; Crea una nuova combinazione mantenendo il colore alla posizione scelta, scambiando due colori e sostituendo l'altro
  (bind ?new-colors (create$ ?c1 ?c2 ?c3 ?c4))
  (bind ?new-colors (replace$ ?new-colors ?keepPos ?keepPos ?keepColor))
  (bind ?new-colors (replace$ ?new-colors ?swapPos1 ?swapPos1 ?swapColor2))
  (bind ?new-colors (replace$ ?new-colors ?swapPos2 ?swapPos2 ?swapColor1))
  (bind ?new-colors (replace$ ?new-colors ?replacePos ?replacePos ?newColor))

  ;; Asserisce il nuovo tentativo
  (assert (guess (step (+ ?s 1)) (g ?new-colors)))

  ;; Stampa la nuova combinazione
  (printout t "-----GUESS " (+ ?s 1) "---- " (nth$ 1 ?new-colors) " " (nth$ 2 ?new-colors) " " (nth$ 3 ?new-colors) " " (nth$ 4 ?new-colors) crlf)
)


(defrule handle-feedback-0-right-placed-4-miss-placed
  ?feedback <- (answer (step ?s) (right-placed 0) (miss-placed 4))
  ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
=>
  (printout t "----ANSWER " ?s "----: 0 🔴 - 4 ⚪" crlf)
  (retract ?feedback)

  ;; Crea una lista delle posizioni originali
  (bind ?positions (create$ 1 2 3 4))

  ;; Crea una lista delle nuove posizioni in modo casuale
  (bind ?newPos1 (nth$ (random 1 (length$ ?positions)) ?positions))
  (bind ?positions (delete-member$ ?positions ?newPos1))
  (bind ?newPos2 (nth$ (random 1 (length$ ?positions)) ?positions))
  (bind ?positions (delete-member$ ?positions ?newPos2))
  (bind ?newPos3 (nth$ (random 1 (length$ ?positions)) ?positions))
  (bind ?positions (delete-member$ ?positions ?newPos3))
  (bind ?newPos4 (nth$ 1 ?positions)) ;; L'ultima posizione rimanente

  ;; Ottiene i colori della combinazione precedente
  (bind ?colors (create$ ?c1 ?c2 ?c3 ?c4))

  ;; Crea una nuova combinazione con i colori scambiati in modo casuale
  (bind ?new-colors (create$
     (nth$ ?newPos1 ?colors)
     (nth$ ?newPos2 ?colors)
     (nth$ ?newPos3 ?colors)
     (nth$ ?newPos4 ?colors)
  ))

  ;; Asserisce il nuovo tentativo
  (assert (guess (step (+ ?s 1)) (g ?new-colors)))

  ;; Stampa la nuova combinazione
  (printout t "-----GUESS " (+ ?s 1) "---- " (nth$ 1 ?new-colors) " " (nth$ 2 ?new-colors) " " (nth$ 3 ?new-colors) " " (nth$ 4 ?new-colors) crlf)
)

(defrule handle-feedback-0-right-placed-3-miss-placed
  ?feedback <- (answer (step ?s) (right-placed 0) (miss-placed 3))
  ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
=>
  (printout t "----ANSWER " ?s "----: 0 🔴 - 3 ⚪" crlf)
  (retract ?feedback)

  ;; Crea una lista delle posizioni originali
  (bind ?positions (create$ 1 2 3 4))

  ;; Crea una lista delle nuove posizioni in modo casuale
  (bind ?newPos1 (nth$ (random 1 (length$ ?positions)) ?positions))
  (bind ?positions (delete-member$ ?positions ?newPos1))
  (bind ?newPos2 (nth$ (random 1 (length$ ?positions)) ?positions))
  (bind ?positions (delete-member$ ?positions ?newPos2))
  (bind ?newPos3 (nth$ (random 1 (length$ ?positions)) ?positions))
  (bind ?positions (delete-member$ ?positions ?newPos3))
  (bind ?newPos4 (nth$ 1 ?positions)) ;; L'ultima posizione rimanente

  ;; Ottiene i colori della combinazione precedente
  (bind ?colors (create$ ?c1 ?c2 ?c3 ?c4))

  ;; Crea una nuova combinazione con i colori scambiati in modo casuale
  (bind ?new-colors (create$
     (nth$ ?newPos1 ?colors)
     (nth$ ?newPos2 ?colors)
     (nth$ ?newPos3 ?colors)
     (nth$ ?newPos4 ?colors)
  ))

  ;; Asserisce il nuovo tentativo
  (assert (guess (step (+ ?s 1)) (g ?new-colors)))

  ;; Stampa la nuova combinazione
  (printout t "-----GUESS " (+ ?s 1) "---- " (nth$ 1 ?new-colors) " " (nth$ 2 ?new-colors) " " (nth$ 3 ?new-colors) " " (nth$ 4 ?new-colors) crlf)
)

(defrule handle-feedback-0-right-placed-3-miss-placed
  ?feedback <- (answer (step ?s) (right-placed 0) (miss-placed 3))
  ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
=>
  (printout t "----ANSWER " ?s "----: 0 🔴 - 3 ⚪" crlf)
  (retract ?feedback)

  ;; Crea una lista delle posizioni originali
  (bind ?positions (create$ 1 2 3 4))

  ;; Crea una lista delle nuove posizioni in modo casuale
  (bind ?newPos1 (nth$ (random 1 (length$ ?positions)) ?positions))
  (bind ?positions (delete-member$ ?positions ?newPos1))
  (bind ?newPos2 (nth$ (random 1 (length$ ?positions)) ?positions))
  (bind ?positions (delete-member$ ?positions ?newPos2))
  (bind ?newPos3 (nth$ (random 1 (length$ ?positions)) ?positions))
  (bind ?positions (delete-member$ ?positions ?newPos3))
  (bind ?newPos4 (nth$ 1 ?positions)) ;; L'ultima posizione rimanente

  ;; Ottiene i colori della combinazione precedente
  (bind ?colors (create$ ?c1 ?c2 ?c3 ?c4))

  ;; Crea una nuova combinazione con i colori scambiati in modo casuale
  (bind ?new-colors (create$
     (nth$ ?newPos1 ?colors)
     (nth$ ?newPos2 ?colors)
     (nth$ ?newPos3 ?colors)
     (nth$ ?newPos4 ?colors)
  ))

  ;; Asserisce il nuovo tentativo
  (assert (guess (step (+ ?s 1)) (g ?new-colors)))

  ;; Stampa la nuova combinazione
  (printout t "-----GUESS " (+ ?s 1) "---- " (nth$ 1 ?new-colors) " " (nth$ 2 ?new-colors) " " (nth$ 3 ?new-colors) " " (nth$ 4 ?new-colors) crlf)
)


(defrule handle-feedback-0-right-placed-2-miss-placed
  ?feedback <- (answer (step ?s) (right-placed 0) (miss-placed 2))
  ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
=>
  (printout t "----ANSWER " ?s "----: 0 🔴 - 2 ⚪" crlf)
  (retract ?feedback)

  ;; Crea una lista delle posizioni originali
  (bind ?positions (create$ 1 2 3 4))

  ;; Crea una lista delle nuove posizioni in modo casuale
  (bind ?newPos1 (nth$ (random 1 (length$ ?positions)) ?positions))
  (bind ?positions (delete-member$ ?positions ?newPos1))
  (bind ?newPos2 (nth$ (random 1 (length$ ?positions)) ?positions))
  (bind ?positions (delete-member$ ?positions ?newPos2))
  (bind ?newPos3 (nth$ (random 1 (length$ ?positions)) ?positions))
  (bind ?positions (delete-member$ ?positions ?newPos3))
  (bind ?newPos4 (nth$ 1 ?positions)) ;; L'ultima posizione rimanente

  ;; Ottiene i colori della combinazione precedente
  (bind ?colors (create$ ?c1 ?c2 ?c3 ?c4))

  ;; Crea una nuova combinazione con i colori scambiati in modo casuale
  (bind ?new-colors (create$
     (nth$ ?newPos1 ?colors)
     (nth$ ?newPos2 ?colors)
     (nth$ ?newPos3 ?colors)
     (nth$ ?newPos4 ?colors)
  ))

  ;; Asserisce il nuovo tentativo
  (assert (guess (step (+ ?s 1)) (g ?new-colors)))

  ;; Stampa la nuova combinazione
  (printout t "-----GUESS " (+ ?s 1) "---- " (nth$ 1 ?new-colors) " " (nth$ 2 ?new-colors) " " (nth$ 3 ?new-colors) " " (nth$ 4 ?new-colors) crlf)
)


(defrule handle-feedback-0-right-placed-1-miss-placed
  ?feedback <- (answer (step ?s) (right-placed 0) (miss-placed 1))
  ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
=>
  (printout t "----ANSWER " ?s "----: 0 🔴 - 1 ⚪" crlf)
  (retract ?feedback)

  ;; Crea una lista delle posizioni originali
  (bind ?positions (create$ 1 2 3 4))

  (bind ?missPos (nth$ (random 1 (length$ ?positions)) ?positions))
  (bind ?positions (delete-member$ ?positions ?missPos))

  ;; Seleziona le posizioni rimanenti per i colori sbagliati
  (bind ?newPos2 (nth$ (random 1 (length$ ?positions)) ?positions))
  (bind ?positions (delete-member$ ?positions ?newPos2))
  (bind ?newPos3 (nth$ (random 1 (length$ ?positions)) ?positions))
  (bind ?positions (delete-member$ ?positions ?newPos3))
  (bind ?newPos4 (nth$ 1 ?positions)) ;; L'ultima posizione rimanente

  ;; Ottiene i colori della combinazione precedente
  (bind ?colors (create$ ?c1 ?c2 ?c3 ?c4))

  ;; Crea una nuova combinazione rimescolando i colori
  (bind ?new-colors (create$
     (nth$ ?missPos ?colors)
     (nth$ ?newPos2 ?colors)
     (nth$ ?newPos3 ?colors)
     (nth$ ?newPos4 ?colors)
  ))

  ;; Asserisce il nuovo tentativo
  (assert (guess (step (+ ?s 1)) (g ?new-colors)))

  ;; Stampa la nuova combinazione
  (printout t "-----GUESS " (+ ?s 1) "---- " (nth$ 1 ?new-colors) " " (nth$ 2 ?new-colors) " " (nth$ 3 ?new-colors) " " (nth$ 4 ?new-colors) crlf)
)

(defrule handle-feedback-1-right-placed-1-miss-placed
  ?feedback <- (answer (step ?s) (right-placed 1) (miss-placed 1))
  ?guess <- (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4))
=>
  (printout t "----ANSWER " ?s "----: 1 🔴 - 1 ⚪" crlf)
  (retract ?feedback)

  ;; Crea una lista delle posizioni originali
  (bind ?positions (create$ 1 2 3 4))

  ;; Seleziona la posizione del colore corretto
  (bind ?correctPos (nth$ (random 1 (length$ ?positions)) ?positions))
  (bind ?positions (delete-member$ ?positions ?correctPos))

  ;; Seleziona la nuova posizione per il colore in posizione sbagliata
  (bind ?missPos (nth$ (random 1 (length$ ?positions)) ?positions))
  (bind ?positions (delete-member$ ?positions ?missPos))

  ;; Seleziona le posizioni rimanenti
  (bind ?newPos3 (nth$ (random 1 (length$ ?positions)) ?positions))
  (bind ?positions (delete-member$ ?positions ?newPos3))
  (bind ?newPos4 (nth$ 1 ?positions)) ;; L'ultima posizione rimanente

  ;; Ottiene i colori della combinazione precedente
  (bind ?colors (create$ ?c1 ?c2 ?c3 ?c4))

  ;; Crea una nuova combinazione mantenendo il colore giusto e rimescolando gli altri
  (bind ?new-colors (create$
     (nth$ ?correctPos ?colors)
     (nth$ ?missPos ?colors)
     (nth$ ?newPos3 ?colors)
     (nth$ ?newPos4 ?colors)
  ))

  ;; Asserisce il nuovo tentativo
  (assert (guess (step (+ ?s 1)) (g ?new-colors)))

  ;; Stampa la nuova combinazione
  (printout t "-----GUESS " (+ ?s 1) "---- " (nth$ 1 ?new-colors) " " (nth$ 2 ?new-colors) " " (nth$ 3 ?new-colors) " " (nth$ 4 ?new-colors) crlf)
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

























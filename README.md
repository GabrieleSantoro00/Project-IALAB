# Project-IALAB

## Exercise 1:
<details>
<summary></summary>
</details>

---

## Exercise 2:
<details>
<summary></summary>
</details>

---

## Exercise 3:
<details>
<summary></summary>
L’obiettivo del progetto è quello di sviluppare un sistema esperto che giochi al famoso gioco Mastermind. Il gioco consiste nello scoprire un codice segreto, composto da quattro cifre, con al più 10 tentativi. Nel nostro caso, occorre implementare una variante del gioco definita in questo modo:
  - il codice segreto è composto da quattro colori tutti diversi tra loro
  - i colori ammessi per comporre il codice segreto sono 8 e sono:
  blue, green, red, yellow, orange, white, black, purple
  - il giocatore ha al più 10 tentativi, se non indovina il codice in questi dieci passi, ha perso
  - ad ogni tentativo il giocatore riceve una risposta dal sistema che indica quanti colori sono stati indovinati nella corretta posizione e quanti sono stati indovinati ma in una posizione errata
  - il tentativo non può contenere colori ripetuti, se ciò accade il giocatore non riceve alcuna risposta, ma la mossa viene comunque contata

**Cosa dovete fare:**
==Dovete sviluppare almeno due varianti di giocatore==. Lo scopo è quello di dimostrare “l’intelligenza” dei giocatori in base alle regole che posseggono. Avete la libertà di modellare la conoscenza del giocatore, in termini fatti e regole, come meglio ritenete opportuno. Potete ricorrere a risorse in rete per documentarvi sul gioco, ed eventualmente implementare strategie note (in tal caso citate le fonti nella relazione). Anche se esistono algoritmi in grado di risolvere (quasi) sempre il gioco, dovete implementate almeno una variante che sfrutti strategie simili a quelle di un giocatore umano e che quindi possa perdere.

**NB**. Il fatto che il vostro giocatore non risolva il test non viene ritenuto un difetto del progetto. Il progetto sarà valutato sulla base delle regole che definite. Ad esempio, generare tutte le possibili combinazioni e poi tagliare quelle improbabili garantisce una certa percentuale di successo ma non è una strategia da “giocatore esperto” e come soluzione è valutata meno favorevolmente di una soluzione basata su regole di expertise che perde con maggior frequenza. Nella presentazione indicate le vostre scelte essenziali: quali fatti modellate, quale strategia implementate (dare l’intuizione, non i dettagli delle regole). Mettete a confronto le due strategie anche in diversi problemi e valutatene i risultati: la strategia che ritenete più intelligente è veramente la migliore? In quali casi si comporta meglio? Quali sono i limiti delle soluzioni proposte? NB. Consegnate il codice usando l’apposito contenitore che sarà messo a disposizione su moodle.

**Materiale a disposizione:**
Le regole del gioco (in particolare la produzione delle risposte) sono già state implementate e scaricabili dalla pagina moodle del corso.
*Non siete autorizzati a modificare l’ambiente, a meno che non vi siano bachi, vi chiedo però di avvisarmi nel caso.*
</details>

---
# Project-IALAB

## Exercise 1: PROLOG
<details>
<summary></summary>
Si richiede di implementare in Prolog due strategie di ricerca nello spazio degli stati a scelta e di confrontarne le prestazioni su due domini distinti:

- labirinto con almeno due uscite (non necessariamente raggiungibili)

- ricerca del portale del mostriciattolo: questo secondo dominio prevede un labirinto, di dimensione fissa 8 x 8, con muri invalicabili (come il labirinto “standard”) e muri di ghiaccio che si possono abbattere con un martello. Un mostriciattolo deve raggiungere la cella contenente il portale. In una delle celle è presente un martello per rompere i muri di ghiaccio. Ci sono anche tre gemme che, se presenti in celle contigue a due a due al momento del raggiungimento del portale, danno diritto ad un bonus. Sono possibili i movimenti nelle 4 direzioni (nord, sud, ovest, est), che corrispondono al “rovesciamento” della scacchiera: ad ogni azione, TUTTI gli oggetti, ad eccezione del solo martello, si spostano sul bordo della scacchiera, rispettando l’ordine della posizione iniziale nel caso più oggetti si trovino inizialmente sulla stessa riga/colonna (link a slides esplicative). 
  - FACOLTATIVO: sul labirinto è presente il mostriciattolo rivale, che si muove come tutti gli altri oggetti e sconfigge il mostriciattolo nel caso lo raggiunga.

Si richiede di valutare brevemente le prestazioni degli algoritmi implementati,
confrontandoli sui medesimi casi di test. 

</details>

---

## Exercise 2: ASP
<details>
<summary></summary>
Si richiede l’utilizzo del paradigma ASP (Answer Set Programming) per la
risoluzione automatica di uno dei due seguenti problemi, a scelta:

Generazione del calendario di una competizione sportiva con le seguenti caratteristiche:
- sono iscritte 16 squadre;
- il campionato prevede 30 giornate, 15 di andata e 15 di ritorno NON
simmetriche, ossia la giornata 1 di ritorno non coincide necessariamente con la
giornata 1 di andata a campi invertiti;
- ogni squadra fa riferimento ad una città, che offre la struttura in cui la squadra
gioca gli incontri in casa;
- ogni squadra affronta due volte tutte le altre squadre, una volta in casa e una
volta fuori casa, ossia una volta nella propria città di riferimento e una volta in
quella dell’altra squadra: la prima volta nel girone di andata (dalla giornata 1 alla
giornata15) e la seconda nel girone di ritorno (16-24);
- Alcune delle squadre fanno riferimento alla medesima città e condividono la
stessa struttura di gioco, quindi non possono giocare entrambe in casa nella
stessa giornata. Ovviamente, fanno eccezione le due giornate in cui giocano
l’una contro l’altra (derby);
- ciascuna squadra non deve giocare mai più di due partite consecutive in casa o
fuori casa.
</details>

---

## Exercise 3: CLIPS
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
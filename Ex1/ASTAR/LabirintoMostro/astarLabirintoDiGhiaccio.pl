:- ['azioni.pl'], ['stampaLabirinto.pl'], ['../../labirinti/labirintoDiGhiaccio4.pl'].
:- set_prolog_flag(answer_write_options, [max_depth(0)]).

/**
 * astar/0, fa da wrapper per l'inizio dell'esecuzione.
 */

astar() :-
  statistics(cputime, Start),
  iniziale(StatoIniziale),
  finale(StatoFinale),
  euristica(StatoIniziale, StatoFinale, H),
  G is 0,
  F is H + G,
  astar_aux([(F, H, StatoIniziale, [])], [], StatoFinale, CamminoRovesciato, (Mostro, Gemme, BlocchiDiGhiaccio, Martello, HaMartello)),
  statistics(cputime, Stop),
  inverti(CamminoRovesciato, Cammino),
  write("Stato iniziale: "), writeln(StatoIniziale),
  write("Nodo finale: "), writeln(StatoFinale), 
  writeln(""),
  write("Posizione mostro finale: "), writeln(Mostro), 
  write("Posizione gemme finali: "), writeln(Gemme),
  write("Il mostro ha il martello: "),  writeln(HaMartello),  
  write("Percorso: "), writeln(Cammino),
  writeln(""),
  write("Tempo di esecuzione: "), T is Stop - Start, writeln(T),
  writeln(""),
  esegui().


/**
 * Predicato euristica/3, calcola la distanza tra un nodo e
 * i nodi finali e restituisce il valore minimo.
 */

euristica((pos(R1, C1), _, _, _, _), pos(R2, C2), Valore) :-
  DistanzaR is abs(R1 - R2),
  DistanzaC is abs(C1 - C2),
  Valore is DistanzaR + DistanzaC.

/**
 * astar_aux(+Coda, +Visitati, +StatoFinale, -CamminoFinale)
 *
 * Predicato che implementa l'algoritmo di ricerca A* (A-star).
 *
 * Parametri:
 * - Coda: Lista di nodi da esplorare, ciascuno rappresentato come una tupla (F, H, Stato, Cammino).
 * - Visitati: Lista di nodi già visitati.
 * - StatoFinale: Stato obiettivo.
 * - CamminoFinale: Cammino trovato dal nodo iniziale al nodo finale.
 *
 * Il predicato funziona come segue:
 * 1. Se il nodo corrente è lo stato finale (arrivoAlPortale/1), restituisce il cammino.
 * 2. Altrimenti, genera i nuovi stati applicabili al nodo corrente.
 * 3. Filtra i nuovi stati per rimuovere quelli già visitati.
 * 4. Calcola i valori F per i nuovi stati.
 * 5. Inserisce i nuovi stati nella coda in modo ordinato.
 * 6. Aggiorna la lista dei nodi visitati.
 * 7. Chiama ricorsivamente astar_aux/4 con la nuova coda e la lista aggiornata dei nodi visitati.
 */


astar_aux([( _, _, Stato, Cammino)| _], _, StatoFinale, Cammino, StatoFinaleRitornato) :-
  arrivoAlPortale(Stato),!,
  StatoFinaleRitornato = Stato.

astar_aux([(F, H, Stato, Cammino)| Coda], Visitati, StatoFinale, CamminoFinale, StatoFinaleRitornato) :-
  generaNuoviStati((Stato, Cammino), ListaNuoviStati),
  differenza(ListaNuoviStati, Visitati, ListaNuoviStatiDaVisitare),
  calcolaFNuoviStati(ListaNuoviStatiDaVisitare, StatoFinale, ListaNuoviStatiConF),
  inserisci_lista_ordinata(ListaNuoviStatiConF, Coda, NuovaCoda),
  append(ListaNuoviStatiDaVisitare, Visitati, NuoviVisitati), 
  astar_aux(NuovaCoda, [(Stato, Cammino) | NuoviVisitati], StatoFinale, CamminoFinale, StatoFinaleRitornato).

/**
 * Predicato generaNuoviStati/2, genera i nuovi stati a partire dallo stato attuale.
 */

generaNuoviStati((Stato, Cammino), ListaNuoviStati) :-
  muovi_tutte_le_direzioni((Stato, Cammino), ListaNuoviStati).

/**
 * Predicato differenza/3, calcola la differenza tra due liste.
 */

differenza([], _, []).
differenza([(Stato, Cammino) | Tail], Visitati, Risultato) :-
    member((Stato, _), Visitati), !,
    differenza(Tail, Visitati, Risultato).
differenza([(Stato, Cammino) | Tail], Visitati, [(Stato, Cammino) | RisTail]) :-
    differenza(Tail, Visitati, RisTail).

/**
 * Predicato calcolaFNuoviStati/3, calcola il valore di F per ogni nuovo stato.
 */

calcolaFNuoviStati([], _, []).
calcolaFNuoviStati([(Stato, Cammino) | Coda], StatoFinale, [(F, H, Stato, Cammino) | ListaNuoviStatiConF]) :-
  euristica(Stato, StatoFinale, H),
  length(Cammino, G),
  F is G + H,
  calcolaFNuoviStati(Coda, StatoFinale, ListaNuoviStatiConF).

/**
 * Predicato inserisci_ordinato/3, inserisce un elemento in una lista ordinata.
 */

inserisci_ordinato(E, [], [E]).
inserisci_ordinato((F, H, Stato, Cammino), [(F1, H1, Stato1, Cammino1) | Coda], [(F, H, Stato, Cammino), (F1, H1, Stato1, Cammino1) | Coda]) :-
  F =< F1.
inserisci_ordinato((F, H, Stato, Cammino), [(F1, H1, Stato1, Cammino1) | Coda], [(F1, H1, Stato1, Cammino1) | ListaOrdinata]) :-
  F > F1,
  inserisci_ordinato((F, H, Stato, Cammino), Coda, ListaOrdinata).

/**
 * Predicato inserisci_lista_ordinata/3, inserisce una lista di elementi in una lista ordinata.
 */

inserisci_lista_ordinata([], Lista, Lista).
inserisci_lista_ordinata([E | Es], Lista, ListaOrdinata) :-
  inserisci_ordinato(E, Lista, ListaTemp),
  inserisci_lista_ordinata(Es, ListaTemp, ListaOrdinata).

/**
 * Predicato inverti/2, inverte una lista.
 */

inverti(Lista, ListaInvertita) :-
  inverti(Lista, [], ListaInvertita).
inverti([], Accumulatore, Accumulatore).
inverti([Testa|Coda], Accumulatore, ListaInvertita) :-
  inverti(Coda, [Testa|Accumulatore], ListaInvertita).
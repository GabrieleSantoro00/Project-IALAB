:- ['azioni.pl'], ['stampaLabirinto.pl'], ['../../labirinti/labirinto1280x1280.pl'].
:- set_prolog_flag(answer_write_options, [max_depth(0)]).

/**
 * Predicato astar/0, fa da wrapper per l'inizio dell'esecuzione.
 */

astar() :-
    statistics(cputime, Start),
    iniziale(NodoIniziale),
    findall(NodoFinale, finale(NodoFinale), ListaNodiFinali),
    euristica(NodoIniziale, ListaNodiFinali, H),
    G is 0,
    F is H + G,
    astar_aux([(F, H, NodoIniziale, [])], [], ListaNodiFinali, CamminoRovesciato, NodoFinale),
    statistics(cputime, Stop),
    inverti(CamminoRovesciato, Cammino),
    write("Nodo iniziale: "), writeln(NodoIniziale),
    write("Nodo finale: "), writeln(NodoFinale),
    write("Percorso: "), writeln(Cammino),
    write("Tempo di esecuzione: "), T is Stop - Start, writeln(T),
    write("").
    %esegui().

/**
 * Predicato euristica/3, calcola la distanza tra un nodo e
 * i nodi finali e restituisce il valore minimo.
 */

euristica(Nodo, ListaNodiFinali, Valore) :-
    findall(H, (member(NodoFinale, ListaNodiFinali), distanza(Nodo, NodoFinale, H)), Distanze),
    min_list(Distanze, Valore).


/**
 * Predicato distanza/3, calcola la distanza tra due nodi.
 */

distanza(pos(R1, C1), pos(R2, C2), Valore) :-
    DistanzaR is abs(R1 - R2),
    DistanzaC is abs(C1 - C2),
    Valore is DistanzaR + DistanzaC.

/**
 * Predicato costo/3, calcola il costo tra due nodi.
 */

costo(_,_,Costo) :- Costo is 1.

/**
 * astar_aux(+Coda, +Visitati, +ListaNodiFinali, -CamminoFinale, -NodoFinale)
 *
 * Predicato che implementa l'algoritmo di ricerca A* (A-star).
 *
 * Parametri:
 * - Coda: Lista di nodi da esplorare, ciascuno rappresentato come una tupla (F, H, Nodo, Cammino).
 * - Visitati: Lista di nodi già visitati.
 * - ListaNodiFinali: Lista dei nodi obiettivo.
 * - CamminoFinale: Cammino trovato dal nodo iniziale al nodo finale.
 * - NodoFinale: Nodo finale raggiunto.
 *
 * Il predicato funziona come segue:
 * 1. Se il nodo corrente è un nodo finale, restituisce il cammino e il nodo finale.
 * 2. Altrimenti, genera i nuovi stati applicabili al nodo corrente.
 * 3. Filtra i nuovi stati per rimuovere quelli già visitati.
 * 4. Calcola i valori F per i nuovi stati.
 * 5. Inserisce i nuovi stati nella coda in modo ordinato.
 * 6. Aggiorna la lista dei nodi visitati.
 * 7. Chiama ricorsivamente astar_aux/5 con la nuova coda e la lista aggiornata dei nodi visitati.
 */

astar_aux([( _, _, Nodo, Cammino)| _], _, ListaNodiFinali, Cammino, NodoFinale) :-
  member(Nodo, ListaNodiFinali),!,
  NodoFinale = Nodo.

astar_aux([(F, H, Nodo, Cammino)|Coda], Visitati, ListaNodiFinali, CamminoFinale, NodoFinale) :-
    findall(Azione, applicabile(Azione, Nodo), ListaAzioni),
    generaNuoviStati([(Nodo, Cammino)], ListaAzioni, ListaNuoviStati),
    differenza(ListaNuoviStati, Visitati, ListaNuoviStatiDaVisitare),
    calcolaFNuoviStati(ListaNuoviStatiDaVisitare, ListaNodiFinali, ListaNuoviStatiConF),
    inserisci_lista_ordinata(ListaNuoviStatiConF, Coda, NuovaCoda),
    append(ListaNuoviStatiDaVisitare, Visitati, NuoviVisitati),
    astar_aux(NuovaCoda, [(Nodo, Cammino) | NuoviVisitati], ListaNodiFinali, CamminoFinale, NodoFinale).

/**
 * Predicato generaNuoviStati/3, genera i nuovi stati a partire da uno stato e una lista di azioni.
 */

generaNuoviStati(_, [], []).
generaNuoviStati([(Nodo, Cammino)], [Azione | AzioniTail], [(NodoGenerato, [Azione | Cammino]) | NuoviStatiTail]) :-
    trasforma(Azione, Nodo, NodoGenerato),
    generaNuoviStati([(Nodo, Cammino)], AzioniTail, NuoviStatiTail).


/**
 * Predicato differenza/3, calcola la differenza tra due liste di coppie (Nodo, Cammino).
 */

differenza([], _, []).
differenza([(Nodo, _) | Tail], Visitati, Risultato) :-
    member((Nodo, _), Visitati), !,
    differenza(Tail, Visitati, Risultato).
differenza([(Nodo, Cammino) | Tail], Visitati, [(Nodo, Cammino) | RisTail]) :-
    differenza(Tail, Visitati, RisTail).

/**
 * Predicato calcolaFNuoviStati/3, calcola il valore F per ogni stato generato.
 */  

calcolaFNuoviStati([], _, []).
calcolaFNuoviStati([(Nodo, Cammino) | Coda], ListaNodiFinali, [(F, H, Nodo, Cammino) | ListaNuoviStatiConF]) :-
    costo(_, _, IncrementoG),
    length(Cammino, LunghezzaCammino),
    G is LunghezzaCammino + IncrementoG,
    euristica(Nodo, ListaNodiFinali, H),
    F is G + H,
    calcolaFNuoviStati(Coda, ListaNodiFinali, ListaNuoviStatiConF).

/**
 * Predicato inserisci_ordinato/3, inserisce un elemento in una lista ordinata.
 */

inserisci_ordinato(E, [], [E]).
inserisci_ordinato((F, H, Nodo, Cammino), [(F1, H1, Nodo1, Cammino1) | Coda], [(F, H, Nodo, Cammino), (F1, H1, Nodo1, Cammino1) | Coda]) :-
    F =< F1.
inserisci_ordinato((F, H, Nodo, Cammino), [(F1, H1, Nodo1, Cammino1) | Coda], [(F1, H1, Nodo1, Cammino1) | ListaOrdinata]) :-
    F > F1,
    inserisci_ordinato((F, H, Nodo, Cammino), Coda, ListaOrdinata).

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

inverti(Lista, ListaInvertita) :- inverti(Lista, [], ListaInvertita).
inverti([], Accumulatore, Accumulatore).
inverti([Testa|Coda], Accumulatore, ListaInvertita) :-
    inverti(Coda, [Testa|Accumulatore], ListaInvertita).

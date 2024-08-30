:- ['azioni.pl'], ['stampaLabirinto.pl'], ['../labirinti/labyrinth9.pl'].
:- set_prolog_flag(answer_write_options, [max_depth(0)]).

/**
 * Predicato rbfs/0, fa da wrapper per l'inizio dell'esecuzione.
 */

rbfs():-
  statistics(cputime, Start),
  iniziale(NodoIniziale),
  findall(NodoFinale, finale(NodoFinale), ListaNodiFinali),
  euristica(NodoIniziale, ListaNodiFinali, H),
  G is 0,
  F is G + H,
  rbfs_aux(([NodoIniziale,[]], F), 9999, ListaNodiFinali, [ResNode, ResF, ResPath]),
  statistics(cputime, Stop),
  write("Nodo iniziale: "), writeln(NodoIniziale),
  write("Nodo finale: "), writeln(ResNode),
  write("Percorso: "), writeln(ResPath),
  write("Tempo di esecuzione: "), T is Stop - Start, writeln(T),
  write(""),
  esegui().


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
 * rbfs_aux(+NodoCorrente, +FLimit, +ListaNodiFinali, -Risultato)
 *
 * Predicato che implementa l'algoritmo di ricerca RBFS (Recursive Best-First Search).
 *
 * Parametri:
 * - NodoCorrente: Coppia ([Nodo, Cammino], F) che rappresenta il nodo corrente, il cammino percorso e il costo F.
 * - FLimit: Limite superiore del costo F per la ricerca.
 * - ListaNodiFinali: Lista dei nodi obiettivo.
 * - Risultato: Lista contenente il nodo risultato (ResNode), il costo F associato (ResF) e il cammino (ResPath).
 *
 * Il predicato funziona come segue:
 * 1. Se il nodo corrente è un nodo finale, restituisce il nodo e il cammino.
 * 2. Altrimenti, genera i nuovi stati applicabili al nodo corrente.
 * 3. Se non ci sono successori, la ricerca fallisce.
 * 4. Altrimenti, chiama rbfs_while/4 per continuare la ricerca con i nuovi stati.
 */

rbfs_aux(([Node,Path], _), _, ListaNodiFinali, [ResNode, _, ResPath]):- 
  member(Node, ListaNodiFinali), !,
  ResNode = Node,
  ResPath = Path.

rbfs_aux(([Node,Path], F), FLimit, ListaNodiFinali, [ResNode, ResF, ResPath]):-
  findall(Azione, applicabile(Azione, Node), ListaAzioni),
  generaNuoviStati(([Node,Path], F), ListaAzioni, ListaNodiFinali, ListaNuoviNodi),
  (
      ListaNuoviNodi == [], !,
      ResNode = -1,
      ResF = 9999,
      writeln("RBFS: FAIL, NO SUCCESSORS FOUND")
      ;
      rbfs_while(ListaNuoviNodi, FLimit, ListaNodiFinali, [ResNode, ResF, ResPath])
  ).

/**
 * rbfs_while(+ListaNuoviNodi, +FLimit, +ListaNodiFinali, -Risultato)
 *
 * Predicato che implementa l'algoritmo di ricerca RBFS (Recursive Best-First Search) in un ciclo while.
 * 
 * Parametri:
 * - ListaNuoviNodi: Lista dei nuovi nodi da esplorare, ciascuno rappresentato come una coppia ([Nodo, Cammino], F).
 * - FLimit: Limite superiore del costo F per la ricerca.
 * - ListaNodiFinali: Lista dei nodi finali (obiettivi) della ricerca.
 * - Risultato: Lista contenente il nodo risultato (ResNode), il costo F associato (ResF) e il cammino (ResPath).
 *
 * Il predicato funziona come segue:
 * 1. Estrae il nodo con il costo F più basso dalla lista dei nuovi nodi.
 * 2. Se il costo F del nodo estratto è maggiore del limite FLimit, la ricerca fallisce e il nodo risultato è impostato a -1.
 * 3. Altrimenti, calcola un nuovo limite FLimit basato sul secondo miglior costo F nella lista dei nuovi nodi.
 * 4. Chiama ricorsivamente rbfs_aux/4 con il nodo estratto e il nuovo limite FLimit.
 * 5. Se la chiamata ricorsiva fallisce (TempResNode == -1), aggiunge il nodo estratto con il nuovo costo F alla lista dei successori e ripete il ciclo.
 * 6. Se la chiamata ricorsiva ha successo, imposta il nodo risultato e il costo F associato.
 */

rbfs_while(ListaNuoviNodi, FLimit, ListaNodiFinali, [ResNode, ResF, ResPath]):-
  estraiFPrimoNodo(ListaNuoviNodi, BestNode, BestPath, BestF, TailNuoviNodi),
  (
      BestF > FLimit, !,
      ResNode = -1,
      ResF = BestF 
      ;
      estraiFSecondoNodo(ListaNuoviNodi, FLimit, FAlternativo),
      NewFLimit is min(FAlternativo, FLimit),
      rbfs_aux(([BestNode, BestPath],BestF), NewFLimit, ListaNodiFinali, [TempResNode, TempResF, ResPath]),
      (
          TempResNode == -1, !,
          append(TailNuoviNodi, [([BestNode, BestPath], TempResF)], NewSuccessors),
          rbfs_while(NewSuccessors, FLimit, ListaNodiFinali, [ResNode, ResF, ResPath])
          ;
          TempResNode \== -1, !,
          ResNode = TempResNode, 
          ResF = BestF
      )
  ).

/**
 * Estrazione del nodo con il costo F più basso dalla lista dei nuovi nodi.
 */

estraiFPrimoNodo([([Node, Cammino],F)|Coda], Node, Cammino, F, Coda).

/**
 * Estrazione del secondo nodo con il costo F più basso dalla lista dei nuovi nodi.
 */

estraiFSecondoNodo([], FLimit, FLimit):- !.
estraiFSecondoNodo([([_, _],_)], FLimit, FLimit):- !.
estraiFSecondoNodo([_, ([_, _],F)|_], _, F).

/**
 * Inserimento ordinato di un nodo nella lista dei nuovi nodi.
 */

inserisci_ordinato(E, [], [E]).
inserisci_ordinato(([Node, Cammino], F), [([Nodo1, Cammino1], F1) | Coda], [([Node, Cammino], F), ([Nodo1, Cammino1], F1) | Coda]) :-
    F =< F1.
inserisci_ordinato(([Node, Cammino], F), [([Nodo1, Cammino1], F1) | Coda], [([Nodo1, Cammino1], F1) | ListaOrdinata]) :-
    F > F1,
    inserisci_ordinato(([Node, Cammino], F), Coda, ListaOrdinata).

/**
 * Generazione dei nuovi stati applicabili al nodo corrente.
 */

generaNuoviStati(_, [], _, []).
generaNuoviStati(([Node, Cammino], F), [Azione | AzioniTail], ListaNodiFinali, ListaNuoviNodiOrdinata) :-
    trasforma(Azione, Node, NuovoNodo),
    append(Cammino, [Azione], NuovoCammino),
    costo(Node, NuovoNodo, Costo),
    length(NuovoCammino, GValue),
    NuovoGValue is GValue + Costo,
    euristica(NuovoNodo, ListaNodiFinali, H),
    NuovoF is NuovoGValue + H,
    generaNuoviStati(([Node, Cammino], F), AzioniTail, ListaNodiFinali, NuoviStatiTail),
    inserisci_ordinato(([NuovoNodo, NuovoCammino], NuovoF), NuoviStatiTail, ListaNuoviNodiOrdinata).








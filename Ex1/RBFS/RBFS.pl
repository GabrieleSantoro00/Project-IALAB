:- ['azioni.pl'], ['labirinto.pl'], ['stampaLabirinto.pl'].
:- set_prolog_flag(answer_write_options, [max_depth(0)]).


rbfs():-
  statistics(cputime, Start),
  iniziale(NodoIniziale),
  finale(NodoFinale),
  euristica(NodoIniziale, NodoFinale, H),
  G is 0,
  F is G + H,
  rbfs_aux(([NodoIniziale,[]], F), 9999, NodoFinale, [ResNode, ResF, ResPath]),
  statistics(cputime, Stop),
  write("Nodo iniziale: "), writeln(NodoIniziale),
  write("Nodo finale: "), writeln(NodoFinale),
  write("Percorso: "), writeln(ResPath),
  write("Tempo di esecuzione: "), T is Stop - Start, writeln(T),
  write("").
  esegui().


euristica(pos(R1,C1), pos(R2,C2), Valore):-
  DistanzaR is abs(R1 - R2),
  DistanzaC is abs(C1 - C2),
  Valore is DistanzaR + DistanzaC.


costo(_,_,Costo) :- Costo is 1.


rbfs_aux(([Node,Path], _), FLimit, _, [ResNode, _, ResPath]):- 
  finale(Node),!,
  ResNode = Node,
  ResPath = Path.

rbfs_aux(([Node,Path], F), FLimit, NodoFinale, [ResNode, ResF, ResPath]):-
  findall(Azione, applicabile(Azione, Node), ListaAzioni),
  generaNuoviStati(([Node,Path], F), ListaAzioni, NodoFinale, ListaNuoviNodi),
  (
      ListaNuoviNodi == [], !,
      ResNode = -1,
      ResF = 9999,
      writeln("RBFS: FAIL, NO SUCCESSORS FOUND")
      ;
      rbfs_while(ListaNuoviNodi, FLimit, NodoFinale, [ResNode, ResF, ResPath])
  ).


rbfs_while(ListaNuoviNodi, FLimit, NodoFinale, [ResNode, ResF, ResPath]):-
  estraiFPrimoNodo(ListaNuoviNodi, BestNode, BestPath, BestF, TailNuoviNodi),
  (
      BestF > FLimit, !,
      ResNode = -1,
      ResF = BestF 
      ;
      estraiFSecondoNodo(ListaNuoviNodi, FLimit, FAlternativo),
      NewFLimit is min(FAlternativo, FLimit),
      rbfs_aux(([BestNode, BestPath],BestF), NewFLimit, NodoFinale, [TempResNode, TempResF, ResPath]),
      (
          TempResNode == -1, !,
          append(TailNuoviNodi, [([BestNode, BestPath], TempResF)], NewSuccessors),
          rbfs_while(NewSuccessors, FLimit, NodoFinale, [ResNode, ResF, ResPath])
          ;
          TempResNode \== -1, !,
          ResNode = TempResNode, 
          ResF = BestF
      )
  ).


estraiFPrimoNodo([([Node, Cammino],F)|Coda], Node, Cammino, F, Coda).

estraiFSecondoNodo([], FLimit, FLimit):- !.
estraiFSecondoNodo([([_, _],_)], FLimit, FLimit):- !.
estraiFSecondoNodo([_, ([_, _],F)|_], _, F).


% Inserimento ordinato nella lista
inserisci_ordinato(E, [], [E]).
inserisci_ordinato(([Node, Cammino], F), [([Nodo1, Cammino1], F1) | Coda], [([Node, Cammino], F), ([Nodo1, Cammino1], F1) | Coda]) :-
    F =< F1.
inserisci_ordinato(([Node, Cammino], F), [([Nodo1, Cammino1], F1) | Coda], [([Nodo1, Cammino1], F1) | ListaOrdinata]) :-
    F > F1,
    inserisci_ordinato(([Node, Cammino], F), Coda, ListaOrdinata).

% Generazione dei nuovi stati
generaNuoviStati(_, [], _, []).
generaNuoviStati(([Node, Cammino], F), [Azione | AzioniTail], NodoFinale, ListaNuoviNodiOrdinata) :-
    trasforma(Azione, Node, NuovoNodo),
    append(Cammino, [Azione], NuovoCammino),
    costo(Node, NuovoNodo, Costo),
    length(NuovoCammino, GValue),
    NuovoGValue is GValue + Costo,
    euristica(NuovoNodo, NodoFinale, H),
    NuovoF is NuovoGValue + H,
    generaNuoviStati(([Node, Cammino], F), AzioniTail, NodoFinale, NuoviStatiTail),
    inserisci_ordinato(([NuovoNodo, NuovoCammino], NuovoF), NuoviStatiTail, ListaNuoviNodiOrdinata).

% Esempio di utilizzo
% trasforma/3, costo/3, euristica/3 devono essere definiti altrove nel codice

% Esempio di utilizzo
% trasforma/3, costo/3, euristica/3 devono essere definiti altrove nel codice









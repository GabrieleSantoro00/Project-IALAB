:- ['azioni.pl'], ['labirinto.pl'], ['stampaLabirinto.pl'].
:- set_prolog_flag(answer_write_options, [max_depth(0)]).


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


euristica(Nodo, ListaNodiFinali, Valore) :-
    findall(H, (member(NodoFinale, ListaNodiFinali), distanza(Nodo, NodoFinale, H)), Distanze),
    min_list(Distanze, Valore).


distanza(pos(R1, C1), pos(R2, C2), Valore) :-
    DistanzaR is abs(R1 - R2),
    DistanzaC is abs(C1 - C2),
    Valore is DistanzaR + DistanzaC.

costo(_,_,Costo) :- Costo is 1.


rbfs_aux(([Node,Path], _), FLimit, ListaNodiFinali, [ResNode, _, ResPath]):- 
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








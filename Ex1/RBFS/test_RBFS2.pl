:- ['azioni'], ['labirinto.pl'], ['stampaLabirinto'].
:- set_prolog_flag(answer_write_options, [max_depth(0)]).

rbfs(Cammino):-
  iniziale(NodoIniziale),
  finale(NodoFinale),
  euristica(NodoIniziale, NodoFinale, H),
  G is 0,
  F is G + H,
  FLimit is inf,
  CamminoFinale = [NodoIniziale| _ ],
  rbfs_aux((NodoIniziale, FLimit, F, [NodoIniziale|CamminoAttuale], _, _), NodoFinale, CamminoFinale, CamminoFinaleRitornato),
  stampa_lista(CamminoFinaleRitornato),
  %inverti(CamminoFinaleRitornato, Cammino),
  esegui().


euristica(pos(R1,C1), pos(R2,C2), Valore):-
  DistanzaR is abs(R1 - R2),
  DistanzaC is abs(C1 - C2),
  Valore is DistanzaR + DistanzaC.


costo(_,_,Costo) :- Costo is 1.


rbfs_aux((Nodo,_,_,_,_,_), Nodo, CamminoFinale, CamminoFinale):- finale(Nodo),!.
rbfs_aux((Nodo, FLimit, FValue, CamminoAttuale, SecondoNodoAlternativo, CamminoAlternativo), NodoFinale, CamminoFinale, CamminoFinaleRitornato):-
  findall(Azione, applicabile(Azione, Nodo), ListaAzioni),
  %generaNuoviStati(), % TODO
  calcolaFValue(Nodo, NodoFinale, CamminoAttuale, ListaAzioni, ListaNuoviNodi, ListaNuoviNodiRitornato),
  estraiValoriPrimoNodo(ListaNuoviNodiRitornato, FValueMin, PrimoNodoMigliore, CamminoNodoMinore),
  estraiValoriSecondoNodo(ListaNuoviNodiRitornato, FValueMinAlternativo, SecondoNodoMigliore, CamminoSecondoNodo),  
  FValueMin =< FLimit,!,
  rbfs_aux((PrimoNodoMigliore, FValueMinAlternativo, FValueMin, CamminoNodoMinore, SecondoNodoMigliore, CamminoSecondoNodo), NodoFinale, [PrimoNodoMigliore|CamminoFinale], CamminoFinaleRitornato).
rbfs_aux((Nodo, FLimit, FValue, CamminoAttuale, SecondoNodoMigliore, CamminoSecondoNodo), NodoFinale, CamminoFinale, CamminoFinaleRitornato):-
  findall(Azione, applicabile(Azione,Nodo), ListaAzioni),
  calcolaFValue(Nodo, NodoFinale, CamminoAttuale, ListaAzioni, ListaNuoviNodi, ListaNuoviNodiRitornato),
  estraiValoriPrimoNodo(ListaNuoviNodiRitornato, FValueMin, PrimoNodoMigliore, CamminoNodoMinore),
  FValueMin > FLimit,!,
  rbfs_aux((SecondoNodoMigliore, FValueMin, FLimit, CamminoSecondoNodo, PrimoNodoMigliore, CamminoNodoMinore), NodoFinale, [SecondoNodoMigliore|CamminoFinale], CamminoFinaleRitornato).


% Funzione per impostare H per ogni azione applicabile e inserire i nuovi nodi in lista ordinata.
calcolaFValue(_, _, _, [], ListaNuoviNodi, ListaNuoviNodi). % Caso base: nessuna azione da applicare.
calcolaFValue(Nodo, NodoFinale, CamminoAttuale, [Azione|ListaAzioniTail], ListaNuoviNodi, RisultatoListaNuoviNodi):-
    trasforma(Azione, Nodo, NuovoNodo),
    costo(Nodo, NuovoNodo, Costo),
    length(CamminoAttuale, GValue),
    NuovoGValue is GValue + Costo,
    euristica(NuovoNodo, NodoFinale, H),
    FValue is NuovoGValue + H,
    inserisci_ordinato((NuovoNodo, FLimit, FValue, [NuovoNodo|CamminoAttuale]), ListaNuoviNodi, NuovaListaNuoviNodi),
    calcolaFValue(Nodo, NodoFinale, CamminoAttuale, ListaAzioniTail, NuovaListaNuoviNodi, RisultatoListaNuoviNodi).


% Funzione per inserire un nodo in una lista mantenendola ordinata in base a H.
inserisci_ordinato((NuovoNodo, FLimit, FValue, CamminoAttuale), [], [(NuovoNodo, FLimit, FValue, CamminoAttuale)]).  % Se la lista di input è vuota, l'output è una lista con il solo elemento.
inserisci_ordinato((NuovoNodo, FLimit, FValue, CamminoAttuale), [(VecchioNuovoNodo, FLimit_2, FValue_2, VecchioCamminoAttuale)|Tail], [(NuovoNodo, FLimit, FValue, CamminoAttuale), (VecchioNuovoNodo, FLimit_2, FValue_2, VecchioCamminoAttuale) | Tail]) :-
  FValue =< FValue_2.  % Se H è minore o uguale al primo elemento della lista, metti il nuovo nodo prima.
inserisci_ordinato((NuovoNodo, FLimit, FValue, CamminoAttuale), [(VecchioNuovoNodo, FLimit_2, FValue_2, VecchioCamminoAttuale)|Tail], [(VecchioNuovoNodo, FLimit_2, FValue_2, VecchioCamminoAttuale) | NuovaListaNuoviNodi]) :-
  FValue > FValue_2,  % Se H è maggiore del primo elemento della lista, inserisci nel resto della lista.
  inserisci_ordinato((NuovoNodo, FLimit, FValue, CamminoAttuale), Tail, NuovaListaNuoviNodi).


estraiValoriPrimoNodo([(PrimoNodo, _, FValue, CamminoNodo)|ListaNuoviNodi], FValue, PrimoNodo, CamminoNodo).

estraiValoriSecondoNodo([], inf, _, _):- !.
estraiValoriSecondoNodo([_], inf, _, _):- !.
estraiValoriSecondoNodo([_, (SecondoNodo, _, SValue, CamminoSecondoNodo)|_], SValue, SecondoNodo, CamminoSecondoNodo).


estraiFValueMinoreAlternativo([_], inf) :- !.
estraiFValueMinoreAlternativo([_, (_, _, FValueAlternativo, _)|ListaNuoviNodi], FValueAlternativo).


stampa_lista([]).
stampa_lista([H|T]) :-
  write(H), nl,
  stampa_lista(T).


inverti([], Accumulatore, Accumulatore).
inverti([Testa|Coda], Accumulatore, ListaInvertita) :-
    inverti(Coda, [Testa|Accumulatore], ListaInvertita).












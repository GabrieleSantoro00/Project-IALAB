
iniziale(pos(1,1)).
finale(pos(2,2)).

num_colonne(2).
num_righe(2).

occupata(pos(1,2)).

/*
TEST inserisci_ordinato --> ok
input 
inserisci_ordinato((a, 0, 8), [(e, 0, 6), (i, 0, 7)], ListaOrdinata). 
output
ListaOrdinata = [(e, 0, 6), (i, 0, 7), (a, 0, 8)].
*/

% Funzione per inserire un nodo in una lista mantenendola ordinata in base a HValue.
inserisci_ordinato((NuovoNodo, FLimit, FValue, CamminoAttuale), [], [(NuovoNodo, FLimit, FValue, CamminoAttuale)]).  % Se la lista di input è vuota, l'output è una lista con il solo elemento.
inserisci_ordinato((NuovoNodo, FLimit, FValue, CamminoAttuale), [(VecchioNuovoNodo, FLimit_2, FValue_2, VecchioCamminoAttuale)|Tail], [(NuovoNodo, FLimit, FValue, CamminoAttuale), (VecchioNuovoNodo, FLimit_2, FValue_2, VecchioCamminoAttuale) | Tail]) :-
  FValue =< FValue_2.  % Se HValue è minore o uguale al primo elemento della lista, metti il nuovo nodo prima.
inserisci_ordinato((NuovoNodo, FLimit, FValue, CamminoAttuale), [(VecchioNuovoNodo, FLimit_2, FValue_2, VecchioCamminoAttuale)|Tail], [(VecchioNuovoNodo, FLimit_2, FValue_2, VecchioCamminoAttuale) | NuovaListaNuoviNodi]) :-
  FValue > FValue_2,  % Se HValue è maggiore del primo elemento della lista, inserisci nel resto della lista.
  inserisci_ordinato((NuovoNodo, FLimit, FValue, CamminoAttuale), Tail, NuovaListaNuoviNodi).


/*
TEST euristica --> ok
input
euristica(pos(1, 1), pos(3, 7), HValue).
output
HValue = 8.
*/

euristica(pos(R1,C1), pos(R2,C2), HValue):-
  DistanzaR is abs(R1 - R2),
  DistanzaC is abs(C1 - C2),
  HValue is DistanzaR + DistanzaC.


/*
TEST impostaHValue --> ok
input
impostaHValue(pos(1, 1), pos(3, 7), [nord, sud, est, ovest], ListaNuoviNodi, ListaHValue).
output
ListaNuoviNodi = [(pos(0, 1), _, _A), (pos(2, 1), _, _B), (pos(1, 2), _, _C), (pos(1, 0), _, _D)],
ListaHValue = [_A, _B, _C, _D] .
*/

costo(_,_,Costo) :- Costo is 1.

% Funzione per impostare HValue per ogni azione applicabile e inserire i nuovi nodi in lista ordinata.
impostaFValue(_, _, _, [], ListaNuoviNodi, ListaNuoviNodi). % Caso base: nessuna azione da applicare.
impostaFValue(Nodo, NodoFinale, CamminoAttuale, [Az|ListaAzioniTail], NuovoFValueMin, ListaNuoviNodi, RisultatoListaNuoviNodi):- 
    trasforma(Az, Nodo, NuovoNodo),
    costo(Nodo, NuovoNodo, Costo),
    length(CamminoAttuale, GValue),
    NuovoGValue is GValue + Costo,
    euristica(NuovoNodo, NodoFinale, HValue),
    FValue is NuovoGValue + HValue,
    inserisci_ordinato((NuovoNodo, FLimit, FValue, [NuovoNodo|CamminoAttuale]), ListaNuoviNodi, NuovaListaNuoviNodi),
    impostaFValue(Nodo, NodoFinale, CamminoAttuale, ListaAzioniTail, NuovaListaNuoviNodi, RisultatoListaNuoviNodi).


/*
TEST estraiHValueMin --> ok
input
estraiHValueMin([(a, 0, 3), (b, 0, 5), (c, 0, 6)], HValueMin).
output
HValueMin = 3
*/

estraiValoriPrimoNodo([(PrimoNodo, _, FValue, CamminoNodo)|ListaNuoviNodi], FValue, PrimoNodo, CamminoNodo).


rbfs(Cammino):-
  iniziale(NodoIniziale),
  
  finale(NodoFinale),
  
  euristica(NodoIniziale, NodoFinale, HValue),
  
  FLimit = inf,

  FlagConfronto = 0,
  
  rbfs_aux((NodoIniziale, FLimit, HValue, [NodoIniziale|CamminoAttuale]), NodoFinale, CamminoFinale, Cammino, FValueRitornato, FlagConfronto),

  stampa_lista(Cammino).


stampa_lista([]).
stampa_lista([H|T]) :-
  write(H), nl,
  stampa_lista(T).


% Caso in cui siamo arrivati a destinazione
rbfs_aux((Nodo,_,_,_), Nodo, CamminoFinale, CamminoFinale, _, _):- finale(Nodo),!. %caso base

% Caso in cui non ci sono successori possibili
rbfs_aux((Nodo,_,_,_), _, _, _, _, _):-
  
  findall(Az,applicabile(Az,Nodo),ListaAzioni),
  
  ListaAzioni = [],

  !, fail. % The list of actions is empty

% Caso ricorsivo 
rbfs_aux((Nodo, FLimit, FValue, CamminoAttuale), NodoFinale, CamminoFinale, CamminoFinaleRitornato, FValueRitornato, FlagConfronto):-

  findall(Az,applicabile(Az,Nodo),ListaAzioni),

  impostaFValue(Nodo, NodoFinale, CamminoAttuale, ListaAzioni, NuovoFValueMin, ListaNuoviNodi, ListaNuoviNodiRitornato),

  aggiornaFValueWrapper(ListaNuoviNodiRitornato, FValueRitornato, FlagConfronto, ListaNuoviNodiRitornatoAggiornata),

  estraiValoriPrimoNodo(ListaNuoviNodiRitornatoAggiornata, FValueMin, PrimoNodoMigliore, CamminoNodoMinore),
  
  fValueMinoreDiFLimit(FValueMin, FLimit, FValueRitornato, FlagConfronto),

  FValueMin =< FLimit,

  estraFValueMinoreAlternativo(ListaNuoviNodiRitornatoAggiornata, FValueMinAlternativo),

  NuovoCamminoFinale = [PrimoNodoMigliore|CamminoFinale],

  rbfs_aux((PrimoNodoMigliore, FValueMinAlternativo, FValueMin, CamminoNodoMinore), NodoFinale, NuovoCamminoFinale, CamminoFinaleRitornato, FValueRitornato, FlagConfronto).
  


estraFValueMinoreAlternativo([_], inf) :- !.

estraFValueMinoreAlternativo([_, (_, _, FValueAlternativo, _)|ListaNuoviNodi], FValueAlternativo).


fValueMinoreDiFLimit(FLimit, FValue, FValueRitornato, FlagConfronto,):-

  \+fLimitMinoreDiFValue(FValue, FLimit, FValueRitornato, FlagConfronto),

  FlagConfronto is 0.


fLimitMinoreDiFValue(FValue, FLimit, FValue, FlagConfronto):-

  FLimit =< FValue,

  FlagConfronto is 1.


aggiornaFValueWrapper([(Nodo, FLimit, _ , CamminoAttuale)|ListaNuoviNodiRitornato], FValueRitornato, FlagConfronto, ListaNuoviNodiRitornatoAggiornata):-
  \+aggiornaFValue([(Nodo, FLimit, _ , CamminoAttuale)|ListaNuoviNodiRitornato], FValueRitornato, FlagConfronto, ListaNuoviNodiRitornatoAggiornata),!.

aggiornaFValue([(Nodo, FLimit, _ , CamminoAttuale)|ListaNuoviNodiRitornato], FValueRitornato, FlagConfronto, ListaNuoviNodiRitornatoAggiornata):-
  FlagConfronto = 1,
  inserisci_ordinato((Nodo, FLimit, FValueRitornato, CamminoAttuale), ListaNuoviNodiRitornato, ListaNuoviNodiRitornatoAggiornata).
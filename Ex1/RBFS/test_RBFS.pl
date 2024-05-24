iniziale(pos(1,1)).
finale(pos(2,2)).

num_colonne(2).
num_righe(2).

/*
TEST inserisci_ordinato --> ok
input 
inserisci_ordinato((a, 0, 8), [(e, 0, 6), (i, 0, 7)], ListaOrdinata). 
output
ListaOrdinata = [(e, 0, 6), (i, 0, 7), (a, 0, 8)].
*/

% Funzione per inserire un nodo in una lista mantenendola ordinata in base a FValue.
inserisci_ordinato((NuovoNodo, FLimit, FValue), [], [(NuovoNodo, FLimit, FValue)]).  % Se la lista di input è vuota, l'output è una lista con il solo elemento.
inserisci_ordinato((NuovoNodo, FLimit, FValue), [(VecchioNuovoNodo, FLimit_2, FValue_2)|Tail], [(NuovoNodo, FLimit, FValue), (VecchioNuovoNodo, FLimit_2, FValue_2) | Tail]) :-
  FValue =< FValue_2.  % Se FValue è minore o uguale al primo elemento della lista, metti il nuovo nodo prima.
inserisci_ordinato((NuovoNodo, FLimit, FValue), [(VecchioNuovoNodo, FLimit_2, FValue_2)|Tail], [(VecchioNuovoNodo, FLimit_2, FValue_2) | NuovaListaNuoviNodi]) :-
  FValue > FValue_2,  % Se FValue è maggiore del primo elemento della lista, inserisci nel resto della lista.
  inserisci_ordinato((NuovoNodo, FLimit, FValue), Tail, NuovaListaNuoviNodi).


/*
TEST euristica --> ok
input
euristica(pos(1, 1), pos(3, 7), FValue).
output
FValue = 8.
*/

euristica(pos(R1,C1), pos(R2,C2), FValue):-
  DistanzaR is abs(R1 - R2),
  DistanzaC is abs(C1 - C2),
  FValue is DistanzaR + DistanzaC.


/*
TEST impostaFValue --> ok
input
impostaFValue(pos(1, 1), pos(3, 7), [nord, sud, est, ovest], ListaNuoviNodi, ListaFValue).
output
ListaNuoviNodi = [(pos(0, 1), _, _A), (pos(2, 1), _, _B), (pos(1, 2), _, _C), (pos(1, 0), _, _D)],
ListaFValue = [_A, _B, _C, _D] .
*/

% Funzione per impostare FValue per ogni azione applicabile e inserire i nuovi nodi in lista ordinata.
impostaFValue(_, _, [], ListaNuoviNodi, ListaNuoviNodi). % Caso base: nessuna azione da applicare.
impostaFValue(Nodo, NodoFinale, [Az|ListaAzioniTail], ListaNuoviNodi, RisultatoListaNuoviNodi):- 
    trasforma(Az, Nodo, NuovoNodo),
    euristica(NuovoNodo, NodoFinale, FValue),
    FLimit is 100, % Supponiamo un valore di default per FLimit, dovresti adattarlo al tuo contesto.
    inserisci_ordinato((NuovoNodo, FLimit, FValue), ListaNuoviNodi, NuovaListaNuoviNodi),
    impostaFValue(Nodo, NodoFinale, ListaAzioniTail, NuovaListaNuoviNodi, RisultatoListaNuoviNodi).


/*
TEST generaNuoviNodi --> ok
input
generaNuoviNodi(pos(1, 1), [sud, est], ListaNuoviNodi).
output
ListaNuoviNodi = [pos(2, 1), pos(1, 2)].
*/

generaNuoviNodi(_, [], ListaNuoviNodiTail).
generaNuoviNodi(Nodo, [Az|ListaAzioniTail], ListaNuoviNodiTail):-
  trasforma(Az,Nodo,NuovoNodo),
  generaNuoviNodi(Nodo, ListaAzioniTail, [NuovoNodo|ListaNuoviNodiTail]).


/*
TEST estraiFValueMin --> ok
input
estraiFValueMin([(a, 0, 3), (b, 0, 5), (c, 0, 6)], FValueMin).
output
FValueMin = 3
*/


estraiPrimoNodoEPrimoFValue([(PrimoNodo, _, FValueMin)|ListaNuoviNodi], FValueMin, PrimoNodo).

/*
TEST estraiSecondoNodoESecondoFValue --> 
input
estraiSecondoNodoESecondoFValue([(a, 0, 3), (b, 0, 5), (c, 0, 6)], SecondoFValueMin, SecondoNodo).
output
SecondoFValueMin = ,
*/

% Case when the list has only one element. Return infinity for the second FValue.
estraiSecondoNodoESecondoFValue([_], inf, _) :- !.
estraiSecondoNodoESecondoFValue([_, (SecondoNodo, _, SecondoFValueMin)|ListaNuoviNodi], SecondoFValueMin, SecondoNodo).

confrontaFValueFLimit(FValue, FLimit, FValue):-
  \+fLimitMinoreDiFValue(FValue, FLimit, Min). %FValue minore di FLimit 

fLimitMinoreDiFValue(FValue, FLimit, Min):-
  FLimit < FValue, % FLimit minore di FValue
  Min is FLimit.

rbfs(Cammino):-
  iniziale(NodoIniziale),
  
  finale(NodoFinale),
  
  euristica(NodoIniziale, NodoFinale, FValue),
  
  FLimit is 100,
  
  rbfs_aux([(NodoIniziale, FLimit, FValue, _)|Coda], NodoFinale, CamminoFinale),

  stampa_lista(CamminoFinale).


stampa_lista([]).
stampa_lista([H|T]) :-
  write(H),
  stampa_lista(T).


% Caso in cui siamo arrivati a destinazione
rbfs_aux([(Nodo,_,_,_)|_], Nodo, CamminoFinale):- finale(Nodo),!. %caso base

% Caso in cui non ci sono successori possibili
rbfs_aux([(Nodo,_,_,_)|_], _, _):-
  
  findall(Az,applicabile(Az,Nodo),ListaAzioni),
  
  ListaAzioni = [], % The list of actions is empty
  
  !, fail.

% Caso ricorsivo 
rbfs_aux([(Nodo, FLimit, FValue, MiglioreNodoAlternativa)|Coda], NodoFinale, [Nodo|CamminoFinale]):-
  
  findall(Az,applicabile(Az,Nodo),ListaAzioni),

  impostaFValue(Nodo, NodoFinale, ListaAzioni, ListaNuoviNodi, RisultatoListaNuoviNodi),
  
  estraiPrimoNodoEPrimoFValue(RisultatoListaNuoviNodi, FValueMin, PrimoNodoMigliore),
  
  confrontaFValueFLimit(FValueMin, FLimit, Min),
  
  estraiSecondoNodoESecondoFValue(RisultatoListaNuoviNodi, SecondoFValueMin, SecondoNodoMigliore),

  append(Coda, RisultatoListaNuoviNodi, NuovaCoda),

  rbfs_aux([(PrimoNodoMigliore, SecondoFValueMin, FValueMin, SecondoNodo)|NuovaCoda], NodoFinale, [PrimoNodoMigliore|CamminoFinale]).
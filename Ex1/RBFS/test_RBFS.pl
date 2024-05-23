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
    FLimit , % Supponiamo un valore di default per FLimit, dovresti adattarlo al tuo contesto.
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


estraiFValueMin([(_, _, FValueMin)|ListaNuoviNodi], FValueMin).

estraiSecondoFValueMin([PrimoNodo, (_, _, SecondFValueMin)|ListaNuoviNodi], SecondFValueMin).
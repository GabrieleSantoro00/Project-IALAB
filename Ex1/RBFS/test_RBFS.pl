/*
TEST inserisci_ordinato --> ok
input 
inserisci_ordinato((a, 0, 8), [(e, 0, 6), (i, 0, 7)], ListaOrdinata). 
output
ListaOrdinata = [(e, 0, 6), (i, 0, 7), (a, 0, 8)].
*/
inserisci_ordinato((NuovoNodo,FLimit,FValue), [], [(NuovoNodo,FLimit,FValue)]).  % Se la lista di input è vuota, l'output è una lista con il solo elemento X.
inserisci_ordinato((NuovoNodo,FLimit,FValue), [(VecchioNuovoNodo, FLimit_2, FValue_2)|Tail], [(NuovoNodo,FLimit,FValue),(VecchioNuovoNodo, FLimit_2, FValue_2) | ListaNuoviNodiTail]) :-
  FValue =< FValue_2.  % Se X è minore o uguale al primo elemento della lista, metti X prima.
inserisci_ordinato((NuovoNodo,FLimit,FValue), [(VecchioNuovoNodo, FLimit_2, FValue_2)|Tail], [(VecchioNuovoNodo, FLimit_2, FValue_2) | NuovaListaNuoviNodi]) :-
  FValue > FValue_2,  % Se X è maggiore del primo elemento della lista, inserisci X nel resto della lista.
  inserisci_ordinato((NuovoNodo,FLimit,FValue), Tail, NuovaListaNuoviNodi).


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

impostaFValue(_, _, [], ListaNuoviNodiTail, ListaFValueTail).
impostaFValue(Nodo, NodoFinale, [Az|ListaAzioniTail], [], [FValue|ListaFValueTail]):- 
    trasforma(Az,Nodo,NuovoNodo),
    euristica(NuovoNodo, NodoFinale, FValue),
    inserisci_ordinato((NuovoNodo,FLimit,FValue), [], ListaNuoviNodiTail),
    impostaFValue(Nodo, NodoFinale, ListaAzioniTail, ListaNuoviNodiTail, [FValue|ListaFValueTail]).
impostaFValue(Nodo, NodoFinale, [Az|ListaAzioniTail], [Head|Tail], [FValue|ListaFValueTail]):- 
    trasforma(Az,Nodo,NuovoNodo),
    euristica(NuovoNodo, NodoFinale, FValue),
    inserisci_ordinato((NuovoNodo,FLimit,FValue), [Head|Tail], ListaNuoviNodiTail),
    impostaFValue(Nodo, NodoFinale, ListaAzioniTail, ListaNuoviNodiTail, [FValue|ListaFValueTail]).


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

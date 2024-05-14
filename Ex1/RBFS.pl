:- ['azioni'], ['labirinto'].

rbfs(Cammino):-
    iniziale(NodoIniziale),
    finale(NodoFinale),
    euristica(NodoIniziale, NodoFinale, FValue),    %FValue è il costo di ciascun nodo, mentre FLimit è il valore di default 
    rbfs_aux([(NodoIniziale, FLimit, FValue)|Coda], NodoFinale, CamminoFinale).

euristica(pos(R1,C1), pos(R2,C2), FValue):-
    DistanzaR is abs(R1 - R2),
    DistanzaC is abs(C1 - C2),
    Valore is DistanzaR + DistanzaC.

rbfs_aux([(Nodo,_,_)|_], Nodo, CamminoFinale):-
    finale(Nodo),!. %caso base
rbfs_aux([(Nodo,FLimit, FValue)|Coda], NodoFinale, CamminoFinale):-
    applicabile(Az,S),
    trasforma(Az,S,SNuovo),




    
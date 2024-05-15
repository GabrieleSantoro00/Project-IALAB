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
rbfs_aux([(Nodo, FLimit, FValue)|Coda], NodoFinale, CamminoFinale):-
    findall(Az,applicabile(Az,Nodo),ListaAzioni),
    impostaFValue(Nodo, NodoFinale, ListaAzioni, ListaNuoviNodi, ListaFValue),
    min_list(ListaFValue, FMin),
    min_list([FLimit, FMin], NuovoFLimit),
    
    
    %generaNuoviNodi(Nodo, ListaAzioni, ListaNuoviNodi),
    %generaFValue(ListaNuoviNodi, NodoFinale, ListaFValue),



impostaFValue(_, _, [], [], []).
impostaFValue(Nodo, NodoFinale, [Az|ListaAzioniTail], [(NuovoNodo,FLimit,FValue)|ListaNuoviNodiTail], [FValue|ListaFValueTail]):-
    trasforma(Az,Nodo,NuovoNodo),
    euristica(NuovoNodo, NodoFinale, FValue),
    impostaFValue(Nodo, NodoFinale, ListaAzioniTail, [(NuovoNodo,FLimit,FValue)|ListaNuoviNodiTail], [FValue|ListaFValueTail]).


generaNuoviNodi(_, [], []).
generaNuoviNodi(Nodo, [Az|ListaAzioniTail], [NuovoNodo|ListaNuoviNodiTail]):-
  trasforma(Az,Nodo,NuovoNodo),
  generaNuoviNodi(Nodo, ListaAzioniTail, [NuovoNodo|ListaNuoviNodiTail]).


generaFValue([], _, []).
generaFValue([NuovoNodo|ListaNuoviNodi], NodoFinale, [FValue|ListaFValueTail]):-
  euristica(NuovoNodo, NodoFinale, FValue),
  generaFValue(ListaNuoviNodiTail, NodoFinale, [FValue|ListaFValueTail]).




    
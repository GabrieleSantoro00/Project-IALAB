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
rbfs_aux([(Nodo, NodoAntecedenteFLimit, FValue)|Coda], NodoFinale, CamminoFinale):-
    findall(Az,applicabile(Az,Nodo),ListaAzioni),
    impostaFValue(Nodo, NodoFinale, ListaAzioni, ListaNuoviNodi, RisultatoListaNuoviNodi),
    estraiFValueMin([(_, _, FValueMin)|ListaNuoviNodi], FValueMin),
    confrontaFValueFLimit(FValueMin, FLimit),
    
    %Caso in cui FValue è minore di FLimit -> continuo a scendere in
    estraiSecondoNodo([PrimoNodo, (SecondoNodo, _, SecondoFValueMin)|ListaNuoviNodi], SecondoFValueMin, SecondoNodo).
    rbfs_aux([(NodoSuccessoreMinore, SecondoFValueMin, SecondoNodo, FValueMin)|ListaNuoviNodi], NodoFinale, CamminoFinale).
    
    rbfs_aux([(SecondoNodo,  )], NodoFinale, CamminoFinale).

   
  

confrontaFValueFLimit(FValue, FLimit):-
    \+FLimitMinoreDiFValue(FValue, FLimit),

    print "FValue minore di FLimit".
    % in questo caso devo associare il secondo nodo successore migliore 
    % e procedere nell'esplorazione

FLimitMaggioreDiFValue(FValue, FLimit):-
    FLimit < FValue,
    print "FLimit minore di FValue".
    % in questo caso non devo associare il secondo nodo successore migliore
    % e devo tornare indietro esplorando a partire dal secondo nodo migliore del nodo attuale



impostaFValue(_, _, [], ListaNuoviNodi, ListaNuoviNodi). % Caso base: nessuna azione da applicare.
impostaFValue(Nodo, NodoFinale, [Az|ListaAzioniTail], ListaNuoviNodi, RisultatoListaNuoviNodi):- 
  trasforma(Az, Nodo, NuovoNodo),
  euristica(NuovoNodo, NodoFinale, FValue),
  FLimit is 100, % Supponiamo un valore di default per FLimit, dovresti adattarlo al tuo contesto.
  inserisci_ordinato((NuovoNodo, FLimit, FValue), ListaNuoviNodi, NuovaListaNuoviNodi),
  impostaFValue(Nodo, NodoFinale, ListaAzioniTail, NuovaListaNuoviNodi, RisultatoListaNuoviNodi).


inserisci_ordinato((NuovoNodo, FLimit, FValue), [], [(NuovoNodo, FLimit, FValue)]).  % Se la lista di input è vuota, l'output è una lista con il solo elemento.
inserisci_ordinato((NuovoNodo, FLimit, FValue), [(VecchioNuovoNodo, FLimit_2, FValue_2)|Tail], [(NuovoNodo, FLimit, FValue), (VecchioNuovoNodo, FLimit_2, FValue_2) | Tail]) :-
  FValue =< FValue_2.  % Se FValue è minore o uguale al primo elemento della lista, metti il nuovo nodo prima.
inserisci_ordinato((NuovoNodo, FLimit, FValue), [(VecchioNuovoNodo, FLimit_2, FValue_2)|Tail], [(VecchioNuovoNodo, FLimit_2, FValue_2) | NuovaListaNuoviNodi]) :-
  FValue > FValue_2,  % Se FValue è maggiore del primo elemento della lista, inserisci nel resto della lista.
  inserisci_ordinato((NuovoNodo, FLimit, FValue), Tail, NuovaListaNuoviNodi).
  


%! Abbiamo accorpato i due predicati in impostaFValue
/*
generaNuoviNodi(_, [], ListaNuoviNodiTail).
generaNuoviNodi(Nodo, [Az|ListaAzioniTail], ListaNuoviNodiTail):-
    trasforma(Az,Nodo,NuovoNodo),
    generaNuoviNodi(Nodo, ListaAzioniTail, [NuovoNodo|ListaNuoviNodiTail]).

generaFValue([], _, []).
generaFValue([NuovoNodo|ListaNuoviNodi], NodoFinale, [FValue|ListaFValueTail]):-
  euristica(NuovoNodo, NodoFinale, FValue),
  generaFValue(ListaNuoviNodiTail, NodoFinale, [FValue|ListaFValueTail]).
*/



    
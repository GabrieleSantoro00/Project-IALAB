


inserisci_ordinato((NuovoNodo,FLimit,FValue), [], [(NuovoNodo,FLimit,FValue)]).  % Se la lista di input è vuota, l'output è una lista con il solo elemento X.
inserisci_ordinato((NuovoNodo,FLimit,FValue), [(VecchioNuovoNodo, FLimit_2, FValue_2)|Tail], [(NuovoNodo,FLimit,FValue),(VecchioNuovoNodo, FLimit_2, FValue_2) | ListaNuoviNodiTail]) :-
  FValue =< FValue_2.  % Se X è minore o uguale al primo elemento della lista, metti X prima.
inserisci_ordinato((NuovoNodo,FLimit,FValue), [(VecchioNuovoNodo, FLimit_2, FValue_2)|Tail], [(VecchioNuovoNodo, FLimit_2, FValue_2) | NuovaListaNuoviNodi]) :-
  FValue > FValue_2,  % Se X è maggiore del primo elemento della lista, inserisci X nel resto della lista.
  inserisci_ordinato((NuovoNodo,FLimit,FValue), Tail, NuovaListaNuoviNodi).


    inserisci_ordinato(X, [], [X]).  % Se la lista di input è vuota, l'output è una lista con il solo elemento X.
    inserisci_ordinato(X, [Y | Rest], [X, Y | Rest]) :-
        X =< Y.  % Se X è minore o uguale al primo elemento della lista, metti X prima.
    inserisci_ordinato(X, [Y | Rest], [Y | RestOut]) :-
        X > Y,  % Se X è maggiore del primo elemento della lista, inserisci X nel resto della lista.
        inserisci_ordinato(X, Rest, RestOut).
% Inserisce un elemento E in una lista ordinata mantenendo l'ordine
inserisci_ordinato(E, [], [E]).
inserisci_ordinato((F, H, Stato, Cammino), [(F1, H1, Stato1, Cammino1) | Coda], [(F, H, Stato, Cammino) | [(F1, H1, Stato1, Cammino1) | Coda]]) :-
    F =< F1.
inserisci_ordinato((F, H, Stato, Cammino), [(F1, H1, Stato1, Cammino1) | Coda], [(F1, H1, Stato1, Cammino1) | ListaOrdinata]) :-
    F > F1,
    inserisci_ordinato((F, H, Stato, Cammino), Coda, ListaOrdinata).

% Inserisce una lista di elementi in una lista già ordinata
inserisci_lista_ordinata([], Lista, Lista).
inserisci_lista_ordinata([E | Es], Lista, ListaOrdinata) :-
    inserisci_ordinato(E, Lista, ListaTemp),
    inserisci_lista_ordinata(Es, ListaTemp, ListaOrdinata).


/*
Stati da ordinare: [(1,3,(a),[nord,est]), (4,2,(b),[sud,ovest]), (7,3,(c),[est,est])]

Lista stati già ordinati: [(2,4,(d),[ovest,sud]), (9,1,(e),[ovest,ovest])]

inserisci_lista_ordinata([(1,3,(a),[nord,est]), (4,2,(b),[sud,ovest]), (7,3,(c),[est,est])],[(2,4,(d),[ovest,sud]), (9,1,(e),[ovest,ovest])],ListaOrdinata)

*/


differenza([], _, []).
differenza([(Stato, Cammino) | Tail], Visitati, Risultato) :-
    member((Stato, _), Visitati), !,
    differenza(Tail, Visitati, Risultato).
differenza([(Stato, Cammino) | Tail], Visitati, [(Stato, Cammino) | RisTail]) :-
    differenza(Tail, Visitati, RisTail).



/*

Stati da visitare: [(a),[nord,est]), ((b),[sud,ovest]), ((c),[est,est])]

Stati visitati: [(h),[nord,est]), ((b),[sud,ovest]), ((c),[est,est])]

differenza([((a),[nord,est]), ((b),[sud,ovest]), ((c),[est,est])], [((h),[nord,est]), ((b),[sud,ovest]), ((c),[est,est])], ListaNuoviStatiDaVisitare)

*/ 

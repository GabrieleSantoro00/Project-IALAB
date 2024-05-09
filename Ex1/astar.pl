% Definisci la funzione di costo
costo(_, _, Costo) :- Costo is 1.

% Definisci la funzione euristica
euristica(pos(R1,C1), pos(R2,C2), Valore) :-
    DistanzaR is abs(R1 - R2),
    DistanzaC is abs(C1 - C2),
    Valore is DistanzaR + DistanzaC.

% Definisci l'algoritmo A*
astar(NodoIniziale, NodoFinale, Cammino) :-
    euristica(NodoIniziale, NodoFinale, Euristica),
    astar_aux([(NodoIniziale, [], Euristica)], [], NodoFinale, Cammino).

% Definisci l'ausiliario dell'algoritmo A*
astar_aux([(Nodo, Cammino, _)|_], _, Nodo, CamminoInverso) :-
    reverse(Cammino, CamminoInverso).
astar_aux([(Nodo, Cammino, _)|Coda], Visitati, NodoFinale, CamminoFinale) :-
    findall((NodoAdiacente, [NodoAdiacente|Cammino], NuovoCosto)),
             applicabile(Azione, Nodo),
             trasforma(Azione, Nodo, NodoAdiacente),
             \+member(NodoAdiacente, Visitati),
             costo(Nodo, NodoAdiacente, Costo),
             length(Cammino, G),
             NuovoG is G + Costo,
             euristica(NodoAdiacente, NodoFinale, H),
             NuovoCosto is NuovoG + H,
             NuoviNodi,
    append(Coda, NuoviNodi, NuovaCoda),
    sort(3, @=<, NuovaCoda, NuovaCodaOrdinata),
    astar_aux(NuovaCodaOrdinata, [Nodo|Visitati], NodoFinale, CamminoFinale).
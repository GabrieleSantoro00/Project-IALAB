:- ['azioni'], ['labirinto'].

% Definisci la funzione di costo
costo(_, _, Costo) :- Costo is 1.

% Definisci la funzione euristica - distanza di Manhattan
euristica(pos(R1,C1), pos(R2,C2), Valore) :-
    DistanzaR is abs(R1 - R2),
    DistanzaC is abs(C1 - C2),
    Valore is DistanzaR + DistanzaC.

% Definisci l'algoritmo A*
astar(Cammino) :-
    iniziale(NodoIniziale),
    finale(NodoFinale),
    euristica(NodoIniziale, NodoFinale, Euristica),
    astar_aux([(NodoIniziale, [], Euristica)], [], NodoFinale, Cammino),
    reverse(Cammino, CamminoInverso),
    stampa_lista(Cammino).


% Caso base: se il nodo corrente è il nodo finale, restituisci il cammino inverso
astar_aux([(Nodo, Cammino, _)|_], _, Nodo, CamminoInverso) :- finale(Nodo),!.
% Caso ricorsivo: espandi il nodo corrente e aggiungi i nodi adiacenti alla coda  
astar_aux([(Nodo, Cammino, _)|Coda], Visitati, NodoFinale, CamminoFinale) :-
    findall((NodoAdiacente, [NodoAdiacente|Cammino], NuovoCosto),
             (\+member(NodoAdiacente, Visitati),!,
             applicabile(Azione, Nodo),
             trasforma(Azione, Nodo, NodoAdiacente),
             costo(Nodo, NodoAdiacente, Costo),
             length(Cammino, G),
             NuovoG is G + Costo,
             euristica(NodoAdiacente, NodoFinale, H),
             NuovoCosto is NuovoG + H),
            NuoviNodi),
    append(Coda, NuoviNodi, NuovaCoda),
    astar_aux(NuovaCoda, [Nodo|Visitati], NodoFinale, CamminoFinale).
% Caso ricorsivo: il nodo corrente è già stato visitato, passa al prossimo nodo
astar_aux([_|Coda], Visitati, NodoFinale, CamminoFinale) :-
    astar_aux(Coda, Visitati, NodoFinale, CamminoFinale).

% Caso base: la lista vuota è l'inverso di se stessa
reverse([], []).
% Caso ricorsivo: l'inverso di una lista con testa H e coda T è l'inverso di T seguito da H
reverse([H|T], Inverso) :-
    reverse(T, InversoT),
    append(InversoT, [H], Inverso).


% Definisci la funzione ausiliaria per stampare la lista
stampa_lista([]).
stampa_lista([H|T]) :-
  write(H), nl,
  stampa_lista(T).
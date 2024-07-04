

num_colonne(8).
num_righe(8).

mostriciattolo(pos(1,1)).
portale(pos(4,8)).

%blocchi non abbattibili
occupata(pos(1,5)).  %(R,C)
occupata(pos(2,2)).
occupata(pos(2,8)).
occupata(pos(3,8)).
occupata(pos(4,4)).
occupata(pos(4,5)).
occupata(pos(5,5)).
occupata(pos(6,2)).
occupata(pos(7,2)).
occupata(pos(7,6)).
occupata(pos(8,3)).






occupata(pos(5,1)).
occupata(pos(5,1)).

%posizione gemme
gemma(pos(1,7)).
gemma(pos(5,4)).
gemma(pos(8,8)).

%blocchi di ghiaccio
bloccoDiGhiaccio(pos(2,6)).
bloccoDiGhiaccio(pos(2,7)).
bloccoDiGhiaccio(pos(7,7)).

%posizione martello
martello(pos(8,2)).

stato_iniziale(S) :-
    mostriciattolo(Mostro),
    findall(gemma(G), gemma(G), Gemme),
    findall(B, bloccoDiGhiaccio(B), BlocchiDiGhiaccio),
    martello(Martello),
    calcola_ha_preso_martello(Mostro, HaMartello),
    S = stato(mostro(Mostro), Gemme, BlocchiDiGhiaccio, Martello, HaMartello).








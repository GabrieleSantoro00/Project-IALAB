% Predicati dinamici per configurare lo stato del gioco
:- dynamic(mostro/1).
:- dynamic(bloccoDiGhiaccio/1).
:- dynamic(gemma/1).
:- dynamic(occupata/1).
:- dynamic(portale/1).
:- dynamic(num_colonne/1).
:- dynamic(num_righe/1).
:- dynamic(martello/1).

% Predicati per test
configura_stato_iniziale :-
    retractall(mostro(_)),
    retractall(bloccoDiGhiaccio(_)),
    retractall(gemma(_)),
    retractall(occupata(_)),
    retractall(portale(_)),
    retractall(num_colonne(_)),
    retractall(num_righe(_)),
    retractall(martello(_)),
    assert(num_righe(5)),
    assert(num_colonne(5)),
    assert(mostro(pos(1, 1))),
    assert(gemma(pos(1, 4))),
    assert(gemma(pos(3, 3))), %nel primo test mi sposta solo la prima gemma
    assert(bloccoDiGhiaccio(pos(3, 1))),
    assert(bloccoDiGhiaccio(pos(4, 1))),
    assert(martello(pos(2, 1))),
    assert(occupata(pos(5, 5))).

stato_iniziale(Stato) :-
    mostro(Mostro),
    findall(G, gemma(G), Gemme),
    findall(B, bloccoDiGhiaccio(B), BlocchiDiGhiaccio),
    martello(Martello),
    (ha_preso_martello(mostro(Mostro)) -> HaMartello = true ; HaMartello = false),
    Stato = stato(mostro(Mostro), Gemme, BlocchiDiGhiaccio, Martello, HaMartello).

test_movimento :-
    configura_stato_iniziale,
    stato_iniziale(StatoIniziale),
    muovi_tutti_gli_oggetti(sud, StatoIniziale, StatoFinale),
    writeln('Stato Iniziale:'),
    writeln(StatoIniziale),
    writeln('Stato Finale:'),
    writeln(StatoFinale).



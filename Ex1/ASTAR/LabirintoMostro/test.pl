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
    assert(num_righe(8)),
    assert(num_colonne(8)),
    assert(occupata(pos(1, 1))),
    assert(martello(pos(1, 4))),
    assert(bloccoDiGhiaccio(pos(1, 2))),
    assert(gemma(pos(5, 4))),
    %assert(bloccoDiGhiaccio(pos(3, 1))),
    assert(bloccoDiGhiaccio(pos(1, 6))),
    assert(bloccoDiGhiaccio(pos(1, 7))),
    assert(mostro(pos(5, 6))),
    assert(occupata(pos(2, 4))).
    %assert(occupata(pos(4, 4))).


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
    muovi_tutti_gli_oggetti(est, StatoIniziale, StatoFinale),
    writeln('Stato Iniziale:'),
    writeln(StatoIniziale),
    writeln('Stato Finale:'),
    writeln(StatoFinale).



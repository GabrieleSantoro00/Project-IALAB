:- dynamic(martello/1).
:- dynamic(bloccoDiGhiaccio/1).
:- dynamic(gemma/1).
:- dynamic(mostriciattolo/1).
:- dynamic(occupata/1).
:- dynamic(portale/1).
:- dynamic(num_colonne/1).
:- dynamic(num_righe/1).

% Definizione dello stato del gioco
stato(Mostro, Gemme, BlocchiDiGhiaccio, Martello, HaMartello) :-
    mostro(Mostro),
    findall(G, gemma(G), Gemme),
    findall(B, bloccoDiGhiaccio(B), BlocchiDiGhiaccio),
    martello(Martello),
    (ha_preso_martello(Mostro) -> HaMartello = true ; HaMartello = false).

% Definizione delle direzioni di movimento
direzione(nord, pos(R, C), pos(R2, C)) :- R2 is R - 1, R2 > 0.
direzione(sud, pos(R, C), pos(R2, C)) :- num_righe(NR), R2 is R + 1, R2 =< NR.
direzione(ovest, pos(R, C), pos(R, C2)) :- C2 is C - 1, C2 > 0.
direzione(est, pos(R, C), pos(R, C2)) :- num_colonne(NC), C2 is C + 1, C2 =< NC.

% Verifica se una posizione è valida
posizione_valida(pos(R, C)) :-
    num_righe(NR), num_colonne(NC),
    R > 0, R =< NR,
    C > 0, C =< NC,
    \+ occupata(pos(R, C)).

% Estrae la posizione del mostro
posizione_mostro(mostro(Pos), Pos).

% Estrae la posizione del martello
posizione_martello(Pos) :- martello(Pos).

% Verifica se il mostro ha preso il martello
ha_preso_martello(Mostro) :-
    posizione_mostro(Mostro, Pos),
    posizione_martello(Pos).

% Predicato per rompere il ghiaccio
rompi_ghiaccio(Posizione, BlocchiDiGhiaccio, NuoviBlocchiDiGhiaccio) :-
    (   memberchk(Posizione, BlocchiDiGhiaccio),
        select(Posizione, BlocchiDiGhiaccio, NuoviBlocchiDiGhiaccio)
    ->  true
    ;   NuoviBlocchiDiGhiaccio = BlocchiDiGhiaccio
    ).

% Ottieni tutti gli oggetti mobili nel gioco
ottieni_oggetti_mobili(OggettiMobili) :-
    mostro(Mostro),
    findall(gemma(G), gemma(G), Gemme),
    append(Gemme, [mostro(Mostro)], OggettiMobili).

% Muovi tutti gli oggetti nella direzione specificata
muovi_tutti_gli_oggetti(Direzione, StatoIniziale, StatoFinale) :-
    ottieni_oggetti_mobili(OggettiMobili),
    (
        Direzione = nord, sort(1, @=<, OggettiMobili, OggettiMobiliOrdinati);
        Direzione = sud, sort(1, @>=, OggettiMobili, OggettiMobiliOrdinati);
        Direzione = ovest, sort(2, @=<, OggettiMobili, OggettiMobiliOrdinati);
        Direzione = est, sort(2, @>=, OggettiMobili, OggettiMobiliOrdinati)
    ),
    muovi_oggetti(OggettiMobiliOrdinati, Direzione, StatoIniziale, StatoFinale).

% Predicato principale per muovere tutti gli oggetti nella direzione specificata
muovi_oggetti([], _, Stato, Stato):-!.
muovi_oggetti([Oggetto|Resto], Direzione, StatoIniziale, StatoFinale) :-
    muovi_oggetto_in_direzione(Direzione, Oggetto, StatoIniziale, StatoIntermedio),  %togliere questa parte
    muovi_oggetti(Resto, Direzione, StatoIntermedio, StatoFinale).

muovi_oggetto_in_direzione(Direzione, gemma(PosIniziale), stato(Mostro, Gemme, BlocchiDiGhiaccio, Martello, HaMartello), StatoFinale) :-
 muovi_gemma(Direzione, PosIniziale, stato(Mostro, Gemme, BlocchiDiGhiaccio, Martello, HaMartello), StatoFinale).

 muovi_gemma(Direzione, PosizioneCorrente, stato(Mostro, Gemme, BlocchiDiGhiaccio, Martello, HaMartello), StatoFinale) :-
     direzione(Direzione, PosizioneCorrente, NuovaPos),
     posizione_valida(NuovaPos),
     StatoIniziale = stato(Mostro, Gemme, BlocchiDiGhiaccio, Martello, HaMartello),
     Mostro = mostro(PosMostro),
     (   NuovaPos \= PosMostro,
         \+ memberchk(NuovaPos, BlocchiDiGhiaccio),
         \+ occupata(NuovaPos),
         select(PosizioneCorrente, Gemme, GemmeSenzaCorrente),
         StatoFinale = stato(Mostro, [NuovaPos|GemmeSenzaCorrente], BlocchiDiGhiaccio, Martello, HaMartello)
     ;   StatoFinale = StatoIniziale
     ).


muovi_gemma(_, PosizioneCorrente, stato(Mostro, gemma(PosizioneCorrente), BlocchiDiGhiaccio, Martello, HaMartello),
             stato(Mostro, gemma(PosizioneCorrente), BlocchiDiGhiaccio, Martello, HaMartello)).

muovi_oggetto_in_direzione(Direzione, mostro(PosIniziale), stato(Mostro, Gemme, BlocchiDiGhiaccio, Martello, HaMartello), StatoFinale) :-
    muovi_mostro(Direzione, PosIniziale, stato(Mostro, Gemme, BlocchiDiGhiaccio, Martello, HaMartello), StatoFinale).

% Muovi il mostro nella direzione specificata
muovi_mostro(Direzione, PosizioneCorrente, StatoIniziale, StatoFinale) :-
    direzione(Direzione, PosizioneCorrente, NuovaPos),
    posizione_valida(NuovaPos),
    StatoIniziale = stato(_, Gemme, BlocchiDiGhiaccio, Martello, HaMartello),
    \+ memberchk(NuovaPos, Gemme),
    \+ occupata(NuovaPos),
    (
        NuovaPos = Martello ->
        (retract(martello(Martello)), HaMartello1 = true)
        ;
        HaMartello1 = HaMartello
    ),
    (
        HaMartello1 ->
        (
            rompi_ghiaccio(NuovaPos, BlocchiDiGhiaccio, NuoviBlocchiDiGhiaccio),
            (   memberchk(NuovaPos, NuoviBlocchiDiGhiaccio) ->
                muovi_mostro(Direzione, NuovaPos, stato(mostro(NuovaPos), Gemme, NuoviBlocchiDiGhiaccio, Martello, HaMartello1), StatoFinale)
                ;
                muovi_mostro(Direzione, NuovaPos, stato(mostro(NuovaPos), Gemme, NuoviBlocchiDiGhiaccio, Martello, HaMartello1), StatoFinale)
            )
        )
        ;
        muovi_mostro(Direzione, NuovaPos, stato(mostro(NuovaPos), Gemme, BlocchiDiGhiaccio, Martello, HaMartello1), StatoFinale)
    ).

muovi_mostro(_, PosizioneCorrente, stato(mostro(PosizioneCorrente), Gemme, BlocchiDiGhiaccio, Martello, HaMartello),
             stato(mostro(PosizioneCorrente), Gemme, BlocchiDiGhiaccio, Martello, HaMartello)).

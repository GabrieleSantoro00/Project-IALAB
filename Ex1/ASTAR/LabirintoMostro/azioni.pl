:- dynamic(martello/1).
:- dynamic(bloccoDiGhiaccio/1).
:- dynamic(gemma/1).
:- dynamic(mostriciattolo/1).

direzione(nord, pos(R, C), pos(R2, C)) :- R2 is R - 1, R2 > 0.
direzione(sud, pos(R, C), pos(R2, C)) :- num_righe(NR), R2 is R + 1, R2 =< NR.
direzione(ovest, pos(R, C), pos(R, C2)) :- C2 is C - 1, C2 > 0.
direzione(est, pos(R, C), pos(R, C2)) :- num_colonne(NC), C2 is C + 1, C2 =< NC.

posizione_valida(pos(R, C)) :-
    num_righe(NR), num_colonne(NC),
    R > 0, R =< NR,
    C > 0, C =< NC,
    \+ occupata(pos(R, C)).

ha_preso_martello(Mostro) :-
    posizione_mostro(Mostro, PosizioneMostro),
    martello(PosizioneMartello),
    PosizioneMostro = PosizioneMartello.

calcola_ha_preso_martello(Mostro, HaMartello) :-
    (ha_preso_martello(Mostro) -> HaMartello = true ; HaMartello = false).

posizione_mostro(Mostro, Posizione) :-
    mostriciattolo(PosizioneMostro),
    Posizione = PosizioneMostro.

rompi_ghiaccio(pos(MostroR, MostroC), [pos(MostroR, MostroC)|BlocchiDiGhiaccio], NuoviBlocchiDiGhiaccio) :- !, NuoviBlocchiDiGhiaccio = BlocchiDiGhiaccio.
rompi_ghiaccio(_, BlocchiDiGhiaccio, BlocchiDiGhiaccio).

stato(Mostro, Gemme, BlocchiDiGhiaccio, Martello, HaMartello) :-
    mostriciattolo(Mostro),
    findall(G, gemma(G), Gemme),
    findall(B, bloccoDiGhiaccio(B), BlocchiDiGhiaccio),
    martello(Martello),
    calcola_ha_preso_martello(Mostro, HaMartello).

ottieni_oggetti_mobili(OggettiMobili) :-
    mostriciattolo(Mostro),
    findall(gemma(G), gemma(G), Gemme),
    append(Gemme, [mostro(Mostro)], OggettiMobili).

ordina_oggetti(Direzione, OggettiMobili, OggettiOrdinati) :-
    (Direzione == nord -> sort(1, @=<, OggettiMobili, OggettiOrdinati);
     Direzione == sud -> sort(1, @>=, OggettiMobili, OggettiOrdinati);
     Direzione == ovest -> sort(2, @=<, OggettiMobili, OggettiOrdinati);
     Direzione == est -> sort(2, @>=, OggettiMobili, OggettiOrdinati)).

raggiunto_portale(PosizioneMostro) :-
    portale(PosizionePortale),
    PosizioneMostro == PosizionePortale.

muovi_tutti_oggetti(Direzione, StatoIniziale, StatoFinale) :-
    ottieni_oggetti_mobili(OggettiMobili),
    ordina_oggetti(Direzione, OggettiMobili, _),
    muovi_oggetti(OggettiMobili, Direzione, StatoIniziale, StatoFinale).

muovi_oggetti([], _, Stato, Stato).
muovi_oggetti([Oggetto|Resto], Direzione, StatoIniziale, StatoFinale) :-
    muovi_oggetto_e_rimuovi(Direzione, Oggetto, StatoIniziale, StatoIntermedio),
    muovi_oggetti(Resto, Direzione, StatoIntermedio, StatoFinale).

muovi_oggetto_e_rimuovi(Direzione, Oggetto, StatoIniziale, StatoFinale) :-
    muovi_oggetto_in_direzione(Direzione, Oggetto, StatoIniziale, StatoTemp),
    (StatoIniziale == StatoTemp -> StatoFinale = StatoTemp; muovi_oggetto_e_rimuovi(Direzione, Oggetto, StatoTemp, StatoFinale)).

muovi_oggetto_in_direzione(Direzione, gemma(PosizioneAttuale), StatoIniziale, StatoFinale) :-
    direzione(Direzione, PosizioneAttuale, NuovaPosizione),
    posizione_valida(NuovaPosizione),
    aggiorna_posizione_gemma(PosizioneAttuale, NuovaPosizione, StatoIniziale, StatoFinale).

muovi_oggetto_in_direzione(Direzione, mostriciattolo(PosizioneAttuale), StatoIniziale, StatoFinale) :-
    direzione(Direzione, PosizioneAttuale, NuovaPosizione),
    (   posizione_valida(NuovaPosizione) ->
        aggiorna_posizione_mostro(PosizioneAttuale, NuovaPosizione, StatoIniziale, StatoTemp),
        (   raggiunto_portale(NuovaPosizione) ->
            StatoFinale = StatoTemp
        ;   muovi_oggetto_in_direzione(Direzione, mostriciattolo(NuovaPosizione), StatoTemp, StatoFinale)
        )
    ;   StatoFinale = StatoIniziale % Se la posizione non è valida, non muovere l'oggetto e restituire lo stato attuale
    ).

aggiorna_posizione_gemma(PosizioneAttuale, NuovaPosizione, stato(mostro(Mostro), Gemme, BlocchiDiGhiaccio, Martello, HaMartello), stato(mostro(Mostro), NuoveGemme, BlocchiDiGhiaccio, Martello, HaMartello)) :-
    selectchk(gemma(PosizioneAttuale), Gemme, GemmeRimanenti),
    NuoveGemme = [gemma(NuovaPosizione)|GemmeRimanenti].

aggiorna_posizione_mostro(_, NuovaPosizione, stato(_, Gemme, BlocchiDiGhiaccio, Martello, HaMartello), stato(mostro(NuovaPosizione), Gemme, BlocchiDiGhiaccio, Martello, HaMartello)).


stato_iniziale(stato(mostro(pos(2, 2)), [], [], pos(1, 1), false)).


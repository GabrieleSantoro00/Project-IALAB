direzione(nord, pos(R, C), pos(R2, C)) :- R2 is R - 1, R2 > 0.
direzione(sud, pos(R, C), pos(R2, C)) :- num_righe(NR), R2 is R + 1, R2 =< NR.
direzione(ovest, pos(R, C), pos(R, C2)) :- C2 is C - 1, C2 > 0.
direzione(est, pos(R, C), pos(R, C2)) :- num_colonne(NC), C2 is C + 1, C2 =< NC.

%oggettiMobili(Mostricattolo,Gemme).
%mostriciattolo è una posizione (X,Y), le gemme sono una lista di posizioni (X,Y)

posizione_valida(pos(R, C)) :-
    num_righe(NR), num_colonne(NC),
    R > 0, R =< NR,
    C > 0, C =< NC,
    \+ occupata(pos(R, C)).

%ha_preso_martello(Mostro) :- stato(Mostro, _, _, _, true).

ha_preso_martello(Mostro) :-
    posizione_mostro(Mostro, Pos),
    posizione_martello(Pos).

rompi_ghiaccio(stato(mostro(Mostro), _, BlocchiDiGhiaccio, HaMartello), BloccoDiGhiaccio, NuoviBlocchiDiGhiaccio) :-
    % Verifica se il mostro ha raccolto il martello
    HaMartello = true,
    % Verifica se il mostro può rompere il blocco di ghiaccio specificato
    Mostro = BloccoDiGhiaccio,
    % Se il mostro ha raccolto il martello e può rompere il blocco di ghiaccio, rimuove il blocco di ghiaccio specificato
    selectchk(BloccoDiGhiaccio, BlocchiDiGhiaccio, NuoviBlocchiDiGhiaccio).

% Definizione dello stato
stato(Mostro, Gemme, BlocchiDiGhiaccio, Martello, HaMartello) :-
    mostriciattolo(Mostro),
    findall(G, gemma(G), Gemme),
    findall(B, bloccoDiGhiaccio(B), BlocchiDiGhiaccio),
    martello(Martello),
    (ha_preso_martello(Mostro) -> HaMartello = true ; HaMartello = false).

% Definizione della funzione muovi_mostro/3
muovi_mostro([], Stato, Stato).
muovi_mostro([Direzione|Resto], StatoIniziale, StatoFinale) :-
    muovi_mostro_in_direzione(Direzione, StatoIniziale, StatoIntermedio),
    muovi_mostro(Resto, StatoIntermedio, StatoFinale).

muovi_gemma([Direzione|Resto], StatoIniziale, StatoFinale) :-
    muovi_gemma_in_direzione(Direzione, StatoIniziale, StatoIntermedio),
    muovi_gemma(Resto, StatoIntermedio, StatoFinale).

% Definizione della funzione muovi_mostro_in_direzione/3
muovi_mostro_in_direzione(Direzione, stato(mostro(Mostro), gemme(Gemme), blocchiDiGhiaccio(BlocchiDiGhiaccio), haMartello(HaMartello)), StatoFinale) :-
    % Calcola la nuova posizione
    direzione(Direzione, Mostro, NuovaPos),
    direzione(Direzione,Gemma,NuovaPosGemma),
    % Verifica se la nuova posizione è valida
    posizione_valida(NuovaPos),
    posizione_valida(NuovaPosGemma),

    % Se la nuova posizione contiene un blocco di ghiaccio e il mostro ha raccolto il martello, rimuove il blocco
    (selectchk(NuovaPos, BlocchiDiGhiaccio, NuoviBlocchiDiGhiaccio), HaMartello = true ->
        StatoFinale = stato(mostro(NuovaPos), gemme(Gemme), blocchiDiGhiaccio(NuoviBlocchiDiGhiaccio), haMartello(HaMartello))
    ;
        % Se la nuova posizione non contiene un blocco di ghiaccio, verifica se è libera
        \+ occupata(NuovaPos),
        \+ gemma(NuovaPos),
        % Aggiorna la posizione del mostro
        StatoFinale = stato(mostro(NuovaPos), gemme(Gemme), blocchiDiGhiaccio(BlocchiDiGhiaccio), haMartello(HaMartello))
    ).



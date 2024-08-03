% Predicato per l'acquisizione dello stato iniziale del labirinto
iniziale(StatoIniziale) :-
    mostro(Mostro),
    findall(G, gemma(G), Gemme),
    findall(B, bloccoDiGhiaccio(B), BlocchiDiGhiaccio),
    martello(Martello),
    HaMartello = false,
    StatoIniziale = (Mostro, Gemme, BlocchiDiGhiaccio, Martello, HaMartello).


% Predicato per l'acquisizione dello stato finale del labirinto
finale(Mostro) :-
  portale(Mostro).


arrivoAlPortale((Mostro, _, _, _, _)) :- finale(Mostro).


% Definizione delle direzioni di movimento
direzione(nord, pos(R, C), pos(R2, C)) :- R2 is R - 1, R2 > 0.
direzione(sud, pos(R, C), pos(R2, C)) :- num_righe(NR), R2 is R + 1, R2 =< NR.
direzione(ovest, pos(R, C), pos(R, C2)) :- C2 is C - 1, C2 > 0.
direzione(est, pos(R, C), pos(R, C2)) :- num_colonne(NC), C2 is C + 1, C2 =< NC.


% Predicati che estraggono le posizioni dei vari oggetti del labirinto dalla tupla Stato attuale.


posizione_mostro((Mostro, _, _, _, _), Mostro).


posizione_gemme((_, Gemme, _, _, _), Gemme).


posizione_martello((_, _, _, Martello, _), Martello).


posizione_blocco_di_ghiaccio((_, _, BlocchiDiGhiaccio, _, _), BlocchiDiGhiaccio).


ha_martello((_, _, _, _, HaMartello), HaMartello).


muovi_tutte_le_direzioni((StatoIniziale, Cammino), ListaStatiFinali) :-
  muovi_tutti_gli_oggetti(nord, StatoIniziale, StatoFinaleNord),
  %writeln("StatoFinaleNord: "), writeln(StatoFinaleNord),
  muovi_tutti_gli_oggetti(sud, StatoIniziale, StatoFinaleSud),
  %writeln("StatoFinaleSud: "), writeln(StatoFinaleSud),
  muovi_tutti_gli_oggetti(ovest, StatoIniziale, StatoFinaleOvest),
  %writeln("StatoFinaleOvest: "), writeln(StatoFinaleOvest),
  muovi_tutti_gli_oggetti(est, StatoIniziale, StatoFinaleEst),
  %writeln("StatoFinaleEst: "), writeln(StatoFinaleEst),
  ListaStatiFinali = [(StatoFinaleNord, [nord | Cammino]), (StatoFinaleSud, [sud | Cammino]), (StatoFinaleOvest, [ovest | Cammino]), (StatoFinaleEst, [est | Cammino])].


% Predicato principale per muovere tutti gli oggetti nella direzione specificata
muovi_tutti_gli_oggetti(Direzione, StatoIniziale, StatoFinale) :-
    ottieni_oggetti_mobili(StatoIniziale, OggettiMobili),
    muovi_oggetto_in_direzione(Direzione, OggettiMobili, StatoIniziale, StatoFinale).


% Ottieni tutti gli oggetti mobili nel gioco
ottieni_oggetti_mobili(Stato, (Mostro, Gemme)) :-
    posizione_mostro(Stato, Mostro),
    posizione_gemme(Stato, Gemme).


muovi_oggetto_in_direzione(Direzione, (Mostro, Gemme), StatoIniziale, StatoFinale) :-
    muovi_gemme(Direzione, Gemme, StatoIniziale, StatoIntermedio),
    (muovi_mostro(Direzione, Mostro, StatoIntermedio, StatoFinale) ->
        true
    ;
        StatoFinale = StatoIntermedio
    ).


muovi_gemme(_, [], Stato, Stato).
muovi_gemme(Direzione, [Gemma|AltreGemme], StatoIniziale, StatoFinale) :-
    (muovi_gemma(Direzione, Gemma, StatoIniziale, StatoIntermedio) ->
        muovi_gemme(Direzione, AltreGemme, StatoIntermedio, StatoFinale)
    ;
        muovi_gemme(Direzione, AltreGemme, StatoIniziale, StatoFinale)
    ).


%muovi_gemma(_, _, Stato, Stato). % Caso base: se non è possibile muovere ulteriormente la gemma, restituisci lo stato attuale
muovi_gemma(Direzione, PosizioneCorrente, StatoIniziale, StatoFinale) :-
    %write('Muovo la gemma da '), write(PosizioneCorrente), write(' in direzione '), writeln(Direzione),
    (direzione(Direzione, PosizioneCorrente, NuovaPos),
        posizione_valida(NuovaPos, StatoIniziale) ->
        aggiorna_stato(PosizioneCorrente, NuovaPos, StatoIniziale, StatoIntermedio),
        muovi_gemma(Direzione, NuovaPos, StatoIntermedio, StatoFinale)
    ;
        StatoFinale = StatoIniziale
    ).


posizione_valida(Posizione, (Mostro, Gemme, BlocchiDiGhiaccio, Martello, HaMartello)) :-
    Posizione \= Mostro,
    \+memberchk(Posizione, BlocchiDiGhiaccio),
    \+occupata(Posizione),
    \+memberchk(Posizione, Gemme).


posizione_valida(pos(R, C)) :-
    num_righe(NR), num_colonne(NC),
    R > 0, R =< NR,
    C > 0, C =< NC,
    \+occupata(pos(R, C)).


aggiorna_stato(PosizioneCorrente, NuovaPos, (Mostro, Gemme, BlocchiDiGhiaccio, Martello, HaMartello), StatoFinale):-
    select(PosizioneCorrente, Gemme, GemmeSenzaCorrente), % Rimuove la posizione corrente dalla lista delle gemme
    StatoFinale = (Mostro, [NuovaPos|GemmeSenzaCorrente], BlocchiDiGhiaccio, Martello, HaMartello). % Aggiunge la nuova posizione alla lista delle gemme


%muovi_mostro(_, _, Stato, Stato):- !.
% Predicato principale per muovere il mostro
muovi_mostro(Direzione, PosizioneCorrente, StatoIniziale, StatoFinale) :-
  %write('Muovo il mostro da '), write(PosizioneCorrente), write(' in direzione '), writeln(Direzione),
  (direzione(Direzione, PosizioneCorrente, NuovaPos),
      posizione_valida(NuovaPos, StatoIniziale) ->
      (aggiorna_stato_mostro(PosizioneCorrente, NuovaPos, StatoIniziale, StatoIntermedio),
      muovi_mostro(Direzione, NuovaPos, StatoIntermedio, StatoFinale))
  ;
      StatoFinale = StatoIniziale
  ).


% Predicato per aggiornare lo stato del mostro
aggiorna_stato_mostro(PosizioneCorrente, NuovaPos, (Mostro, Gemme, BlocchiDiGhiaccio, Martello, HaMartello), StatoFinale) :-
  ( NuovaPos = Martello ->
      NuovoHaMartello = true
  ; 
      NuovoHaMartello = HaMartello
  ),
  ( NuovoHaMartello ->
      rompi_ghiaccio(NuovaPos, BlocchiDiGhiaccio, NuoviBlocchiDiGhiaccio),
      NuovoStato = (NuovaPos, Gemme, NuoviBlocchiDiGhiaccio, Martello, NuovoHaMartello)
  ;
      \+ memberchk(NuovaPos, BlocchiDiGhiaccio),
      NuovoStato = (NuovaPos, Gemme, BlocchiDiGhiaccio, Martello, NuovoHaMartello)
  ),
  StatoFinale = NuovoStato.


% Predicato per rompere il ghiaccio
rompi_ghiaccio(Posizione, BlocchiDiGhiaccio, NuoviBlocchiDiGhiaccio) :-
    (   
      memberchk(Posizione, BlocchiDiGhiaccio) ->
        select(Posizione, BlocchiDiGhiaccio, NuoviBlocchiDiGhiaccio)
    ;
        NuoviBlocchiDiGhiaccio = BlocchiDiGhiaccio
    ).
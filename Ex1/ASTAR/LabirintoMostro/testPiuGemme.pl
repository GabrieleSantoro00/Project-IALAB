test_aggiornamento_gemma :-
    % Pulizia dello stato iniziale
    retractall(gemma(_)),
    retractall(occupata(_)),

    % Definizione dello stato iniziale con più gemme
    assert(gemma(pos(3, 2))),
    assert(gemma(pos(4, 5))),
    assert(gemma(pos(5, 3))), % Aggiunta di una nuova gemma
    assert(gemma(pos(2, 4))), % Aggiunta di un'altra nuova gemma

    % Creazione dello stato iniziale con le gemme definite
    StatoIniziale = stato(mostro(pos(1, 1)), [gemma(pos(3, 2)), gemma(pos(4, 5)), gemma(pos(5, 3)), gemma(pos(2, 4))], [], pos(0, 0), false),

    % Tentativo di muovere tutte le gemme a nord
    muovi_oggetto_in_direzione(nord, gemma(pos(3, 2)), StatoIniziale, StatoIntermedio1),
    muovi_oggetto_in_direzione(nord, gemma(pos(4, 5)), StatoIntermedio1, StatoIntermedio2),
    muovi_oggetto_in_direzione(nord, gemma(pos(5, 3)), StatoIntermedio2, StatoIntermedio3),
    muovi_oggetto_in_direzione(nord, gemma(pos(2, 4)), StatoIntermedio3, StatoFinale),

    % Verifica se le gemme sono state aggiornate correttamente
    StatoFinale = stato(_, Gemme, _, _, _),
    ( member(gemma(pos(2, 2)), Gemme),
      member(gemma(pos(3, 5)), Gemme),
      member(gemma(pos(4, 3)), Gemme),
      member(gemma(pos(1, 4)), Gemme) ->
        write('Test superato: tutte le gemme sono state correttamente aggiornate.'), nl
    ;
        write('Test fallito: la posizione delle gemme non è stata aggiornata come previsto.'), nl
    ).
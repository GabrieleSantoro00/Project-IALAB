test_movimento :-
    % Pulizia dello stato iniziale
    retractall(mostriciattolo(_)),
    retractall(gemma(_)),
    retractall(occupata(_)),

    % Definizione dello stato iniziale
    assert(mostriciattolo(pos(1, 1))),
    assert(gemma(pos(2, 2))),
    assert(gemma(pos(3, 3))),
    assert(occupata(pos(1, 1))),
    assert(occupata(pos(2, 2))),
    assert(occupata(pos(3, 3))),

    % Creazione dello stato iniziale
    StatoIniziale = stato(mostro(pos(1, 1)), [gemma(pos(2, 2)), gemma(pos(3, 3))], [], pos(0, 0), false),

    % Movimento a est
    Direzione = est,
    muovi_tutti_oggetti(Direzione, StatoIniziale, StatoFinale),

    % Verifica dello stato finale
    StatoFinale = stato(mostro(PosizioneMostroFinale), Gemme, _, _, _),
    PosizioneMostroAttesa = pos(1, 2),
    PosizioniGemmeAttese = [pos(2, 3), pos(3, 4)],

    % Verifica posizione mostro
    (PosizioneMostroFinale == PosizioneMostroAttesa ->
        write('Mostro si è mosso correttamente.'), nl
    ;
        write('Errore: il mostro non si è mosso come previsto.'), nl, fail
    ),

    % Verifica posizioni gemme
    forall(member(PosizioneGemmaAttesa, PosizioniGemmeAttese),
           (member(gemma(PosizioneGemmaAttesa), Gemme) ->
                true
           ;
                write('Errore: una gemma non si è mossa come previsto.'), nl, fail
           )),
    write('Tutte le gemme si sono mosse correttamente.'), nl.
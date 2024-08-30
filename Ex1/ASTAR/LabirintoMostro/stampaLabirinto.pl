% Definizione dei predicati dinamici per i fatti
:- dynamic num_righe/1.
:- dynamic num_colonne/1.
:- dynamic limite/1.
:- dynamic iniziale/1.
:- dynamic finale/1.
:- dynamic occupata/1.
:- dynamic mostro/1.
:- dynamic gemma/1.
:- dynamic ghiaccio/1.
:- dynamic martello/1.

% Legge il file e carica i fatti nel database
leggi_file(File) :-
    open(File, read, Stream),
    leggi_fatti(Stream),
    close(Stream).

% Legge i fatti dal file
leggi_fatti(Stream) :-
    \+ at_end_of_stream(Stream),
    read(Stream, Fatt),
    assertz(Fatt),
    leggi_fatti(Stream).
leggi_fatti(_).

% Stampa il labirinto formattato con numeri di riga e colonna
stampa_labirinto :-
    num_righe(Righe),
    num_colonne(Colonne),
    format('Labirinto ~dx~d:~n', [Righe, Colonne]),
    write('    '),
    stampa_numeri_colonne(1, Colonne),
    nl,
    write('  +'),
    stampa_separatore(Colonne),
    stampa_righe(1, Righe, Colonne).

% Stampa i numeri delle colonne
stampa_numeri_colonne(Col, MaxCol) :-
    Col =< MaxCol,
    format(' ~d ', [Col]),
    NextCol is Col + 1,
    stampa_numeri_colonne(NextCol, MaxCol).
stampa_numeri_colonne(_, _).

% Stampa il separatore
stampa_separatore(Colonne) :-
    Col is Colonne * 3,
    format('~|~`-t~*+~n', [Col]).

% Stampa tutte le righe del labirinto
stampa_righe(Riga, MaxRighe, Colonne) :-
    Riga =< MaxRighe,
    format('~|~` t~2d~2+', [Riga]),
    write('|'),
    stampa_colonne(Riga, 1, Colonne),
    nl,
    NextRiga is Riga + 1,
    stampa_righe(NextRiga, MaxRighe, Colonne).
stampa_righe(_, _, _).

% Stampa tutte le colonne di una riga
stampa_colonne(_, Col, MaxCol) :- Col > MaxCol, !.
stampa_colonne(Riga, Col, MaxCol) :-
    ( occupata(pos(Riga, Col)) -> format(' X ');
      portale(pos(Riga, Col)) -> format(' P ');
      mostro(pos(Riga, Col)) -> format(' M ');
      gemma(pos(Riga, Col)) -> format(' G ');
      bloccoDiGhiaccio(pos(Riga, Col)) -> format(' B ');
      martello(pos(Riga, Col)) -> format(' H ');
      format(' O ')
    ),
    NextCol is Col + 1,
    stampa_colonne(Riga, NextCol, MaxCol).

% Esegui il programma di esempio
esegui :-
    leggi_file('labirinto.txt'),
    stampa_labirinto.

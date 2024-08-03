:- dynamic(martello/1).
:- dynamic(bloccoDiGhiaccio/1).
:- dynamic(gemma/1).
:- dynamic(mostriciattolo/1).
:- dynamic(occupata/1).
:- dynamic(portale/1).
:- dynamic(num_colonne/1).
:- dynamic(num_righe/1).

num_colonne(8).
num_righe(8).

mostro(pos(1,1)).
portale(pos(4,8)).

%blocchi non abbattibili
occupata(pos(1,5)).
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

%posizione gemme
gemma(pos(1,7)).
gemma(pos(3,4)).
gemma(pos(8,8)).

%blocchi di ghiaccio
bloccoDiGhiaccio(pos(2,6)).
bloccoDiGhiaccio(pos(2,7)).
bloccoDiGhiaccio(pos(7,7)).

%posizione martello
martello(pos(8,2)).


/*

Labirinto 8x8:
     1  2  3  4  5  6  7  8
  +------------------------
0.01| M  O  O  O  X  O  G  O
0.02| O  X  O  O  O  B  B  X
0.03| O  O  O  G  O  O  O  X
0.04| O  O  O  X  X  O  O  P
0.05| X  O  O  O  X  O  O  O
0.06| O  X  O  O  O  O  O  O
0.07| O  X  O  O  O  X  B  O
0.08| O  H  X  O  O  O  O  G

*/

/*
num_colonne(4).
num_righe(4).

mostro(pos(1,1)).
portale(pos(4,4)).

% blocchi non abbattibili
occupata(pos(2,2)).
occupata(pos(3,3)).

% posizione gemme
gemma(pos(2,3)).

% blocchi di ghiaccio
bloccoDiGhiaccio(pos(2,4)).

% posizione martello
martello(pos(3,1)).

  1 2 3 4
1 M - - -
2 - X G I
3 H - X -
4 - - - P

*/












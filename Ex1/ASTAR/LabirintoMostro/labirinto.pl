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
occupata(pos(1,5)).  %(R,C)
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
occupata(pos(5,1)).

%posizione gemme
gemma(pos(1,7)).
gemma(pos(5,4)).
gemma(pos(8,8)).

%blocchi di ghiaccio
bloccoDiGhiaccio(pos(2,6)).
bloccoDiGhiaccio(pos(2,7)).
bloccoDiGhiaccio(pos(7,7)).

%posizione martello
martello(pos(8,2)).











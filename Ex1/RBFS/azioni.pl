applicabile(nord,pos(R,C)):-
R > 1,  %applicabile se la riga non è la prima (perchè non posso salire)
RSopra is R-1,  %nuova variabile e assegnamento
\+occupata(pos(RSopra,C)). %posso muovermi se la cella sopra la mia non è occupata e mi muoverò in su di una riga restanto nella stessa colonna

applicabile(sud,pos(R,C)):-
num_righe(N),   %prendo predicato da labirinto.pl
R < N,  %N corrisponde all'ultima riga (in questo caso è come scrivere R < 10)
RSotto is R+1,  %nuova variabile e assegnamento
\+occupata(pos(RSotto,C)).  %posso muovermi se la cella sotto la mia non è occupata e mi muoverò in giù di una riga restanto nella stessa colonna

applicabile(est,pos(R,C)):-
num_colonne(N), %prendo predicato da labirinto.pl 
 C < N, %N corrisponde all'ultima colonna (in questo caso è come scrivere C < 10)     
 CDestra is C+1, %nuova variabile e assegnamento   
 \+occupata(pos(R,CDestra)).    %posso muovermi se la cella alla mia destra non è occupata e mi muoverò a destra di una colonna restanto nella stessa riga

applicabile(ovest,pos(R,C)):-
 C > 1, %applicabile se la colonna non è la prima 
 CSinistra is C-1,  %nuova variabile e assegnamento
 \+occupata(pos(R,CSinistra)).  %posso muovermi se la cella alla mia sinistra non è occupata e mi muoverò a sinistra di una colonna restanto nella stessa riga

%Applichiamo un'azione a uno stato e mostra il nuovo stato (il controllo non viene fatto perchè lo fa già applicabile)
trasforma(est,pos(R,C),pos(R,CDestra)):-CDestra is C+1.     
trasforma(ovest,pos(R,C),pos(R,CSinistra)):-CSinistra is C-1.
trasforma(nord,pos(R,C),pos(RSopra,C)):-RSopra is R-1.
trasforma(sud,pos(R,C),pos(RSotto,C)):-RSotto is R+1.
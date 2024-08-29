applicabile(nord,pos(R,C)):-
  R > 1,
  RSopra is R-1,
  \+occupata(pos(RSopra,C)),
  !.

applicabile(sud,pos(R,C)):-
  num_righe(N),
  R < N,
  RSotto is R+1,
  \+occupata(pos(RSotto,C)),
  !.

applicabile(est,pos(R,C)):-
  num_colonne(N),
  C < N,
  CDestra is C+1,
  \+occupata(pos(R,CDestra)),
  !.

applicabile(ovest,pos(R,C)):-
  C > 1,
  CSinistra is C-1,
  \+occupata(pos(R,CSinistra)),
  !.


%Applichiamo un'azione a uno stato e mostra il nuovo stato (il controllo non viene fatto perchè lo fa già applicabile)
trasforma(est,pos(R,C),pos(R,CDestra)):-CDestra is C+1.     
trasforma(ovest,pos(R,C),pos(R,CSinistra)):-CSinistra is C-1.
trasforma(nord,pos(R,C),pos(RSopra,C)):-RSopra is R-1.
trasforma(sud,pos(R,C),pos(RSotto,C)):-RSotto is R+1.

iniziale(pos(1,1)).
finale(pos(2,2)).

num_colonne(2).
num_righe(2).

occupata(pos(1,2)).

% Funzione per inserire un nodo in una lista mantenendola ordinata in base a HValue.
inserisci_ordinato((NuovoNodo, FLimit, FValue, CamminoAttuale), [], [(NuovoNodo, FLimit, FValue, CamminoAttuale)]).  % Se la lista di input è vuota, l'output è una lista con il solo elemento.

inserisci_ordinato((NuovoNodo, FLimit, FValue, CamminoAttuale), [(VecchioNuovoNodo, FLimit_2, FValue_2, VecchioCamminoAttuale)|Tail], [(NuovoNodo, FLimit, FValue, CamminoAttuale), (VecchioNuovoNodo, FLimit_2, FValue_2, VecchioCamminoAttuale) | Tail]) :-
  
  FValue =< FValue_2.  % Se HValue è minore o uguale al primo elemento della lista, metti il nuovo nodo prima.

inserisci_ordinato((NuovoNodo, FLimit, FValue, CamminoAttuale), [(VecchioNuovoNodo, FLimit_2, FValue_2, VecchioCamminoAttuale)|Tail], [(VecchioNuovoNodo, FLimit_2, FValue_2, VecchioCamminoAttuale) | NuovaListaNuoviNodi]) :-
  
  FValue > FValue_2,  % Se HValue è maggiore del primo elemento della lista, inserisci nel resto della lista.
  
  inserisci_ordinato((NuovoNodo, FLimit, FValue, CamminoAttuale), Tail, NuovaListaNuoviNodi).

euristica(pos(R1,C1), pos(R2,C2), HValue):-
  DistanzaR is abs(R1 - R2),
  DistanzaC is abs(C1 - C2),
  HValue is DistanzaR + DistanzaC.

costo(_,_,Costo) :- Costo is 1.

rbfs(Cammino):-
  iniziale(NodoIniziale),
  
  finale(NodoFinale),
  
  euristica(NodoIniziale, NodoFinale, HValue),
  
  FLimit = inf,

  FlagConfronto = 0,
  
  rbfs_aux((NodoIniziale, FLimit, HValue, [NodoIniziale|CamminoAttuale]), NodoFinale, CamminoFinale, Cammino, FValueRitornato, FlagConfronto),

  stampa_lista(Cammino).


stampa_lista([]).

stampa_lista([H|T]) :-
  
  write(H), nl,
  
  stampa_lista(T).


% Caso in cui siamo arrivati a destinazione
rbfs_aux((Nodo,_,_,_), Nodo, CamminoFinale, CamminoFinale, _, _):- finale(Nodo),!. %caso base

% Caso in cui non ci sono successori possibili
rbfs_aux((Nodo,_,_,_), _, _, _, _, _):-
  
  findall(Az,applicabile(Az,Nodo),ListaAzioni),
  
  ListaAzioni = [],

  !, fail. % The list of actions is empty

% Caso ricorsivo 
rbfs_aux((Nodo, FLimit, FValue, CamminoAttuale), NodoFinale, CamminoFinale, CamminoFinaleRitornato, FValueAlternativo, FlagConfronto):-

  findall(Az,applicabile(Az,Nodo),ListaAzioni),

  impostaFValue(Nodo, NodoFinale, CamminoAttuale, ListaAzioni, ListaNuoviNodi, ListaNuoviNodi),

  aggiornaFValueWrapper(ListaNuoviNodi, FValueAlternativo, FlagConfronto, ListaNuoviNodiAggiornata),

  estraiValoriPrimoNodo(ListaNuoviNodiAggiornata, FValueMin, PrimoNodoMigliore, CamminoNodoMinore),
  
  confrontaFValueFLimit(FValueMin, Flimit),

  estraiFValueMinoreAlternativo(ListaNuoviNodiAggiornata, FValueMinAlternativo),

  NuovoCamminoFinale = [PrimoNodoMigliore|CamminoFinale],

  rbfs_aux((PrimoNodoMigliore, FValueMinAlternativo, FValueMin, CamminoNodoMinore), NodoFinale, NuovoCamminoFinale, CamminoFinaleRitornato, FValueAlternativo, FlagConfronto).
  

impostaFValue(_, _, _, [], ListaNuoviNodi, ListaNuoviNodi). % Caso base: nessuna azione da applicare.

impostaFValue(Nodo, NodoFinale, CamminoAttuale, [Az|ListaAzioniTail], ListaNuoviNodi, RisultatoListaNuoviNodi):- 
  
  trasforma(Az, Nodo, NuovoNodo),

  costo(Nodo, NuovoNodo, Costo),
  
  length(CamminoAttuale, GValue),
  
  NuovoGValue is GValue + Costo,
  
  euristica(NuovoNodo, NodoFinale, HValue),
  
  FValue is NuovoGValue + HValue,
  
  inserisci_ordinato((NuovoNodo, FLimit, FValue, [NuovoNodo|CamminoAttuale]), ListaNuoviNodi, NuovaListaNuoviNodi),
  
  impostaFValue(Nodo, NodoFinale, CamminoAttuale, ListaAzioniTail, NuovaListaNuoviNodi, RisultatoListaNuoviNodi).

aggiornaFValueWrapper([(Nodo, FLimit, _ , CamminoAttuale)|ListaNuoviNodi], FValueAlternativo, FlagConfronto, ListaNuoviNodiAggiornata):-
  
  \+aggiornaFValue([(Nodo, FLimit, _ , CamminoAttuale)|ListaNuoviNodi], FValueAlternativo, FlagConfronto, ListaNuoviNodiAggiornata),!.
      
aggiornaFValue([(Nodo, FLimit, _ , CamminoAttuale)|ListaNuoviNodi], FValueAlternativo, FlagConfronto, ListaNuoviNodiAggiornata):-
  
  FlagConfronto = 1,
  
  inserisci_ordinato((Nodo, FLimit, FValueAlternativo, CamminoAttuale), ListaNuoviNodi, ListaNuoviNodiAggiornata).


estraiValoriPrimoNodo([(PrimoNodo, _, FValue, CamminoNodo)|ListaNuoviNodiAggiornata], FValue, PrimoNodo, CamminoNodo).

confrontaFValueFLimit(FValue, Flimit):-
  
  \+fValueMaggioreFLimit(FValue, FLimit).

fValueMaggioreFLimit(FValue, FLimit):-
  
  FLimit =< FValue,  % assegna il valore di FValue a FValueMin
  
  FlagConfronto = 1,   % assegna il valore 1 a FlagConfronto
  
  assert(fValueMin(FValueRitornato)), 
  
  assert(flagConfronto(FlagConfronto)), 
  
  fail.

estraiFValueMinoreAlternativo([_], inf) :- !.

estraiFValueMinoreAlternativo([_, (_, _, FValueAlternativo, _)|ListaNuoviNodi], FValueAlternativo).


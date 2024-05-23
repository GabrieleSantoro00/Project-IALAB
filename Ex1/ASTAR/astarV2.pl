:- ['azioni'], ['labirinto'].

astar(Cammino) :-
  iniziale(NodoIniziale),
  finale(NodoFinale),
  euristica(NodoIniziale, NodoFinale, Euristica),
  astar_aux([(Euristica, NodoIniziale, [])], [], NodoFinale, CamminoRovesciato),
  reverse(CamminoRovesciato, Cammino).

astar_aux([(_ ,Nodo,Cammino)|_] _, _, CamminoFinale) :-
  finale(Nodo),!.
astar_aux([(Euristica,Nodo,Cammino)|Coda], Visitati, NodoFinale, CamminoFinale) :-
  \+member(Nodo, Visitati),
  findall(Az,applicabile(Az,Nodo),ListaAzioni),
  generaNuoviStati(Nodo,ListaAzioni,ListaNuoviStati),
  bestNuovoStato(ListaNuoviStati,NodoFinale,ProssimoStato),
  append(ListaNuoviStati,Visitati,NuoviVisitati),
  append(ListaNuoviStati,Coda,NuovaCoda),
  astar_aux(NuovaCoda,NuoviVisitati,NodoFinale,CamminoFinale).

astar_aux([_|Coda], Visitati, NodoFinale, CamminoFinale) :-
  astar_aux(Coda, Visitati, NodoFinale, CamminoFinale).

generaNuoviStati(_,[],[]).
generaNuoviStati(S,[Az|AzioniTail],NuoviStati):-
    trasforma(Az,S,SNuovo),
    
    generaNuoviStati(S,AzioniTail,NuoviStati).

bestNuovoStato(ListaStati,NodoFinale,ProssimoStato):-
  valutazioneStati(ListaStati,NodoFinale,ValutazioneStati),
  min_list(ValutazioneNuoviStati,Minimo).
  
valutazioneStati([(Nodo,Cammino)|ListaStatiTail],NodoFinale,ValutazioneStati):-
  euristica(Nodo, NodoFinale, H),
  length(Cammino, G),
  F is G + H,
  ValutazioniNuoviStati = [F|Tail],
  valutazioneStati(ListaStatiTail,NodoFinale,ValutazioneNuoviStati).

euristica(pos(R1,C1), pos(R2,C2), Valore) :-
    DistanzaR is abs(R1 - R2),
    DistanzaC is abs(C1 - C2),
    Valore is DistanzaR + DistanzaC.







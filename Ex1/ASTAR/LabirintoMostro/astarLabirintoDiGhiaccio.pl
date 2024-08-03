:- ['azioni'], ['labirinto.pl'], ['stampaLabirinto'].
:- set_prolog_flag(answer_write_options, [max_depth(0)]).

astar(Cammino) :-
  esegui(),
  iniziale(StatoIniziale),
  finale(StatoFinale),
  euristica(StatoIniziale, StatoFinale, H),
  G is 0,
  F is H + G,
  astar_aux([(F, H, StatoIniziale, [])], [], StatoFinale, CamminoRovesciato),
  inverti(CamminoRovesciato, Cammino).


euristica((pos(R1, C1), _, _, _, _), pos(R2, C2), Valore) :-
  DistanzaR is abs(R1 - R2),
  DistanzaC is abs(C1 - C2),
  Valore is DistanzaR + DistanzaC.


astar_aux([( _, _, Stato, Cammino)| _], _, StatoFinale, Cammino) :-
  writeln(''), writeln('Stato:'), writeln(Stato),
  writeln(''), writeln('Cammino:'), writeln(Cammino),
  arrivoAlPortale(Stato),!.
astar_aux([(F, H, Stato, Cammino)| Coda], Visitati, StatoFinale, CamminoFinale) :-
  %writeln(''), writeln('Stato:'), writeln(Stato),
  %writeln(''), writeln('Generazione nuovi stati:'),
  generaNuoviStati((Stato, Cammino), ListaNuoviStati), %writeln('ListaNuoviStati: '), writeln(ListaNuoviStati),
  %writeln(''), writeln('Confronto con stati già visitati:'),
  differenza(ListaNuoviStati, Visitati, ListaNuoviStatiDaVisitare), %writeln('ListaNuoviStatiDaVisitare: '), writeln(ListaNuoviStatiDaVisitare),
  %writeln(''), writeln('Calcolo F per nuovi stati:'),
  calcolaFNuoviStati(ListaNuoviStatiDaVisitare, StatoFinale, ListaNuoviStatiConF), %writeln('ListaNuoviStatiConF: '), writeln(ListaNuoviStatiConF),
  %writeln(''), writeln('Inserimento ordinato:'),
  inserisci_lista_ordinata(ListaNuoviStatiConF, Coda, NuovaCoda),
  %writeln(''), writeln('Aggiornamento stati visitati:'),
  append(ListaNuoviStatiDaVisitare, Visitati, NuoviVisitati), 
  %writeln(''), writeln('Prossimi stati:'), writeln(NuovaCoda),
  astar_aux(NuovaCoda, [(Stato, Cammino) | NuoviVisitati], StatoFinale, CamminoFinale).


generaNuoviStati((Stato, Cammino), ListaNuoviStati) :-
  muovi_tutte_le_direzioni((Stato, Cammino), ListaNuoviStati).


differenza([], _, []).
differenza([(Stato, Cammino) | Tail], Visitati, Risultato) :-
    member((Stato, _), Visitati), !,
    differenza(Tail, Visitati, Risultato).
differenza([(Stato, Cammino) | Tail], Visitati, [(Stato, Cammino) | RisTail]) :-
    differenza(Tail, Visitati, RisTail).


calcolaFNuoviStati([], _, []).
calcolaFNuoviStati([(Stato, Cammino) | Coda], StatoFinale, [(F, H, Stato, Cammino) | ListaNuoviStatiConF]) :-
  euristica(Stato, StatoFinale, H),
  length(Cammino, G),
  F is G + H,
  calcolaFNuoviStati(Coda, StatoFinale, ListaNuoviStatiConF).

inserisci_ordinato(E, [], [E]).
inserisci_ordinato((F, H, Stato, Cammino), [(F1, H1, Stato1, Cammino1) | Coda], [(F, H, Stato, Cammino), (F1, H1, Stato1, Cammino1) | Coda]) :-
  F =< F1.
inserisci_ordinato((F, H, Stato, Cammino), [(F1, H1, Stato1, Cammino1) | Coda], [(F1, H1, Stato1, Cammino1) | ListaOrdinata]) :-
  F > F1,
  inserisci_ordinato((F, H, Stato, Cammino), Coda, ListaOrdinata).


inserisci_lista_ordinata([], Lista, Lista).
inserisci_lista_ordinata([E | Es], Lista, ListaOrdinata) :-
  inserisci_ordinato(E, Lista, ListaTemp),
  inserisci_lista_ordinata(Es, ListaTemp, ListaOrdinata).


inverti(Lista, ListaInvertita) :-
  inverti(Lista, [], ListaInvertita).
inverti([], Accumulatore, Accumulatore).
inverti([Testa|Coda], Accumulatore, ListaInvertita) :-
  inverti(Coda, [Testa|Accumulatore], ListaInvertita).
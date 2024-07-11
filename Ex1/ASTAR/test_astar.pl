:- ['azioni'], ['labirinto1280x1280'], ['stampaLabirinto'].
:- set_prolog_flag(answer_write_options, [max_depth(0)]).

astar(Cammino) :-
    iniziale(NodoIniziale),
    finale(NodoFinale),
    euristica(NodoIniziale, NodoFinale, H),
    G is 0,
    F is H + G,
    astar_aux([(F, H, NodoIniziale, [])], [], NodoFinale, CamminoRovesciato),
    inverti(CamminoRovesciato, Cammino).

euristica(pos(R1, C1), pos(R2, C2), Valore) :-
    DistanzaR is abs(R1 - R2),
    DistanzaC is abs(C1 - C2),
    Valore is DistanzaR + DistanzaC.

astar_aux([( _, _, Nodo, Cammino)| _], _, NodoFinale, Cammino) :-finale(Nodo),!.
astar_aux([(F, H, Nodo, Cammino)|Coda], Visitati, NodoFinale, CamminoFinale) :-
    findall(Azione, applicabile(Azione, Nodo), ListaAzioni),
    generaNuoviStati([(Nodo, Cammino)], ListaAzioni, ListaNuoviStati),
    differenza(ListaNuoviStati, Visitati, ListaNuoviStatiDaVisitare),
    calcolaFNuoviStati(ListaNuoviStatiDaVisitare, NodoFinale, ListaNuoviStatiConF),
    inserisci_lista_ordinata(ListaNuoviStatiConF, Coda, NuovaCoda),
    append(ListaNuoviStatiDaVisitare, Visitati, NuoviVisitati),
    astar_aux(NuovaCoda, [(Nodo, Cammino) | NuoviVisitati], NodoFinale, CamminoFinale).


generaNuoviStati(_, [], []).
generaNuoviStati([(Nodo, Cammino)], [Azione | AzioniTail], [(NodoGenerato, [Azione | Cammino]) | NuoviStatiTail]) :-
    trasforma(Azione, Nodo, NodoGenerato),
    generaNuoviStati([(Nodo, Cammino)], AzioniTail, NuoviStatiTail).


differenza([], _, []).
differenza([(Nodo, _) | Tail], Visitati, Risultato) :-
    member((Nodo, _), Visitati), !,
    differenza(Tail, Visitati, Risultato).
differenza([(Nodo, Cammino) | Tail], Visitati, [(Nodo, Cammino) | RisTail]) :-
    differenza(Tail, Visitati, RisTail).
  

calcolaFNuoviStati([], _, []).
calcolaFNuoviStati([(Nodo, Cammino) | Coda], NodoFinale, [(F, H, Nodo, Cammino) | ListaNuoviStatiConF]) :-
    euristica(Nodo, NodoFinale, H),
    length(Cammino, G),
    F is G + H,
    calcolaFNuoviStati(Coda, NodoFinale, ListaNuoviStatiConF).

inserisci_ordinato(E, [], [E]).
inserisci_ordinato((F, H, Nodo, Cammino), [(F1, H1, Nodo1, Cammino1) | Coda], [(F, H, Nodo, Cammino), (F1, H1, Nodo1, Cammino1) | Coda]) :-
    F =< F1.
inserisci_ordinato((F, H, Nodo, Cammino), [(F1, H1, Nodo1, Cammino1) | Coda], [(F1, H1, Nodo1, Cammino1) | ListaOrdinata]) :-
    F > F1,
    inserisci_ordinato((F, H, Nodo, Cammino), Coda, ListaOrdinata).

inserisci_lista_ordinata([], Lista, Lista).
inserisci_lista_ordinata([E | Es], Lista, ListaOrdinata) :-
    inserisci_ordinato(E, Lista, ListaTemp),
    inserisci_lista_ordinata(Es, ListaTemp, ListaOrdinata).

inverti(Lista, ListaInvertita) :-
    inverti(Lista, [], ListaInvertita).

inverti([], Accumulatore, Accumulatore).
inverti([Testa|Coda], Accumulatore, ListaInvertita) :-
    inverti(Coda, [Testa|Accumulatore], ListaInvertita).

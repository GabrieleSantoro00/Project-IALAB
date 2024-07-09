:- ['azioni'], ['labirinto'].


astar(Cammino) :-
    iniziale(NodoIniziale),
    finale(NodoFinale),
    euristica(NodoIniziale, NodoFinale, H),
    G is 0,
    F is H + G,
    astar_aux([(F, H, NodoIniziale, [])], [], NodoFinale, CamminoRovesciato),
    inverti(CamminoRovesciato, Cammino).


euristica(pos(R1,C1), pos(R2,C2), Valore) :-
    DistanzaR is abs(R1 - R2),
    DistanzaC is abs(C1 - C2),
    Valore is DistanzaR + DistanzaC.


astar_aux([( _, _, Nodo, Cammino)| _ ], _, NodoFinale, Cammino) :-
    finale(Nodo),
    Nodo = NodoFinale, !.
astar_aux([(F, H, Nodo, Cammino)| Coda], Visitati, NodoFinale, CamminoFinale) :-
    \+ member(Nodo, Visitati),
    findall(Az, applicabile(Az, Nodo), ListaAzioni),
    generaNuoviStati(Nodo, ListaAzioni, ListaNuoviStati),
    calcolaFNuoviStati(ListaNuoviStati, NodoFinale, ListaNuoviStatiConF),
    inserisci_lista_ordinata(ListaNuoviStatiConF, Coda, NuovaCoda),
    astar_aux(NuovaCoda, [Nodo | Visitati], NodoFinale, CamminoFinale).


generaNuoviStati(_, [], []).
generaNuoviStati(Nodo, [Az | AzioniTail], [(F, H, NodoGenerato, [Az | Cammino]) | NuoviStatiTail]) :-
    trasforma(Az, Nodo, NodoGenerato),
    generaNuoviStati(Nodo, AzioniTail, NuoviStatiTail).


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


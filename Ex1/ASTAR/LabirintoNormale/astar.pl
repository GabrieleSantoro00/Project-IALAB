:- ['azioni'], ['labirinto_test.pl'], ['stampaLabirinto'].
:- set_prolog_flag(answer_write_options, [max_depth(0)]).

astar(Cammino) :-
    iniziale(NodoIniziale),
    findall(NodoFinale, finale(NodoFinale), ListaNodiFinale),
    euristica(NodoIniziale, ListaNodiFinale, H),
    G is 0,
    F is H + G,
    astar_aux([(F, H, NodoIniziale, [])], [], ListaNodiFinale, CamminoRovesciato),
    inverti(CamminoRovesciato, Cammino),
    esegui().


euristica(Nodo, ListaNodiFinali, Valore) :-
    findall(H, (member(NodoFinale, ListaNodiFinali), distanza(Nodo, NodoFinale, H)), Distanze),
    min_list(Distanze, Valore).


distanza(pos(R1, C1), pos(R2, C2), Valore) :-
    DistanzaR is abs(R1 - R2),
    DistanzaC is abs(C1 - C2),
    Valore is DistanzaR + DistanzaC.


astar_aux([( _, _, Nodo, Cammino)| _], _, ListaNodiFinale, Cammino) :-member(Nodo, ListaNodiFinale),!.
astar_aux([(F, H, Nodo, Cammino)|Coda], Visitati, ListaNodiFinale, CamminoFinale) :-
    findall(Azione, applicabile(Azione, Nodo), ListaAzioni),
    generaNuoviStati([(Nodo, Cammino)], ListaAzioni, ListaNuoviStati),
    differenza(ListaNuoviStati, Visitati, ListaNuoviStatiDaVisitare),
    calcolaFNuoviStati(ListaNuoviStatiDaVisitare, ListaNodiFinale, ListaNuoviStatiConF),
    inserisci_lista_ordinata(ListaNuoviStatiConF, Coda, NuovaCoda),
    append(ListaNuoviStatiDaVisitare, Visitati, NuoviVisitati),
    astar_aux(NuovaCoda, [(Nodo, Cammino) | NuoviVisitati], ListaNodiFinale, CamminoFinale).


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
calcolaFNuoviStati([(Nodo, Cammino) | Coda], ListaNodiFinale, [(F, H, Nodo, Cammino) | ListaNuoviStatiConF]) :-
    costo(_, _, IncrementoG),
    length(Cammino, LunghezzaCammino),
    G is LunghezzaCammino + IncrementoG,
    euristica(Nodo, ListaNodiFinale, H),
    F is G + H,
    calcolaFNuoviStati(Coda, ListaNodiFinale, ListaNuoviStatiConF).


costo(_,_,Costo) :- Costo is 1.


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

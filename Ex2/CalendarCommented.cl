%   Definizione delle squadre
squadra(inter; milan; torino; roma; napoli; fiorentina; atalanta; bologna; genoa; udinese; lecce; sassuolo; cagliari; verona; como; frosinone).

%   Definizione di 30 giornate
giornata(1..30).

%   Definizione di 15 partite di andata (una squadra gioca 1 volta in casa e 1 in trasferta contro tutte le altre squadre)
15  {partitaInCasa(Squadra1, Squadra2) : squadra(Squadra2)}  15 :- squadra(Squadra1).
%   Per ogni Squadra1 che è una squadra, ci devono essere esattamente 15 partitaInCasa(Squadra1, Squadra2)  dove Squadra2 è una squadra.

%   Definizione delle restanti partite in trasferta
partitaInTrasferta(Squadra2, Squadra1) :- partitaInCasa(Squadra1, Squadra2).
%   p artitaInTrasferta(Squadra2, Squadra1) è vero se partitaInCasa(Squadra1, Squadra2) è vero.

%   Definizione delle citta
citta(milano; torino; roma; napoli; firenze; bergamo; bologna; genova; udine; lecce; reggio_emilia; cagliari; verona; como; frosinone).

%   Associazione delle squadre con la citta di riferimento
dove(inter, milano).
dove(milan, milano).
dove(torino, torino).
dove(roma, roma).
dove(napoli, napoli).
dove(fiorentina, firenze).
dove(atalanta, bergamo).
dove(bologna, bologna).
dove(genoa, genova).
dove(udinese, udine).
dove(lecce, lecce).
dove(sassuolo, reggio_emilia).
dove(cagliari, cagliari).
dove(verona, verona).
dove(como, como).
dove(frosinone, frosinone).

%   Una squadra non può giocare contro sé stessa
:-  squadra(Squadra), partitaInCasa(Squadra, Squadra).
:-  squadra(Squadra), partitaInTrasferta(Squadra, Squadra).
%   Con il vincolo di integrità ciò che è presente nel corpo regola non può essere contemporaneamente vero.

%   Una squadra gioca in casa nella giornata Giornata
giocaInCasa(Squadra1, Giornata) :-
    squadra(Squadra1), 
    giornata(Giornata),
    partita(Squadra1, Squadra2, Giornata).
%   Il predicato giocaInCasa(Squadra1, Giornata) è vero quando Squadra1 è una squadra, Giornata è una giornata e c'è una partita tra Squadra1 e Squadra2 nella giornata Giornata.

%   Una squadra gioca in trasferta nella giornata Giornata
giocaInTrasferta(Squadra1, Giornata) :-
    squadra(Squadra1),
    giornata(Giornata),
    partita(Squadra2, Squadra1, Giornata).

%   Definizione delle squadre della stessa citta
squadraStessaCitta(Squadra1, Squadra2) :-
    squadra(Squadra1),
    squadra(Squadra2),
    citta(Citta),
    Squadra1 <> Squadra2,       % <> è il simbolo di disuguaglianza
    dove(Squadra1, Citta),
    dove(Squadra2, Citta).

%   Una partita si gioca in un solo giorno
1   {partita(Squadra1, Squadra2, Giornata) : giornata(Giornata)}   1 :- 
    partitaInCasa(Squadra1, Squadra2), 
    Squadra1 <> Squadra2,
    partitaInTrasferta(Squadra2, Squadra1).
%   Deve esserci esattamente una partita(Squadra1, Squadra2, Giornata) per ogni giornata(Giornata) se:
%   partitaInCasa(Squadra1, Squadra2) è vero (cioè, Squadra1 gioca in casa contro Squadra2),
%   Squadra1 <> Squadra2 (cioè, Squadra1 e Squadra2 sono squadre diverse),
%   partitaInTrasferta(Squadra2, Squadra1) è vero (cioè, Squadra2 gioca in trasferta contro Squadra1).

%   Due squadre che appartengono alla stessa citta e condividono la stessa struttura di gioco non possono giocare entrambe in casa nella stessa giornata.
giocaInTrasferta(Squadra1, Giornata) :-
    squadra(Squadra1),
    squadra(Squadra2),
    giornata(Giornata),
    squadraStessaCitta(Squadra1, Squadra2),
    Squadra1 <> Squadra2, 
    giocaInCasa(Squadra2, Giornata). 
%   Squadra1 gioca in trasferta nella giornata Giornata se:
%   Squadra1 è una squadra,
%   Squadra2 è una squadra,
%   Giornata è una giornata valida,
%   Squadra1 e Squadra2 sono della stessa città,
%   Squadra1 e Squadra2 sono squadre diverse,
%   Squadra2 gioca in casa nella giornata Giornata.

%   Il derby è una partita giocata tra squadre della stessa citta
derby(Squadra1, Squadra2) :- 
    partita(Squadra1, Squadra2, Giornata), 
    Squadra1 <> Squadra2, 
    squadraStessaCitta(Squadra1, Squadra2).

%   Una squadra non gioca in casa 2 volte di fila
:-  squadra(Squadra1), partita(Squadra1, Squadra2, Giornata), partita(Squadra1, Squadra3, Giornata), Squadra1 <> Squadra2, Squadra2 <> Squadra3.

%   Una squadra non gioca in trasferta 2 volte di fila
:-  squadra(Squadra1), partita(Squadra2, Squadra1, Giornata), partita(Squadra3, Squadra1, Giornata), Squadra1 <> Squadra2, Squadra2 <> Squadra3.
%   Non è permesso che Squadra1 giochi due partite diverse (partita(Squadra1, Squadra2, Giornata) e partita(Squadra1, Squadra3, Giornata)) nella stessa giornata Giornata contro squadre diverse (Squadra2 e Squadra3).

%   Una squadra gioca o in casa o in trasferta, non entrambe
:-  squadra(Squadra1), giornata(Giornata), giocaInCasa(Squadra1, Giornata), giocaInTrasferta(Squadra1, Giornata).
%   Non è permesso che Squadra1 giochi in casa e in trasferta nella stessa giornata Giornata.

%   ---------------------------------------------------------------------------------------------
%   I due vincoli successivi sono stati aggiunti per distribuire equamente le partite tra le varie giornate

%   In una giornata (Giornata), ci sono esattamente 8 squadre in casa
8  {giocaInCasa(Squadra, Giornata) : squadra(Squadra)}  8 :- giornata(Giornata).
%   Per ogni giornata (Giornata), esattamente 8 squadre (Squadra) devono giocare in casa (giocaInCasa(Squadra, Giornata)).

%   In una giornata (Giornata), ci sono esattamente 8 squadre in trasferta
8  {giocaInTrasferta(Squadra, Giornata) : squadra(Squadra)}  8 :- giornata(Giornata).
%   ---------------------------------------------------------------------------------------------

%   RISULTATI
risultato(Squadra1, Squadra2, Giornata, Citta) :-
    partita(Squadra1, Squadra2, Giornata),
    dove(Squadra1, Citta).

#show risultato/4.

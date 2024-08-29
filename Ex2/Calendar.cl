%   Definizione delle squadre
squadra(inter; milan; juventus; torino; roma; lazio; napoli; fiorentina; atalanta; bologna; genoa; udinese; lecce; sassuolo; cagliari; verona).

%   Definizione di 30 giornate
giornata(1..30).

%   Definizione di 15 partite di andata (una squadra gioca 1 volta in casa e 1 in trasferta contro tutte le altre squadre)
15  {partitaInCasa(Squadra1, Squadra2) : squadra(Squadra2)}  15 :- squadra(Squadra1).
    
%   Definizione delle restanti partite in trasferta
partitaInTrasferta(Squadra2, Squadra1) :- partitaInCasa(Squadra1, Squadra2).

%   Definizione del concetto di citta
citta(milano; torino; roma; napoli; firenze; bergamo; bologna; genova; udine; lecce; reggio_emilia; cagliari; verona).

%   Associazione delle squadre con la citta di riferimento
provieneDa(inter, milano).
provieneDa(milan, milano).
provieneDa(juventus, torino).
provieneDa(torino, torino).
provieneDa(roma, roma).
provieneDa(lazio, roma).
provieneDa(napoli, napoli).
provieneDa(fiorentina, firenze).
provieneDa(atalanta, bergamo).
provieneDa(bologna, bologna).
provieneDa(genoa, genova).
provieneDa(udinese, udine).
provieneDa(lecce, lecce).
provieneDa(sassuolo, reggio_emilia).
provieneDa(cagliari, cagliari).
provieneDa(verona, verona).

%   In una giornata (Giornata), ci sono esattamente 8 squadre in casa
8  {giocaInCasa(Squadra, Giornata) : squadra(Squadra)}  8 :- giornata(Giornata).

%   In una giornata (Giornata), ci sono esattamente 8 squadre in trasferta
8  {giocaInTrasferta(Squadra, Giornata) : squadra(Squadra)}  8 :- giornata(Giornata).

%   Una squadra non può giocare contro sé stessa
:-  squadra(Squadra), partitaInCasa(Squadra, Squadra).
:-  squadra(Squadra), partitaInTrasferta(Squadra, Squadra).

%   Una squadra gioca in casa nella giornata Giornata
giocaInCasa(Squadra1, Giornata) :-
    squadra(Squadra1), 
    giornata(Giornata),
    partita(Squadra1, Squadra2, Giornata).

%   Una squadra gioca in trasferta nella giornata Giornata
giocaInTrasferta(Squadra1, Giornata) :-
    squadra(Squadra1),
    giornata(Giornata),
    partita(Squadra2, Squadra1, Giornata).

%   Definizione delle squadre della stessa citta
dallaStessaCitta(Squadra1, Squadra2) :-
    squadra(Squadra1),
    squadra(Squadra2),
    citta(Citta),
    Squadra1 <> Squadra2, 
    provieneDa(Squadra1, Citta),
    provieneDa(Squadra2, Citta).

%   Una partita si gioca in un solo giorno
1   {partita(Squadra1, Squadra2, Giornata) : giornata(Giornata)}   1 :- 
    partitaInCasa(Squadra1, Squadra2), 
    Squadra1 <> Squadra2,
    partitaInTrasferta(Squadra2, Squadra1).

%   Due squadre che appartengono alla stessa citta e condividono la stessa struttura di gioco non possono giocare entrambe in casa nella stessa giornata.
giocaInTrasferta(Squadra1, Giornata) :-
    squadra(Squadra1),
    squadra(Squadra2),
    giornata(Giornata),
    dallaStessaCitta(Squadra1, Squadra2),
    Squadra1 <> Squadra2, 
    giocaInCasa(Squadra2, Giornata). 

%   Il derby è una partita giocata tra squadre della stessa citta
derby(Squadra1, Squadra2) :- 
    partita(Squadra1, Squadra2, Giornata), 
    Squadra1 <> Squadra2, 
    dallaStessaCitta(Squadra1, Squadra2).

%   Una squadra non gioca in casa 2 volte di fila
:-  squadra(Squadra1), partita(Squadra1, Squadra2, Giornata), partita(Squadra1, Squadra3, Giornata), Squadra1 <> Squadra2, Squadra2 <> Squadra3.

%   Una squadra non gioca in trasferta 2 volte di fila
:-  squadra(Squadra1), partita(Squadra2, Squadra1, Giornata), partita(Squadra3, Squadra1, Giornata), Squadra1 <> Squadra2, Squadra2 <> Squadra3.

%   Una squadra gioca o in casa o in trasferta, non entrambe
:-  squadra(Squadra1), giornata(Giornata), giocaInCasa(Squadra1, Giornata), giocaInTrasferta(Squadra1, Giornata).

%   RISULTATI
risultato(Squadra1, Squadra2, Giornata, Citta) :-
    partita(Squadra1, Squadra2, Giornata),
    provieneDa(Squadra1, Citta).

#show risultato/4.

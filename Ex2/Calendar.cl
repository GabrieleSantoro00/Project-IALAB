% --------------------------- CONFIGURAZIONE CON 1 DERBY ---------------------------

% --------------------------- REQUISITO 1 ---------------------------
% 16 squadre iscritte

%   Definizione delle squadre
squadra(inter; milan; torino; roma; napoli; fiorentina; atalanta; bologna; genoa; udinese; lecce; sassuolo; cagliari; verona; como; frosinone).

% --------------------------- REQUISITO 2 ---------------------------
% 30 giornate, suddivise in 15 di andata e 15 di ritorno (non simmetriche)

%   Definizione di 30 giornate
giornata(1..30).

%   Definizione di 15 partite di andata (una squadra gioca 1 volta in casa e 1 in trasferta contro tutte le altre squadre)
15  {partitaInCasa(Squadra1, Squadra2) : squadra(Squadra2)}  15 :- squadra(Squadra1).
    
%   Definizione delle restanti partite in trasferta
partitaInTrasferta(Squadra2, Squadra1) :- partitaInCasa(Squadra1, Squadra2).

% --------------------------- REQUISITO 3 ---------------------------
% Ogni squadra fa riferimento a una città

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

% --------------------------- REQUISITO 4 ---------------------------
% Ogni squadra affronta tutte le altre squadre 1 volta in casa e 1 volta in trasferta

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

% --------------------------- REQUISITO 5 ---------------------------
% Le squadre che condividono la stessa struttura di gioco non possono giocare in casa durante la stessa giornata (a eccezione dei derby)

%   Definizione delle squadre della stessa citta
squadraStessaCitta(Squadra1, Squadra2) :-
    squadra(Squadra1),
    squadra(Squadra2),
    citta(Citta),
    Squadra1 <> Squadra2,       
    dove(Squadra1, Citta),
    dove(Squadra2, Citta).

%   Una partita si gioca in una sola giornata
1   {partita(Squadra1, Squadra2, Giornata) : giornata(Giornata)}   1 :- 
    partitaInCasa(Squadra1, Squadra2), 
    Squadra1 <> Squadra2,
    partitaInTrasferta(Squadra2, Squadra1).

%   Due squadre che appartengono alla stessa citta e condividono la stessa struttura di gioco non possono giocare entrambe in casa nella stessa giornata.
giocaInTrasferta(Squadra1, Giornata) :-
    squadra(Squadra1),
    squadra(Squadra2),
    giornata(Giornata),
    squadraStessaCitta(Squadra1, Squadra2),
    Squadra1 <> Squadra2, 
    giocaInCasa(Squadra2, Giornata). 

%   Il derby è una partita giocata tra squadre della stessa citta
derby(Squadra1, Squadra2) :- 
    partita(Squadra1, Squadra2, Giornata), 
    Squadra1 <> Squadra2, 
    squadraStessaCitta(Squadra1, Squadra2).

%  --------------------------- REQUISITO 6 ---------------------------
% Ciascuna squadra non può giocare più di 2 partite consecutive in casa o fuori casa.

%   Una squadra non gioca in casa 2 volte di fila
:-  squadra(Squadra1), partita(Squadra1, Squadra2, Giornata), partita(Squadra1, Squadra3, Giornata), Squadra1 <> Squadra2, Squadra2 <> Squadra3.

%   Una squadra non gioca in trasferta 2 volte di fila
:-  squadra(Squadra1), partita(Squadra2, Squadra1, Giornata), partita(Squadra3, Squadra1, Giornata), Squadra1 <> Squadra2, Squadra2 <> Squadra3.

%   Una squadra gioca o in casa o in trasferta, non entrambe
:-  squadra(Squadra1), giornata(Giornata), giocaInCasa(Squadra1, Giornata), giocaInTrasferta(Squadra1, Giornata).

% --------------------------- RISULTATI ---------------------------

risultato(Squadra1, Squadra2, Giornata, Citta) :-
    partita(Squadra1, Squadra2, Giornata),
    dove(Squadra1, Citta).

#show risultato/4.

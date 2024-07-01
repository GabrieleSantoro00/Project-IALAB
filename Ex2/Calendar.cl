% Squadre e città
squadra(atalanta; bologna; cagliari; empoli; fiorentina; frosinone; genoa; inter; juventus; lazio; lecce; milan; napoli; roma; salernitana; sassuolo). 
citta(bergamo; bologna; cagliari; empoli; firenze; frosinone; genova; milano; torino; roma; lecce; napoli; salerno; sassuolo).

% Partite in casa
partita_in_casa(atalanta, bergamo).
partita_in_casa(bologna, bologna).
partita_in_casa(cagliari, cagliari).
partita_in_casa(empoli, empoli).
partita_in_casa(fiorentina, firenze).
partita_in_casa(frosinone, frosinone).
partita_in_casa(genoa, genova).
partita_in_casa(inter, milano).
partita_in_casa(juventus, torino).
partita_in_casa(lazio, roma).
partita_in_casa(lecce, lecce).
partita_in_casa(milan, milano).
partita_in_casa(napoli, napoli).
partita_in_casa(roma, roma).
partita_in_casa(salernitana, salerno).
partita_in_casa(sassuolo, sassuolo).

% Partite in trasferta
partita_in_trasferta(S, C) :- squadra(S), citta(C), not partita_in_casa(S, C).

% Giorni
giorno(1..30).

% Nuova definizione delle partite per garantire che ogni squadra giochi contro ogni altra sia in casa che in trasferta
1 { partita(S1, S2, G) : giorno(G) } 1 :- squadra(S1), squadra(S2), S1 != S2.
1 { partita(S2, S1, G) : giorno(G) } 1 :- squadra(S1), squadra(S2), S1 != S2.

% Vincolo sulle partite consecutive in casa o trasferta
:- squadra(S), giorno(G), partita(S, _, G), partita(S, _, G+1), partita(S, _, G+2), partita_in_casa(S, _).
:- squadra(S), giorno(G), partita(_, S, G), partita(_, S, G+1), partita(_, S, G+2).

% Aggiustamento del vincolo sul numero massimo di partite per giorno per distribuire equamente le partite
:- giorno(G), #count{S1, S2 : partita(S1, S2, G)} > 8.

% Vincolo sulle partite in casa condivise nella stessa città
:- partita_in_casa(S1, C), partita_in_casa(S2, C), S1 != S2, giorno(G), partita(S1, _, G), partita(S2, _, G), not derby(S1, S2), not derby(S2, S1).

% Definizione dei derby
derby(inter, milan).
derby(milan, inter).
derby(lazio, roma).
derby(roma, lazio).

#show partita/3.
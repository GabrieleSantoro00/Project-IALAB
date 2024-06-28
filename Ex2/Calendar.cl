% Squadre e città
squadra(atalanta; bologna; cagliari; empoli; fiorentina; frosinone; genoa; inter; juventus; lazio; lecce; milan; napoli; roma; salernitana; sassuolo). 
citta(bergamo; bologna; cagliari; empoli; firenze; frosinone; genova; milano; torino; roma; lecce; napoli; salerno; sassuolo). 

% Ogni squadra ha una città di riferimento quando gioca in casa
1 {partita_in_casa(S, C) : citta(C)} 1 :- squadra(S).

%Associazioni tra squadre e città
squadra_atalanta(atalanta):- partita_in_casa(atalanta, bergamo).
squadra_bologna(bologna):- partita_in_casa(bologna, bologna).
squadra_cagliari(cagliari):- partita_in_casa(cagliari, cagliari).
squadra_empoli(empoli):- partita_in_casa(empoli, empoli).
squadra_fiorentina(fiorentina):- partita_in_casa(fiorentina, firenze).
squadra_frosinone(frosinone):- partita_in_casa(frosinone, frosinone).
squadra_genoa(genoa):- partita_in_casa(genoa, genova).
squadra_inter(inter):- partita_in_casa(inter, milano).
squadra_juventus(juventus):- partita_in_casa(juventus, torino).
squadra_lazio(lazio):- partita_in_casa(lazio, roma).
squadra_lecce(lecce):- partita_in_casa(lecce, lecce).
squadra_milan(milan):- partita_in_casa(milan, milano).
squadra_napoli(napoli):- partita_in_casa(napoli, napoli).
squadra_roma(roma):- partita_in_casa(roma, roma).
squadra_salernitana(salernitana):- partita_in_casa(salernitana, salerno).
squadra_sassuolo(sassuolo):- partita_in_casa(sassuolo, sassuolo).

% Permette a una squadra di giocare in trasferta in tutte le città tranne la sua città di casa
partita_in_trasferta(S, C) :- squadra(S), citta(C), not partita_in_casa(S, C).

% Giorni
giorno(1..30).

% Distinzione tra giornate di andata e giornate di ritorno
andata(G) :- giorno(G), G <= 15.
ritorno(G) :- giorno(G), G > 15.

% Definizione delle partite in casa e in trasferta con giorno specifico
1 { partita_in_casa(S1, S2, G) : squadra(S2), S1 != S2, giorno(G) } 1 :- squadra(S1).
1 { partita_in_trasferta(S1, S2, G) : squadra(S2), S1 != S2, giorno(G) } 1 :- squadra(S1).


% Le squadre con la stessa città di riferimento non possono giocare lo stesso giorno in casa (a eccezione dei derby)
:- partita_in_casa(S1, _, G), partita_in_casa(S2, _, G), S1 != S2, not derby(S1, S2), not derby(S2, S1).

% Definizione dei derby
derby(inter, milan).
derby(milan, inter).
derby(lazio, roma).
derby(roma, lazio).

% Non possono essere giocate mai più di 2 partite consecutive in casa o in trasferta
:- squadra(S), giorno(G), partita_in_casa(S, _, G), partita_in_casa(S, _, G+1), partita_in_casa(S, _, G+2).
:- squadra(S), giorno(G), partita_in_trasferta(S, _, G), partita_in_trasferta(S, _, G+1), partita_in_trasferta(S, _, G+2).

#show partita_in_casa/3.
#show partita_in_trasferta/3.
/*
TEST impostaFValue --> ok
input
impostaFValue(pos(1, 1), pos(3, 7), [nord, sud, est, ovest], ListaNuoviNodi, ListaFValue).
output
ListaNuoviNodi = [(pos(0, 1), _, _A), (pos(2, 1), _, _B), (pos(1, 2), _, _C), (pos(1, 0), _, _D)],
ListaFValue = [_A, _B, _C, _D] .


TEST inserisci_ordinato --> ok
input 
inserisci_ordinato((a, 0, 8), [(e, 0, 6), (i, 0, 7)], ListaOrdinata). 
output
ListaOrdinata = [(e, 0, 6), (i, 0, 7), (a, 0, 8)].


TEST generaNuoviNodi --> no
input
generaNuoviNodi(pos(1, 1), [nord, sud, est, ovest], ListaNuoviNodi).
output
false.

TEST generaFValue --> no
input
generaFValue([pos(1,1), pos(2,2), pos(3,3)], pos(5,5), ListaFValue).
output
ERROR: Unknown procedure: generaFValue/3 (DWIM could not correct goal)
*/


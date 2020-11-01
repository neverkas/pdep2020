dueno(andy, woody, 8).
dueno(sam, jessie, 3).

juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero))
juguete(buzz, deAccion(espacial, [original(casco)]).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(seniorCaraDePapa,caraDePapa([original(pieIzquierdo), original(pieDerecho), repuesto(nariz)])).

esRaro(deAccion(stacyMalibu, 1, [sombrero])).

esColeccionista(sam).

/*
1. a. tematica/2:
relaciona a un juguete con su temática.
La temática de los cara de papa escaraDePapa
*/

tematica(juguete(, deTrapo(Tematica)),Tematica).
tematica(juguete(, deTrapo(Tematica)),Tematica).
tematica(juguete(, deTrapo(Tematica)),Tematica).
tematica(juguete(, deTrapo(Tematica)),Tematica).
tematica(juguete(, deTrapo(Tematica)),Tematica).

tematica(Jugete, deTrapo(Tematica)).
tematica(Jugete, deAccion(Tematica, )).
tematica(Jugete, miniFiguras(Tematica, _)).
tematica(caraDePapa, caraDePapa).

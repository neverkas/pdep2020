% jugador(Nombre, PuntosVida, PuntosMana,  CartasMazo, CartasMano, CartasCampo)
jugador(jugador(carlos, 500, 500, [fuegoAncestral, curacion, zombies],  [zombies], [fuego, zombies])).
jugador(jugador(fede, 500, 500, [curacion, zombies],  [fuegoAncestral], [zombies])).
jugador(jugador(pepe, 500, 500, [curacion],  [fuegoAncestral], [curacion])).
jugador(jugador(juan, 500, 200, [momia, godzilla],  [momia, dracula], [momia])).
jugador(jugador(juancito, 500, 500, [momia, godzilla],  [momia, dracula], [momia])).

% criatura(Nombre, PuntosDaño, PuntosVida, CostoMana)
carta(criatura(godzilla, 500, 500, 300)).
carta(criatura(dracula, 300, 800, 300)).
carta(criatura(momia, 10, 200, 100)).

% hechizo(Nombre, FunctorEfecto, CostoMana)
carta(hechizo(fuegoMortal, danio(500), 100)).
carta(hechizo(fuegoAncestral, danio(200), 100)).
carta(hechizo(zombies, danio(100), 100)).
carta(hechizo(sanacion, curar(300), 300)).
carta(hechizo(meditacion, curar(100), 100)).

cartasMazo(jugador(_,_,_,Cartas,_,_), Cartas).
cartasMano(jugador(_,_,_,_,Cartas,_), Cartas).
cartasCampo(jugador(_,_,_,_,_,Cartas), Cartas).

nombre(jugador(Nombre,_,_,_,_,_), Nombre).
nombre(criatura(Nombre,_,_,_), Nombre).
nombre(hechizo(Nombre,_,_), Nombre).

/*
1. Relacionar un jugador con una carta que tiene. La carta podría estar en su mano, en el campo o en el mazo.
*/

tieneCarta(UnJugador, Carta):-
    jugador(Jugador), nombre(Jugador, UnJugador),
    todasLasCartasDe(Jugador, Cartas),
    esAlgunaDe(Cartas, Carta).

todasLasCartasDe(Jugador, Cartas):- cartasMazo(Jugador, Cartas).
todasLasCartasDe(Jugador, Cartas):- cartasMano(Jugador, Cartas).
todasLasCartasDe(Jugador, Cartas):- cartasCampo(Jugador, Cartas).

esAlgunaDe(Cartas, Carta):-
    member(Carta, Cartas).

/*
2. Saber si un jugador es un guerrero. Es guerrero cuando todas las cartas que tiene,
 ya sea en el mazo, la mano o el campo, son criaturas.
*/

guerrero(UnJugador):-
    jugador(Jugador), nombre(Jugador, UnJugador),
    forall(
         tieneCarta(UnJugador, Carta),
         tipoCriatura(Carta)
    ).

tipoCriatura(UnaCarta):-
    carta(criatura(UnaCarta, _, _, _)).

/*
3. Relacionar un jugador consigo mismo después de empezar el turno. Al empezar el turno,
la primera carta del mazo pasa a estar en la mano y el jugador gana un punto de maná.
*/
mana(jugador(_,_,Mana,_,_,_), Mana).
mana(criatura(_,_,_,Mana), Mana).
mana(hechizo(_,_,Mana), Mana).

despuesDeSuTurno(UnJugador, JugadorConMasMana):-
    jugador(Jugador), nombre(Jugador, UnJugador),
    cartasMazo(Jugador, CartasMazo), primeraCarta(CartasMazo, Carta),

    agregarEnMano(Carta, Jugador, JugadorConNuevasCartas),
    incrementarMana(JugadorConNuevasCartas, JugadorConMasMana).

primeraCarta(Cartas, Carta):-
    nth1(1, Cartas, Carta).

agregarEnMano(Carta, jugador(Nombre, PuntosVida, PuntosMana,  CartasMazo, CartasMano, CartasCampo),
                      jugador(Nombre, PuntosVida, PuntosMana, CartasMazo, NuevasCartasMano, CartasCampo)):-
    append([Carta], CartasMano, NuevasCartasMano).

incrementarMana(jugador(Nombre, PuntosVida, PuntosMana,  CartasMazo, CartasMano, CartasCampo),
                jugador(Nombre, PuntosVida, NuevosPuntosMana,  CartasMazo, CartasMano, CartasCampo)):-
    NuevosPuntosMana is PuntosMana+1.


/*
4. Cada jugador, en su turno, puede jugar cartas.
4a) Saber si un jugador tiene la capacidad de jugar una carta, esto es verdadero cuando el jugador tiene
igual o más maná que el costo de maná de la carta.
Este predicado no necesita ser inversible!
4b) Relacionar un jugador y las cartas que va a poder jugar en el próximo turno, una carta se puede jugar
en el próximo turno si tras empezar ese turno está en la mano y además se cumplen las condiciones del punto 4a
*/

puedeJugarCon(UnJugador, UnaCarta):-
    jugador(Jugador), nombre(Jugador, UnJugador), mana(Jugador, JugadorCuantoMana),
    carta(Carta), nombre(Carta, UnaCarta), mana(Carta, CartaCostoDeMana),
    JugadorCuantoMana >= CartaCostoDeMana.

cartaParaProximoTurno(UnJugador, Carta):-
    jugador(Jugador), nombre(Jugador, UnJugador),
    cartasMano(Jugador, CartasMano),

    % también podría usar el findall, y devolver sólo una lista
    puedeJugarCon(UnJugador, Carta), member(Carta, CartasMano).

/*
5. Conocer, de un jugador, todas las posibles jugadas que puede hacer en el próximo turno,
esto es, el conjunto de cartas que podrá jugar al mismo tiempo sin que su maná quede negativo.
Nota: Se puede asumir que existe el predicado jugar/3 como se indica en el punto 7.b.
No hace falta implementarlo para resolver este punto.
Importante: También hay formas de resolver este punto sin usar jugar/3.
*/

/*
todasLasPosiblesJugadas(UnJugador, Cartas):-
    puedeJugarCon(UnJugador, Carta),
    jugar(Carta, UnJugador, JugadorDespues).

%    findall(
%        Carta, jugar(UnJugador, Carta), Cartas
%    ).


jugar(_, jugador(Nombre, PuntosVida, PuntosMana,  CartasMazo, [], CartasCampo),
      jugador(Nombre, PuntosVida, PuntosMana,  CartasMazo, [], CartasCampo)).

jugar(UnaCarta, jugador(Nombre, PuntosVida, PuntosMana,  CartasMazo, CartasMano, CartasCampo),
      jugador(Nombre, PuntosVida, PuntosManaPorJugar,  CartasMazo, CartasMano, CartasCampo)):-

    carta(Carta), nombre(Carta, UnaCarta), mana(Carta, CartaCostoDeMana),
    PuntosManaPorJugar is PuntosMana-CartaCostoDeMana,

    cartaParaProximoTurno(jugador(Nombre, PuntosVida, PuntosManaPorJugar,  CartasMazo, CartasMano, CartasCampo), NuevaCarta),

    jugar(NuevaCarta, jugador(Nombre, PuntosVida, PuntosManaPorJugar,  CartasMazo, CartasMano, CartasCampo),
          jugador(Nombre, PuntosVida, PuntosManaPorJugar,  CartasMazo, CartasMano, CartasCampo)).

*/


/*
6. Relacionar a un jugador con el nombre de su carta más dañina.
*/

danio(criatura(_,Danio,_,_), Danio).
danio(hechizo(_,danio(Danio),_), Danio).

cartaMasDanina(UnJugador, UnaCarta):-
    jugador(Jugador), nombre(Jugador, UnJugador),
    tieneCarta(_, UnaCarta),
    forall(
        (tieneCarta(UnJugador, OtraCarta), UnaCarta \= OtraCarta),
        mayorDanio(UnaCarta, OtraCarta)
    ).

mayorDanio(Carta1, Carta2):-
    carta(UnaCarta), nombre(UnaCarta, Carta1), danio(UnaCarta, Danio1),
    carta(OtraCarta), nombre(OtraCarta, Carta2), danio(OtraCarta, Danio2),
    Danio1 > Danio2, Carta1 \= Carta2.

/*
7. Cuando un jugador juega una carta, él mismo y/o su rival son afectados de alguna forma:
jugarContra/3. Modela la acción de jugar una carta contra un jugador. Relaciona a la carta, el jugador antes de que le jueguen la carta y el jugador después de que le jueguen la carta. Considerar que únicamente afectan al jugador las cartas de hechizo de daño.
Este predicado no necesita ser inversible para la carta ni para el jugador antes de que le jueguen la carta.
BONUS: jugar/3. Modela la acción de parte de un jugador de jugar una carta. Relaciona a la carta, el jugador que puede jugarla antes de hacerlo y el mismo jugador después de jugarla. En caso de ser un hechizo de cura, se aplicará al jugador y no a sus criaturas. No involucra al jugador rival (para eso está el punto a).

*/

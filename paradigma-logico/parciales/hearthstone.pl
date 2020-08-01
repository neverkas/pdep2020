% https://yugioh.fandom.com/es/wiki/Categor%C3%ADa:Bestia
% https://yugioh.fandom.com/es/wiki/Categor%C3%ADa:Lanzador_de_Conjuros

% jugador(Nombre, PuntosVida, PuntosMana,  CartasMazo, CartasMano, CartasCampo)
jugador(jugador(yugiMoto, 500, 500, [exodiaElProhibido, dragonDeOjosRojos],  [magoOscuro], [damaDeLaFe, damaDeLaFe])).
jugador(jugador(setoKaiba, 500, 500, [doncellaDeOjosAzules, leviatan],  [magoOscuro], [magoOscuro])).
jugador(jugador(bakura, 500, 500, [damaDeLaFe],  [exodiaElProhibido], [doncellaDeOjosAzules])).
jugador(jugador(yamiYugi, 500, 200, [caballeroFeloz, dragonMaldito],  [infernoble, infernoble], [kraken])).
jugador(jugador(mokubaKaiba, 500, 500, [caballeroFeloz, infernoble],  [leviatan, leviatan], [kraken])).

% criatura(Nombre, PuntosDaño, PuntosVida, CostoMana)
carta(criatura(caballeroFeloz, 500, 500, 300)).
carta(criatura(dragonMaldito, 300, 800, 300)).
carta(criatura(infernoble, 10, 200, 100)).
carta(criatura(leviatan, 10, 200, 100)).
carta(criatura(kraken, 10, 200, 100)).

% hechizo(Nombre, FunctorEfecto, CostoMana)
carta(hechizo(exodiaElProhibido, danio(500), 100)).
carta(hechizo(magoOscuro, danio(200), 100)).
carta(hechizo(dragonDeOjosRojos, danio(100), 100)).
carta(hechizo(doncellaDeOjosAzules, curar(300), 300)).
carta(hechizo(damaDeLaFe, curar(100), 100)).

cartasMazo(jugador(_,_,_,Cartas,_,_), Cartas).
cartasMano(jugador(_,_,_,_,Cartas,_), Cartas).
cartasCampo(jugador(_,_,_,_,_,Cartas), Cartas).

nombre(jugador(Nombre,_,_,_,_,_), Nombre).
nombre(criatura(Nombre,_,_,_), Nombre).
nombre(hechizo(Nombre,_,_), Nombre).

/*
1. Relacionar un jugador con una carta que tiene. La carta podría estar en su mano, en el campo o en el mazo.
*/

tieneCarta(NombreJugador, Carta):-
    jugador(Jugador), nombre(Jugador, NombreJugador),
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

guerrero(NombreJugador):-
    jugador(Jugador), nombre(Jugador, NombreJugador),
    forall(
         tieneCarta(NombreJugador, Carta),
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

despuesDeSuTurno(NombreJugador, JugadorConMasMana):-
    jugador(Jugador), nombre(Jugador, NombreJugador),
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

puedeJugarCon(NombreJugador, UnaCarta):-
    jugador(Jugador), nombre(Jugador, NombreJugador), mana(Jugador, JugadorCuantoMana),
    carta(Carta), nombre(Carta, UnaCarta), mana(Carta, CartaCostoDeMana),
    JugadorCuantoMana >= CartaCostoDeMana.

cartaParaProximoTurno(NombreJugador, Carta):-
    jugador(Jugador), nombre(Jugador, NombreJugador),
    cartasMano(Jugador, CartasMano),

    % también podría usar el findall, y devolver sólo una lista
    puedeJugarCon(NombreJugador, Carta), member(Carta, CartasMano).

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


*/


/*
6. Relacionar a un jugador con el nombre de su carta más dañina.
*/


danio(criatura(_,Danio,_,_), Danio).
danio(hechizo(_,danio(Danio),_), Danio).

cartaMasDanina(NombreJugador, UnaCarta):-
    jugador(Jugador), nombre(Jugador, NombreJugador),
    tieneCarta(_, UnaCarta),
    forall(
        (tieneCarta(NombreJugador, OtraCarta), UnaCarta \= OtraCarta),
        mayorDanio(UnaCarta, OtraCarta)
    ).

mayorDanio(Carta1, Carta2):-
    carta(UnaCarta), nombre(UnaCarta, Carta1), danio(UnaCarta, Danio1),
    carta(OtraCarta), nombre(OtraCarta, Carta2), danio(OtraCarta, Danio2),
    Danio1 > Danio2, Carta1 \= Carta2.

/*
7. Cuando un jugador juega una carta, él mismo y/o su rival son afectados de alguna forma:
jugarContra/3. Modela la acción de jugar una carta contra un jugador.
Relaciona a la carta, el jugador antes de que le jueguen la carta y el jugador después de que le jueguen la carta.
Considerar que únicamente afectan al jugador las cartas de hechizo de daño.
Este predicado no necesita ser inversible para la carta ni para el jugador antes de que le jueguen la carta.

BONUS: jugar/3. Modela la acción de parte de un jugador de jugar una carta. Relaciona a la carta, el jugador que puede jugarla antes de hacerlo y el mismo jugador después de jugarla. En caso de ser un hechizo de cura, se aplicará al jugador y no a sus criaturas. No involucra al jugador rival (para eso está el punto a).
*/

jugarContra(NombreDeCarta, NombreJugador, JugadorDespues):-
    jugador(JugadorAntes), nombre(JugadorAntes, NombreJugador),
    danioPorTipoDeCarta(NombreDeCarta, CartaCuantoDanio),
    reducirVitalidad(CartaCuantoDanio, JugadorAntes, JugadorDespues).

danioPorTipoDeCarta(NombreDeCarta, 0):-
    carta(Carta), nombre(Carta, NombreDeCarta),
    not(tipoHechizo(NombreDeCarta)).

danioPorTipoDeCarta(NombreDeCarta, CuantoDanio):-
    carta(Carta), nombre(Carta, NombreDeCarta),
    tipoHechizo(NombreDeCarta),
    danio(Carta, CuantoDanio).

tipoHechizo(NombreDeCarta):-
    carta(hechizo(NombreDeCarta, _, _)).

reducirVitalidad(Cuanto, jugador(Nombre, PuntosVida, PuntosMana,  CartasMazo, CartasMano, CartasCampo),
                jugador(Nombre, NuevosPuntosVida, PuntosMana,  CartasMazo, CartasMano, CartasCampo)):-
    NuevosPuntosVida is PuntosVida-Cuanto.

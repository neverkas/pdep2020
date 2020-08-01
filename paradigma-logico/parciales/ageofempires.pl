% ...jugador(Nombre, Rating, Civilizacion).
jugador(juli, 2200, jemeres).
jugador(aleP, 1600, mongoles).
jugador(feli, 500000, persas).
jugador(aleC, 1723, otomanos).
jugador(ger, 1729, ramanujanos).
jugador(juan, 1515, britones).
jugador(marti, 1342, argentinos).
/*
1. Definir el predicado esUnAfano/2, que nos dice si al jugar el primero contra el segundo, la diferencia de
rating entre el primero y el segundo es mayor a 500.
*/
esUnAfano(Jugador1, Jugador2):-
    jugador(Jugador1, Rating1, _),
    jugador(Jugador2, Rating2, _),
    Diferencia is Rating1 - Rating2,
    Diferencia > 500.

/********************************************************************************************************************/

% militar(Tipo, costo(Madera, Alimento, Oro), Categoria).
militar(espadachin, costo(0, 60, 20), infanteria).
militar(arquero, costo(25, 0, 45), arqueria).
militar(mangudai, costo(55, 0, 65), caballeria).
militar(samurai, costo(0, 60, 30), unica).
militar(keshik, costo(0, 80, 50), unica).
militar(tarcanos, costo(0, 60, 60), unica).
militar(alabardero, costo(25, 35, 0), piquero).
% ... y muchos más tipos pertenecientes a estas categorías.

% aldeano(Tipo, produce(Madera, Alimento, Oro)).
aldeano(lenador, produce(23, 0, 0)).
aldeano(granjero, produce(0, 32, 0)).
aldeano(minero, produce(0, 0, 23)).
aldeano(cazador, produce(0, 25, 0)).
aldeano(pescador, produce(0, 23, 0)).
aldeano(alquimista, produce(0, 0, 25)).

/*
2. Definir el predicado esEfectivo/2, que relaciona dos unidades si la primera puede ganarle a la otra según
su categoría, dado por el siguiente piedra, papel o tijeras:
a) La caballería le gana a la arquería.
b) La arquería le gana a la infantería.
c) La infantería le gana a los piqueros.
d) Los piqueros le ganan a la caballería.
Por otro lado, los Samuráis son efectivos contra otras unidades únicas (incluidos los samurái).
Los aldeanos nunca son efectivos contra otras unidades.
*/
leGana(caballeria, arqueria).
leGana(arqueria, infanteria).
leGana(infanteria, piqueros).
leGana(piqueros, caballeria).

% unidad(Tipo, Categoria)
unidad(Tipo, Categoria):-
    militar(Tipo, _, Categoria).
unidad(Tipo, aldeano):-
    aldeano(Tipo, _).

esEfectivo(Unidad1, Unidad2):-
    unidad(Unidad1, Categoria1),
    unidad(Unidad2, Categoria2),
    leGana(Categoria1, Categoria2),
    Unidad1 \= Unidad2.
esEfectivo(samurai, Unidad2):-     %% << dudas (?)
    unidad(Unidad2, unica).
esEfectivo(Unidad1, aldeano):-
    unidad(Unidad1, Categoria),
    Categoria \= aldeano.

/********************************************************************************************************************/

tiene(aleP, unidad(samurai, 199)).
tiene(aleP, unidad(espadachin, 10)).
tiene(aleP, unidad(granjero, 10)).
%% tiene(aleP, recurso(800, 300, 100)).
tiene(aleP, recurso(800, 3000, 300)).
tiene(aleP, edificio(casa, 40)).
tiene(aleP, edificio(castillo, 1)).
tiene(juan, unidad(carreta, 10)).
%% agrego extra para probar PUNTO 8 <<<<
tiene(juan, unidad(carreta, 10)).
tiene(aleP, edificio(establo, 1)).
tiene(aleP, edificio(herreria, 1)).
/*
3) Definir el predicado alarico/1 que se cumple para un jugador si solo tiene unidades de infantería.
*/

%% REVISAR
%% <<< Me parece que no esta funcionando bien (?)
alarico(Jugador):-
    soloTieneUnidadesDe(Jugador, infanteria).

/*
4) Definir el predicado leonidas/1, que se cumple para un jugador si solo tiene unidades de piqueros.
*/
leonidas(Jugador):-
    soloTieneUnidadesDe(Jugador, piqueros).

soloTieneUnidadesDe(Jugador, Categoria):-
    jugador(Jugador, _, _),
    forall(
        jugador(Jugador, _, _),
        (tiene(Jugador, unidad(Tipo, _)), militar(Tipo, _, Categoria))
    ).

/*
 5) Definir el predicado nomada/1, que se cumple para un jugador si no tiene casas.
*/

nomada(Jugador):-
    jugador(Jugador, _, _),
    not(tiene(Jugador, edificio(casa, _))).

/********************************************************************************************************************/

% edificio(Edificio, costo(Madera, Alimento, Oro)).
edificio(casa, costo(30, 0, 0)).
edificio(granja, costo(0, 60, 0)).
edificio(herreria, costo(175, 0, 0)).
edificio(castillo, costo(650, 0, 300)).
edificio(maravillaMartinez, costo(10000, 10000, 10000)).

/*
6) Definir el predicado cuantoCuesta/2, que relaciona una unidad o edificio con su costo.
-De las unidades militares y de los edificios conocemos sus costos.
-Los aldeanos cuestan 50 unidades de alimento.
-Las carretas y urnas mercantes cuestan 100 unidades de madera y 50 de oro cada una.
*/
cuantoCuesta(Unidad, Costo):-
    militar(Unidad, Costo, _).
cuantoCuesta(Edificio, Costo):-
    edificio(Edificio, Costo).
cuantoCuesta(Unidad, costo(0,50,0)):-
    unidad(Unidad, aldeano).

cuantoCuesta(carreta, costo(100, 0, 50)).
cuantoCuesta(urna, costo(100, 0, 50)).

%% cuantoCuesta(Unidad, Costo):-
%%     unidad(Unidad, aldeano),
%%     costoDe(alimento, 50, Costo).

%% cuantoCuesta(carreta, Costo):-
%%     costoDe(madera, 100, Costo),
%%     costoDe(oro, 50, Costo).

%% costoDe(alimento, Cuanto, (0, Cuanto, 0)).
%% costoDe(madera, Cuanto, (Cuanto, 0, 0)).
%% costoDe(oro, Cuanto, (0, 0,Cuanto)).

/*
7. Definir el predicado produccion/2, que relaciona una unidad con su producción de recursos por minuto.
-De los aldeanos, según su profesión, se conoce su producción.
-Las carretas y urnas mercantes producen 32 unidades de oro por minuto.
-Las unidades militares no producen ningún recurso, salvo los Keshiks, que producen 10 de oro por minuto.
*/

produccion(Unidad, Produccion):-
    aldeano(Unidad, Produccion).
produccion(carreta, produce(0,0,32)).
produccion(keshik, produce(0,0,10)).    %% <<< Dudas si se podria mejorar... (?)
produccion(Unidad, produce(0,0,0)):-
    militar(Unidad, _, _),
    Unidad \= keshik.

/*
8) Definir el predicado produccionTotal/3 que relaciona a un jugador con su producción total por minuto de
cierto recurso, que se calcula como la suma de la producción total de todas sus unidades de ese recurso.

- juan tiene 640 de oro (porque agregué cosas en tiene/2)
- aleP 320 de alimento
*/

produccionTotal(Jugador, Recurso, ProduccionTotal):-
    jugador(Jugador, _, _),
    produccionDe(Recurso, _, _),
    findall(
        ProduccionPorUnidad,
        %% (tiene(Jugador, unidad(Tipo, Cuantos)), produccion(Tipo, Produccion), produccionPorRecurso(Produccion, Recurso),
        %%  produccionPorCantidad(Produccion, Cuantos, ProduccionPorCantidad)),
        produccionPorUnidadDe(Recurso, Jugador, ProduccionPorUnidad),
        ProduccionUnidades
    ),
    sumlist(ProduccionUnidades, ProduccionTotal).


produccionPorUnidadDe(Recurso, Jugador, ProduccionTotal):-
    tiene(Jugador, unidad(Tipo, CantidadUnidades)),
    %% produccion(Tipo, Produccion),
    produccionDe(Recurso, Tipo, Produccion),
    ProduccionTotal is Produccion*CantidadUnidades.

produccionDe(madera, Unidad, Produccion):-
    produccion(Unidad, produce(Produccion, _, _)).
produccionDe(alimento, Unidad, Produccion):-
    produccion(Unidad, produce(_, Produccion, _)).
produccionDe(oro, Unidad, Produccion):-
    produccion(Unidad, produce(_, _,Produccion)).

/*
9. Definir el predicado estaPeleado/2 que se cumple para dos jugadores
- cuando no es un afano para ninguno, tienen la misma cantidad de unidades
- y la diferencia de valor entre su producción total de recursos por minuto es menor a 100
¡Pero cuidado! No todos los recursos valen lo mismo:
- el oro vale 1 cinco veces su cantidad;
- la madera, tres veces;
- y los alimentos, dos veces.
*/

estaPeleado(Jugador1, Jugador2):-
    not( esUnAfanoParaAlguno(Jugador1, Jugador2) ),
    mismaCantidadUnidades(Jugador1, Jugador2),
    valorProduccionTotalDeRecursos(Jugador1, ValorProduccionTotal1),
    valorProduccionTotalDeRecursos(Jugador2, ValorProduccionTotal2),
    Diferencia is ValorProduccionTotal1-ValorProduccionTotal2,
    Diferencia < 100.

esUnAfanoParaAlguno(Jugador1, Jugador2):-
    esUnAfano(Jugador1, Jugador2).
esUnAfanoParaAlguno(Jugador1, Jugador2):-
    esUnAfano(Jugador2, Jugador1).

mismaCantidadUnidades(Jugador1, Jugador2):-
    cantidadUnidades(Jugador1, Cantidad),
    cantidadUnidades(Jugador2, Cantidad).

cantidadUnidades(Jugador, CantidadTotal):-
    jugador(Jugador, _, _),
    findall(Unidades, tiene(Jugador, unidad(_, Unidades)) , CantidadPorUnidad),
    sumlist(CantidadPorUnidad, CantidadTotal).

valorProduccionTotalDeRecursos(Jugador, ValorProduccionTotal):-
    valorProduccionTotalDe(madera, Jugador, ValorProduccionMadera),
    valorProduccionTotalDe(alimento, Jugador, ValorProduccionAlimento),
    valorProduccionTotalDe(oro, Jugador, ValorProduccionOro),
    ValorProduccionTotal is ValorProduccionOro+ValorProduccionMadera+ValorProduccionAlimento.

valorProduccionTotalDe(Recurso, Jugador, ValorProduccion):-
    valorDe(Recurso, ValorDelRecurso),
    produccionTotal(Jugador,Recurso, ProduccionTotal),
    ValorProduccion is ProduccionTotal*ValorDelRecurso.

valorDe(oro, 5).
valorDe(madera, 3).
valorDe(alimento, 2).

/*
10. Definir el predicado avanzaA/2 que relaciona un jugador y una edad si este puede avanzar a ella:
a) Siempre se puede avanzar a la edad media.
b) Puede avanzar a edad feudal si tiene al menos 500 unidades de alimento y una casa.
c) Puede avanzar a edad de los castillos si tiene al menos 800 unidades de alimento y 200 de oro.
También es necesaria una herrería, un establo o una galería de tiro.
d) Puede avanzar a edad imperial con 1000 unidades de alimento, 800 de oro, un castillo y una
universidad.
*/

avanzaA(Jugador, edadMedia):-
    jugador(Jugador, _, _).

avanzaA(Jugador, edadFeudal):-
    tiene(Jugador, Recursos),
    cuantosRecursosTieneDe(alimento, Recursos, CantidadAlimento),
    tieneEdificio(Jugador, casa),
    CantidadAlimento >= 500.

avanzaA(Jugador, edadCastillos):-
    tiene(Jugador, Recursos),
    cuantosRecursosTieneDe(oro, Recursos, CantidadOro),
    cuantosRecursosTieneDe(alimento, Recursos, CantidadAlimento),
    tieneConstruccionesEdadCastillo(Jugador),
    %% construccionEdadCastillo(ConstruccionEdadCastillo),
    %% tieneEdificio(Jugador, ConstruccionEdadCastillo),
    CantidadOro >= 200, CantidadAlimento >= 800.

avanzaA(Jugador, edadImperial):-
    tiene(Jugador, Recursos),
    cuantosRecursosTieneDe(alimento, Recursos, CantidadAlimento),
    cuantosRecursosTieneDe(oro, Recursos, CantidadOro),
    tieneEdificio(Jugador, castillo),
    tieneEdificio(Jugador, universidad),
    CantidadAlimento >= 1000, CantidadOro >= 800.

tieneConstruccionesEdadCastillo(Jugador):-
    construccionEdadCastillo(Construccion),
    tieneEdificio(Jugador, Construccion).

construccionEdadCastillo(herreria).
construccionEdadCastillo(establo).
construccionEdadCastillo(galeriaDeTiro).

cuantosRecursosTieneDe(alimento, recurso(_, Cantidad, _), Cantidad).
cuantosRecursosTieneDe(madera, recurso(Cantidad, _ ,_), Cantidad).
cuantosRecursosTieneDe(oro, recurso(_,_, Cantidad), Cantidad).

tieneEdificio(Jugador, Edificio):-
    tiene(Jugador, edificio(Edificio, _)).

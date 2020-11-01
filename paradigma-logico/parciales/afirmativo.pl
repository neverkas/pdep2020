/*
distinct(X, Consulta(X)).
*/

%tarea(agente, tarea, ubicacion)
%tareas:
% ingerir(descripcion, tamaño, cantidad)
% apresar(malviviente, recompensa)
% asuntosInternos(agenteInvestigado)
% vigilar(listaDeNegocios)
tarea(vigilanteDelBarrio, ingerir(pizza, 1.5, 2),laBoca).
tarea(vigilanteDelBarrio, vigilar([pizzeria, heladeria]), barracas).
tarea(canaBoton, asuntosInternos(vigilanteDelBarrio), barracas).
tarea(sargentoGarcia, vigilar([pulperia, haciendaDeLaVega, plaza]),puebloDeLosAngeles).
tarea(sargentoGarcia, ingerir(vino, 0.5, 5),puebloDeLosAngeles).
tarea(sargentoGarcia, apresar(elzorro, 100), puebloDeLosAngeles).
tarea(vega, apresar(neneCarrizo,50),avellaneda).
tarea(jefeSupremo, vigilar([congreso,casaRosada,tribunales]),laBoca).
% extra
tarea(bart, vigilar([negocioDeAlfajores, heladeria]), barracas).
tarea(homero, ingerir(pizza, 1.5, 50), barracas).

ubicacion(puebloDeLosAngeles).
ubicacion(avellaneda).
ubicacion(barracas).
ubicacion(marDelPlata).
ubicacion(laBoca).
ubicacion(uqbar).

%jefe(jefe, subordinado)
jefe(jefeSupremo,vega ).
jefe(vega, vigilanteDelBarrio).
jefe(vega, canaBoton).
jefe(jefeSupremo,sargentoGarcia).
% extra
agente(Agente):- tarea(Agente, _, _).

/*
1) Hacer el predicado frecuenta/2
que relaciona un agente con una ubicación en la que suele estar.
Debe ser inversible.
● Los agentes frecuentan las ubicaciones en las que realizan tareas
● Todos los agentes frecuentan buenos aires.
● Vega frecuenta quilmes.
● Si un agente tiene como tarea vigilar un negocio de alfajores, frecuenta Mar del Plata.
*/

% frecuenta(Agente, Ubicacion)
frecuenta(Agente, Ubicacion):-
    tarea(Agente, _, Ubicacion).
frecuenta(Agente, buenosAires):-
    agente(Agente).
frecuenta(vega, quilmes).
frecuenta(Agente, marDelPlata):-
    lugaresQueVigila(Agente, Lugares),
    member(negocioDeAlfajores, Lugares).

lugaresQueVigila(Agente, Lugares):-
    tarea(Agente, vigilar(Lugares), _).

/*
2. Hacer el predicado que permita averiguar algún lugar inaccesible, es decir, al que nadie frecuenta.
*/

inaccesible(Ubicacion):-
    ubicacion(Ubicacion),
    not(frecuenta(_, Ubicacion)).

/*
3) Hacer el predicado afincado/1
que permite deducir si un agente siempre realiza sus tareas en la misma ubicación.

>>> CORRECCION <<<
*/
afincado(Agente):-
    trabajaEn(Agente, Ubicacion1),
    forall(
        trabajaEn(Agente, Ubicacion2),
        mismoLugar(Ubicacion1, Ubicacion2)
    ).

mismoLugar(Ubicacion,Ubicacion).
trabajaEn(Agente, Ubicacion):-
    tarea(Agente, _, Ubicacion).
    %distinct(Agente, tarea(Agente, _, Ubicacion)).

/*
Este predicado está MAL...

afincado2(Agente):-
    tarea(Agente, _, Ubicacion),
    forall(
        % ingerir en palermo == VERDADERO
        tarea(Agente, Tarea, Ubicacion),
        % ingerir en palermo == VERDADERO
        % ingerir \= ingerir  == FALSO
        (tarea(Agente, OtraTarea, Ubicacion), OtraTarea\=Tarea)
        %% VERDADERO => FALSO == FALSO, y deberia haber sido VERDADO
        %% porque ambas ubicaciones son la misma,
        %%
        %% NO IMPORTA SI LAS TAREAS SON DISTINTAS
        %% LO IMPORTANTE ES LA UBICACION  ...
    ).
*/

/*
4) Hacer el predicado cadenaDeMando/1
que verifica si la lista recibida se trata de una cadena de
mando válida, lo que significa que el primero es jefe del segundo y el segundo del tercero y así
sucesivamente. Debe estar hecho de manera tal que permita generar todas las cadenas de mando
posibles, de dos o más agentes.
cadenaDeMando([jefeSupremo, vega, canaBoton])
cadenaDeMando([jefeSupremo, canaBoton, vega])
*/

/*
* CORRECCION
*
* 1. Debias mantener la relacion
* 2. Debias pasarle de parámetro una lista [Elemento|Lista],
*    antes estabas pasandole dos parámetros y el predicado sólo recibe una lista
*/
cadenaDeMando([Persona1, Persona2]):-
    jefe(Persona1, Persona2).
cadenaDeMando([Persona1, Persona2|OtrasPersonas]):-
    jefe(Persona1, Persona2),
    cadenaDeMando([Persona2|OtrasPersonas]).
%% cadenaDeMando([Persona|OtrasPersonas]):-
    %% not(member(Persona, OtrasPersonas)),
    %% cadenaDeMando(OtrasPersonas).

%% cadenaDeMando([Persona1, Persona2|OtrasPersonas]):-


/*
5) Hacer un predicado llamado agentePremiado/1
que permite deducir el agente que recibe el premio por tener la mejor puntuación.
La puntuación de un agente es la sumatoria de los puntos de cada tarea
que el agente realiza, que puede ser positiva o negativa. Se calcula de la siguiente manera:
● vigilar: 5 puntos por cada negocio que vigila
● ingerir: 10 puntos negativos por cada unidad de lo que ingiera. Las unidades ingeridas se
calculan como tamaño x cantidad.
● apresar: tantos puntos como la mitad de la recompensa.
● asuntosInternos: el doble de la puntuación del agente al que investiga.
*/

/*
* CORRECCION
*
* 1. En el antecedente se debia agregar que se iba a comparar con otro
*/

agentePremiado(Agente1):-
    %agente(Agente1),
    calificar(Agente1, Puntos1),
    forall(
        (calificar(Agente2, Puntos2), Agente1\=Agente2), Puntos1 > Puntos2,
        %calificar(Agente2, Puntos2), (Puntos1 > Puntos2, Agente1\=Agente2)
        %calificar(Agente1, Puntos1), (calificar(Agente2, Puntos2), Agente1\=Agente2, Puntos1 > Puntos2)
    ).

calificar(Agente, PuntosCantidad):-
    agente(Agente),
    findall(
        Puntos,
        (tarea(Agente, Tarea, _), tareaPorPuntos(Tarea, Puntos)),
        PuntosTotal
    ), sumlist(PuntosTotal, PuntosCantidad).

tareaPorPuntos(vigilar(Negocios), Puntos):-
    length(Negocios, CuantosNegocios),
    Puntos is CuantosNegocios*5.
tareaPorPuntos(ingerir(_, Tamanio, Cantidad),Puntos):-
    Puntos is Tamanio*Cantidad*(-10).
tareaPorPuntos(apresar(_, Recompensa), Puntos):-
    Puntos is Recompensa/2.
tareaPorPuntos(asuntosInternos(AgenteInvestigado), Puntos):-
    calificar(AgenteInvestigado, PuntosCantidad),
    Puntos is PuntosCantidad*2.

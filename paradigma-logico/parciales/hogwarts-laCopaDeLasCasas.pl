%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parte 2 - La copa de las casas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

accion(ajedrez, 50).
accion(salvarAmigos, 50).
accion(ganarVoldemort, 60).
accion(bosque, -50).
accion(biblioteca, -10).
accion(tercerPiso, -75).
% extra para probar
accion(mazmorras, 100).

% malas acciones
hizo(fueraDeCama, harry).
hizo(bosque, harry).
hizo(tercerPiso, harry).
hizo(tercerPiso, hermione).
hizo(biblioteca, hermione).
% buenas acciones
hizo(mazmorras, draco).
hizo(ajedrez, ron).
hizo(salvarAmigos, hermione).
hizo(ganarVoldemort, harry).
% extra para probar
hizo(ajedrez, luna).

prohibido(bosque).
prohibido(biblioteca).
prohibido(tercerPiso).

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

% reutilizo, y genero hechos por comprensión
casa(Casa):- esDe(_, Casa).
mago(Mago):- hizo(_, Mago).


/*
Punto 1a
Saber si un mago es buen alumno, que se cumple si hizo alguna acción y ninguna de las
cosas que hizo se considera una mala acción (que son aquellas que provocan un puntaje negativo).
*/
buenAlumno(Mago):-
    mago(Mago),
    not((hizo(Accion, Mago), buena(Accion))).

buena(Accion):-
    accion(Accion, Puntos),
    Puntos > 0.

/*
%% punto 1b
Saber si una acción es recurrente, que se cumple si más de un mago hizo esa misma acción.
*/

accionRecurrente(Accion):-
    hizo(Accion, Mago1),
    hizo(Accion, Mago2),
    Mago1 \= Mago2.

/*
%% punto 2
Saber cuál es el puntaje total de una casa, que es la suma de los puntos obtenidos por sus miembros.
*/
puntajeTotal(Casa, Puntos):-
    casa(Casa),
    % puntosPorMiembros(Casa, Puntos),
    findall(Puntos, puntosPorMiembros(Casa, Puntos), PuntosPorMiembros),
    sum_list(PuntosPorMiembros, Puntos).

puntosPorMiembros(Casa, Puntos):-
    esDe(Mago, Casa),
    hizo(Accion, Mago),
    accion(Accion, Puntos).

puntosPorMiembros(Casa, Puntos):-
    esDe(Mago, Casa),
    respondio(Pregunta, Mago),
    puntosPorResponder(Pregunta, Puntos).

/*
%% Punto 3

Saber cuál es la casa ganadora de la copa, que se verifica para aquella casa que haya
obtenido una cantidad mayor de puntos que todas las otras.
*/

ganadora(Casa):-
    % casa(Casa), % con este no tenes puntos a comparar
    puntajeTotal(Casa, Puntos),
    forall(
        (puntajeTotal(Casa2, Puntos2), Casa\=Casa2),
        Puntos > Puntos2
        %(Casa \= Casa2, Puntos > Puntos2) % Casa\=Casa2 debe ser antecedente
    ).


%% ganadora(Casa):-
%%     casa(Casa),
%%     forall(
%%         (puntajeTotal(Casa, Puntos1), puntajeTotal(OtraCasa, Puntos2)),
%%         (Casa \= OtraCasa, Puntos1 > Puntos2)
%%     ).
%% ganadorEntre(Casa1, Casa2):-
%%     puntajeTotal(Casa1, Puntos1),
%%     puntajeTotal(Casa2, Puntos2),
%%     Puntos1 > Puntos2.

/*
%% Punto 4

Queremos agregar la posibilidad de ganar puntos por responder preguntas en clase.
La información que nos interesa de las respuestas en clase son: cuál fue la pregunta,
cuál es la dificultad de la pregunta y qué profesor la hizo.

Por ejemplo, sabemos que Hermione respondió a la pregunta de dónde se encuentra un Bezoar,
de dificultad 20, realizada por el profesor Snape, y cómo hacer levitar una pluma,
de dificultad 25, realizada por el profesor Flitwick.

Modificar lo que sea necesario para que este agregado funcione con lo desarrollado hasta ahora,
teniendo en cuenta que los puntos que se otorgan equivalen a la dificultad de la pregunta,
a menos que la haya hecho Snape, que da la mitad de puntos en relación a la dificultad de la pregunta.
*/

% respuesta(pregunta(Pregunta, Dificultad, Profesor), Mago)
respondio(pregunta(dondeEstaBezoar, 20, snape), hermione). % +20
respondio(pregunta(levitarPluma, 25, flitwick), hermione). % +12

puntosPorResponder(Pregunta, Puntos):-
    porDificultad(Pregunta, Puntos),
    not(laHizoSnape(Pregunta, Puntos)).
puntosPorResponder(Pregunta, Puntos):-
    laHizoSnape(Pregunta, Puntos).

porDificultad(pregunta(_, Dificultad, _), Dificultad).
laHizoSnape(pregunta(_, Dificultad, snape), Puntos):-
    Puntos is Dificultad/2.


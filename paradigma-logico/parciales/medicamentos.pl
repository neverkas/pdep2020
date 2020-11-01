% vende(Farmacia, Medicamento, Precio)
vende(laGondoriana, trancosin, 35).
vende(laGondoriana, sanaSam, 35).
% incluye(Medicamento, Droga)
incluye(trancosin, athelas).
incluye(trancosin, cenizaBoromireana).
% efecto(Droga, Efecto),
efecto(athelas, cura(desazon)).
efecto(athelas, cura(heridaDeOrco)).
efecto(cenizaBoromireana, cura(gripeA)).
efecto(cenizaBoromireana, potencia(deseoDePoder)).
% estaEnfermo(Persona, Enfermedad)
estaEnfermo(eomer, heridaDeOrco). % eomer es varon
estaEnfermo(eomer, deseoDePoder).
estaEnfermo(eomund, desazon).
estaEnfermo(eowyn, heridaDeOrco). % eowyn es mujer
% padre(Padre, Hijo)
padre(eomund, eomer).

actividad(eomer, fecha(15, 6, 3014), compro(trancosin, laGondoriana)).
actividad(eomer, fecha(15, 8, 3014), preguntoPor(sanaSam, laGondoriana)).
actividad(eowyn, fecha(14, 9, 3014), preguntoPor(sanaSam, laGondoriana)).
% extra
medicamento(Medicamento):- incluye(Medicamento, _).
farmacia(Farmacia):- vende(Farmacia, _, _).
droga(Droga):- incluye(_, Droga).
persona(Persona):- estaEnfermo(Persona, _).
enfermedad(Enfermedad):- estaEnfermo(_, Enfermedad).
compro(Persona, Medicamento):-
    compro(Persona, Medicamento, _).
    % actividad(Persona, _, compro(Medicamento, _)).
compro(Persona, Medicamento, Farmacia):-
    actividad(Persona, _, compro(Medicamento, Farmacia)).
pregunto(Persona, Medicamento):-
    pregunto(Persona, Medicamento, _).
    %actividad(Persona, _, pregunto(Medicamento, _)).
pregunto(Persona, Medicamento, Farmacia):-
    actividad(Persona, _, pregunto(Medicamento, Farmacia)).
fecha(Fecha):- actividad(_, Fecha, _).

/***********************************************************/
/*
1. medicamentoUtil(Persona, Medicamento)
- se verifica si Medicamento sirve para curar (osea, tiene una droga que cura) alguna enfermedad 
de la que Persona está enfermo
- además no sirve para potenciar (o sea, ninguna de sus drogas potencia) una enfermedad de la que
Persona está enfermo.
*/

medicamentoUtil(Persona, Medicamento):-
    % Medicamento sirve para curar a una Persona
    sirveParaCurar(Medicamento, Persona),
    % y además no sirve para potenciar a una Persona
    % (NO potencia NINGUNA enfermedad de la persona,
    % al negar un existencial es "NINGUNO CUMPLE ESTA RELACION")
    not(sirveParaPotenciar(Medicamento, Persona)).

sirveParaCurar(Medicamento, Persona):-
    sirveParaCurar(Medicamento, Persona, _).

sirveParaCurar(Medicamento, Persona, Enfermedad):-
    sirveParaCurar(Medicamento, Persona, Enfermedad, _).

sirveParaCurar(Medicamento, Persona, Enfermedad, Droga):-
    % existe un medicamento que tiene una droga
    % "buscamos un medicamento que esté relacionado con una droga"
    % (puede estar relacionado con una o varias, depende de los hechos)
    % - Si Medicamento está como variable libre, entonces buscará el primer hecho
    %   luego de evaluar con las clausulas efecto/2 y estaEnfermo/2 vuelve los hechos
    %   y agarra el siguiente y vuelve a analizar las distintas soluciones que satisfagan
    %   las 3 clausulas incluye/2, efecto/2 estaEnfermo/2
    incluye(Medicamento, Droga),
    % y esa droga sirve para curar una enfermedad
    % "buscamos la relación, para saber cual es esa enfermedad"
    % ligamos la variable Droga
    efecto(Droga, cura(Enfermedad)),
    % buscamos que persona tiene la enfermedad que cura esa droga
    % ligamos la variable Enfermedad (y luego Persona)
    estaEnfermo(Persona, Enfermedad).


% el proceso es similar al sirveParaCurar/2
sirveParaPotenciar(Medicamento, Persona):-
    % existe un medicamento que tiene una droga
    % buscamos la relación
    incluye(Medicamento, Droga),
    % y esa droga sirve para potenciar una enfermedad
    % ligamos la variable Droga
    efecto(Droga, potencia(Enfermedad)),
    % ligamos la variable Enfermedad (y Persona)
    estaEnfermo(Persona, Enfermedad).

/*
 2. medicamentoMilagroso(Persona, Medicamento)
se verifica si Medicamento
- sirve para curar (o sea, tiene una droga que cura) todas las enfermedades de las que Persona está
enfermo,
- y además no sirve para potenciar (o sea, ninguna de sus drogas potencia) una
enfermedad de la que Persona está enfermo.
 */

medicamentoMilagroso(Persona, Medicamento):-
    % un predicado generador
    % (busca en la base de conocimiento la primera persona y la liga a Persona)
    persona(Persona),
    % otro predicado
    % (buscar en la base de conocimiento el primer medicamento y lo liga a Medicamento)
    medicamento(Medicamento),
    % "para toda enfermedad de la persona, el medicamento cura cada enfermedad"
    % es ParaToda Enfermedad porque es la variable libre del forall/2
    forall(
        % busco una enfermedad de la Persona ligada (busca el primer hecho)
        estaEnfermo(Persona, Enfermedad),
        % evalua con las variables ligadas Medicamento, Persona, Enfermedad
        % el predicado sirveParaCurar/3 se cumple,
        % - si se cumple, avanza a la siguiente clausura sirveParaPotenciar/2
        % - si no se cumple vuelve al principio de medicamentoMilagroso/2
        %   y evalua el siguiente hecho, hasta que no hayan mas Persona ni Medicamento
        % - si la misma persona se repite, volverá a usarla
        sirveParaCurar(Medicamento, Persona, Enfermedad)
        ),
    not(sirveParaPotenciar(Medicamento, Persona)).

/*
3. drogaSimpatica(Droga)
se verifica para una Droga si cumple al menos una de estas condiciones:
● cura al menos 4 enfermedades y no potencia ninguna
● cura al menos una enfermedad de la que eomer está enfermo y otra distinta de la que
eowyn está enferma
● se incluye al menos en un medicamento, ese medicamento se vende al menos en una
farmacia, y ninguna farmacia lo vende a más de 10 pesos.
*/

drogaSimpatica(Droga):-
    droga(Droga), % <<< te faltaba el predicado generador
    enfermedadesQueCura(Droga, Cuantas),
    Cuantas >= 4,
    not(efecto(Droga, potencia(_))).

drogaSimpatica(Droga):-
    sirveParaCurar(_, eomer, Enfermedad1, Droga),
    sirveParaCurar(_, eowyn, Enfermedad2, Droga),
    Enfermedad1 \= Enfermedad2.

drogaSimpatica(Droga):-
    incluye(Medicamento, Droga),
    vende(_, Medicamento, _),
    not(loVendenCaro(Medicamento)).

enfermedadesQueCura(Droga, Cuantas):-
    findall(
        Enfermedad,
        (enfermedad(Enfermedad), sirveParaCurar(_, _, Enfermedad, Droga)),
        Enfermedades
    ), length(Enfermedades, Cuantas).

loVendenCaro(Medicamento):-
    vende(_, Medicamento, Precio),
    Precio > 10.

/*
4. tipoSuicida(Persona)
se verifica para una Persona
- si compró al menos un producto que no sirve para curar ninguna enfermedad de la que está enfermo
y que sí sirve para potenciar una enfermedad de la que está enfermo.
*/

tipoSuicida(Persona):-
    compro(Persona, Medicamento),
    not(sirveParaCurar(Medicamento, Persona)),
    sirveParaPotenciar(Medicamento, Persona).

/*
5. tipoAhorrativo(Persona),
se verifica para una Persona
- si para cada medicamento que compró,
- preguntó por el mismo medicamento en una farmacia que lo cobra más caro que
aquella en la que lo compró.
*/

tipoAhorrativo(Persona):-
    persona(Persona), % predicado generador, "para una persona en particular"
    farmacia(Farmacia), % predicado generador "para una farmacia en particular"
    % La variable libre del forall/2 es Medicamento,
    % por tanto se evalua "para todo medicamento"
    forall(
        compro(Persona, Medicamento, Farmacia),
        (pregunto(Persona, Medicamento, OtraFarmacia), vendeMasCaro(OtraFarmacia, Medicamento, Farmacia))
    ).

vendeMasCaro(Farmacia1, Medicamento, Farmacia2):-
    vende(Farmacia1, Medicamento, Precio1),
    vende(Farmacia2, Medicamento, Precio2),
    Farmacia1 \= Farmacia2,
    Precio1 > Precio2.

/*
6a. tipoActivoEn(Persona, Mes, Año)
se verifica si la Persona hizo alguna actividad (compra y/o pregunta) en ese Mes y Año.
*/

tipoActivoEn(Persona, Mes, Anio):-
    actividad(Persona, fecha(_, Mes, Anio), _).

/*
6b. diaProductivo(Fecha),
se verifica para una Fecha (functor fecha(Día, Mes, Año))
- si todas las actividades que se hicieron en ese día fueron compras o preguntas
  de un medicamento útil para la persona que hizo la actividad.
*/
diaProductivo(Fecha):-
    fecha(Fecha),
    persona(Persona),
    forall(
        actividad(Persona, Fecha, Actividad),
        actividadProductiva(Persona, Actividad)
    ).

actividadProductiva(Persona, Actividad):-
    tipoDeActividad(Actividad, Medicamento),
    medicamentoUtil(Persona, Medicamento).

tipoDeActividad(compro(Medicamento, _), Medicamento).
tipoDeActividad(preguntoPor(Medicamento, _), Medicamento).

/*
7. gastoTotal(Persona, Plata)
- relaciona cada Persona con el total de Plata que gastó en medicamentos que compró,
según el precio de cada medicamento comprado en la farmacia en la que hizo la compra.
*/

gastoTotal(Persona, Plata):-
    persona(Persona), % predicado generador (una persona especifica)
    % farmacia(Farmacia), % predicado generador (una farmacia especifica)
    findall(
        PrecioMedicamento,
        (compro(Persona, Medicamento, Farmacia), vende(Farmacia, Medicamento, PrecioMedicamento)),
        PreciosMedicamentos
    ), sumlist(PreciosMedicamentos, Plata).

/*
8. zafoDe(Persona, Enfermedad)
- se verifica si Persona no está enfermo de Enfermedad,
- pero algún ancestro de Persona (padre, abuelo, bisabuelo, o más) sí lo está.
*/

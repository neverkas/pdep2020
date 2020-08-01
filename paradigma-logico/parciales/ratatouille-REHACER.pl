rata(remy, gusteaus).
rata(emile, bar).
rata(django, pizzeria).

cocina(linguini, ratatouille, 3).
cocina(linguini, sopa, 5).
cocina(colette, salmonAsado, 9).
cocina(horst, ensaladaRusa, 8)

trabajaEn(gusteaus, linguini).
trabajaEn(gusteaus, colette).
trabajaEn(gusteaus, skinner).
trabajaEn(gusteaus, horst).
trabajaEn(cafeDes2Moulins, amelie).

%
% 1. inspeccionSatisfactoria/1 se cumple para un restaurante cuando no viven ratas allí.
%

inspeccionSatisfactoria(Restaurante):-
    restaurante(Restaurante), not(rata(_, Restaurante)).

restaurante(Restaurante):- rata(_, Restaurante).

%
% 2. chef/2: relaciona un empleado con un restaurante si el empleado trabaja allí y sabe cocinar algún plato.
%

chef(Empleado, Restaurante):-
    trabajaEn(Restaurante, Empleado),
    cocina(Empleado, _, _).

%
% 3. chefcito/1: se cumple para una rata si vive en el mismo restaurante donde trabaja linguini.
%
chefcito(Rata):-
    rata(Rata, Restaurante),
    trabajaEn(Restaurante, linguini).

%
% 4. cocinaBien/2 es verdadero para una persona si su experiencia preparando ese plato es mayor a 7.
% Además, remy cocina bien cualquier plato que exista.
%
cocinaBien(Chef, Plato):-
    cocina(Chef, Plato, Experiencia), Experiencia > 7.
cocinaBien(remy, _).

%
% 5. encargadoDe/3: nos dice el encargado de cocinar un plato en un restaurante,
% que es quien más experiencia tiene preparándolo en ese lugar.
%
% "CON DUDAS SI ESTARA OK"
encargadoDe(Chef, Plato, Restaurante):-
    cocina(Chef, Plato, Experiencia1), trabajaEn(Restaurante, Chef),
    forall(
        (cocina(OtroChef, Plato, Experiencia2), trabajaEn(Restaurante, OtroChef)),
        (Chef \= OtroChef, Experiencia1 > Experiencia2)
    ).

%
% +INFO
%
plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
% plato(nombrePrincipal, principal(Guarnicion, TiempoPrincipal))
plato(bifeDeChorizo, principal(pure, 25)).
plato(frutillasConCrema, postre(265)).
% guarniciones
% plato(Principal, guarnicion(papasFritas, Tiempo)).
% plato(Principal, guarnicion(ensalada, Tiempo)).
% Ese año, los grupos que formaron para TPs en la materia tenían nombres de postres:
% grupo chocotorta, grupo mousse de dulce de leche, etc.
grupo(chocotorta).

/*
* 6. saludable/1: un plato es saludable si tiene menos de 75 calorías.
* 6.1 En las entradas, cada ingrediente suma 15 calorías.
* 6.2 Los platos principales suman 5 calorías por cada minuto de cocción.
* Las guarniciones agregan a la cuenta total: las papasFritas 50 y el puré 20, mientras que la ensalada no aporta calorías.
* 6.3 De los postres ya conocemos su cantidad de calorías.
* Pero además, un postre también puede ser saludable si algún grupo del curso tiene ese nombre de postre.
* Usá el predicado grupo/1 como hecho y da un ejemplo con tu nombre de grupo.
*/

saludable(plato(Nombre, Plato)):-
    calorias(Plato, Calorias),
    Calorias < 75.
saludable(Postre, postre(_)):- grupo(Postre).

calorias(Entrada, Calorias):-
    ingredientes(Entrada, Ingredientes),
    length(Ingredientes, Cuantos),
    Calorias is Ingredientes*15.
calorias(Principal, Calorias):-
    coccion(Principal, Minutos),
    guarnicion(Principal, OtrosMinutos),
    Calorias is Minutos+OtrosMinutos.
calorias(postre(Calorias), Calorias).

coccion(principal(_, Minutos), Minutos).
guarnicion(principal(papasFritas, _), 50).
guarnicion(principal(pure, _), 20).
guarnicion(principal(ensalada, _), 0).

ingredientes(entrada(Ingredientes), Ingredientes).

/*
* 7. criticaPositiva/2: es verdadero para un restaurante si un crítico le escribe una reseña positiva.
* Cada crítico maneja su propio criterio, pero todos están de acuerdo en lo mismo: el lugar debe tener una
* inspección satisfactoria.
*
* 7.1 antonEgo espera, además, que en el lugar sean especialistas preparando ratatouille.
* Un restaurante es especialista en aquellos platos que todos sus chefs saben cocinar bien.
* 7.2 christophe, que el restaurante tenga más de 3 chefs.
* 7.3 cormillot requiere que todos los platos que saben cocinar los empleados del restaurante sean
*  saludables y que a ninguna entrada le falte zanahoria.
* 7.4 gordonRamsay no le da una crítica positiva a ningún restaurante.
*
*/

% PROBLEMA:
% - si uso Critico ya no es paraTodoCritico, pero si no lo uso no es inversible, entonces (?)
criticaPositiva(Restaurante, Critico):-
    restaurante(Restaurante),
    %critico(Critico, Restaurante),
    forall(
        restaurante(Restaurante),
        critico(Critico, Restaurante)
    ).

critico(gordonRamsay, Restaurante):-
    restaurante(Restaurante),
    not(restaurante(Restaurante)).

% saludable(plato(Nombre, Plato))
% cocina(Chef, Plato, Experiencia)
critico(cormillot, Restaurante):-
    restaurante(Restaurante),
    forall(
        (cocina(Chef, Plato, _), trabajaEn(Restaurante, Chef)),
        (saludable(Plato), not(leFalta(zanahoria, Plato)))
    ).

leFalta(Ingrediente, Entrada):-
    ingredientes(Entrada, Ingredientes),
    not(member(Ingrediente, Ingrdientes)).

critico(cristophe, Restaurante):-
    restaurante(Restaurante),
    findall(Chef, chef(Chef, Restaurante), Cuantos),
    Cuantos > 3.

critico(antonEgo, Restaurante):-
    especialistaEn(ratatouille, Restaurante).

% cocinaBien(Chef, Plato)
% chef(Chef, Restaurante)
especialistaEn(Plato, Restaurante):-
    restaurante(Restaurante), plato(Plato, _),
    forall(
        chef(Chef, Restaurante),
        cocinaBien(Chef, Plato)
    ).

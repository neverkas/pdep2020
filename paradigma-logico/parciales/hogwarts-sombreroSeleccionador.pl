%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parte 1 - Sombrero Seleccionador
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mago(harry).
mago(draco).
mago(hermione).
%otros
mago(manu).
mago(juani).
mago(joel).

casa(slytherin).
casa(hufflepuff).
casa(ravenclaw).
casa(gryffindor).

sangre(harry, mestiza).
sangre(juani, mestiza).
sangre(draco, pura).
sangre(manu, pura).
sangre(hermione, impura).

caracteristica(coraje, harry).
caracteristica(amistoso, harry).
caracteristica(orgullo, harry).
caracteristica(inteligente, harry).

caracteristica(coraje, juani).
caracteristica(amistoso, juani).
caracteristica(orgullo, juani).
caracteristica(inteligente, juani).

caracteristica(inteligente, draco).
caracteristica(orgullo, draco).

caracteristica(inteligente, manu).
caracteristica(orgullo, manu).

caracteristica(inteligente, hermione).
caracteristica(orgullo, hermione).
caracteristica(responsable,hermione).
caracteristica(amistoso, hermione).
%otros
caracteristica(amistoso, draco).
caracteristica(amistoso, manu).
caracteristica(amistoso, juani).
caracteristica(amistoso, joel).

odia(harry, slytherin).
odia(juani, slytherin).
odia(draco, hufflepuff).
odia(manu, hufflepuff).
%% odia(hermione, Casa):-
%%     casa(Casa),
%%     not(casa(Casa)).

% caracteristica(Cual, Casa)
importante(coraje, gryffindor).

importante(orgullo, slytherin).
importante(inteligente, slytherin).

importante(inteligente, ravenclaw).
importante(responsable, ravenclaw).

importante(amistoso, hufflepuff).

% puedeEntrar
puedeEntrar(Mago, Casa):-
    mago(Mago), casa(Casa),
    permiteA(Mago, Casa).

% permiteA(Mago, Casa)
permiteA(_, ravenclaw).
permiteA(_, gryffindor).
permiteA(_, hufflepuff).
permiteA(Mago ,slytherin):-
    mago(Mago),
    not(sangre(Mago, impura)).

% apropiadoPara(Casa, Mago)
apropiadoPara(Casa, Mago):-
    casa(Casa), mago(Mago),
    forall(
        importante(Caracteristica, Casa),
        caracteristica(Caracteristica, Mago)
    ).

seleccionado(Mago, Casa):-
    apropiadoPara(Casa, Mago),
    permiteA(Mago, Casa),
    not(odia(Mago, Casa)).

seleccionado(hermione, gryffindor).

/*
Definir un predicado cadenaDeAmistades/1 que se cumple para una lista de magos
 si todos ellos se caracterizan por ser amistosos y cada uno podría estar en la
 misma casa que el siguiente. No hace falta que sea inversible, se consultará
 de forma individual.
*/

cadenaDeAmistades(ListaMagos):-
    sonAmistosos(ListaMagos),
    puedenEstarMismaCasa(ListaMagos).

sonAmistosos([Mago]):-
    caracteristica(amistoso, Mago).
sonAmistosos([Mago|OtrosMagos]):-
    mago(Mago),
    caracteristica(amistoso, Mago),
    not(member(Mago, OtrosMagos)),
    sonAmistosos(OtrosMagos).

puedenEstarMismaCasa([Mago1,Mago2]):-
    seleccionado(Mago1, Casa1), seleccionado(Mago2, Casa2),
    Casa1 = Casa2, Mago1\=Mago2.
puedenEstarMismaCasa([Mago1,Mago2|OtrosMagos]):-
    %% casa(Casa1), casa(Casa2),
    seleccionado(Mago1, Casa1), seleccionado(Mago2, Casa2),
    Casa1 = Casa2, Mago1\=Mago2,
    puedenEstarMismaCasa(OtrosMagos).

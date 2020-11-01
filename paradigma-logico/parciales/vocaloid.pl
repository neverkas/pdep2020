/*
- De cada vocaloid (o cantante) se conoce el nombre y además la canción que sabe cantar.
- De cada canción se conoce el nombre y la cantidad de minutos de duración.

- megurineLuka sabe cantar la canción nightFever cuya duración es de 4 min y 
también canta la canción foreverYoung que dura 5 minutos.    
- hatsuneMiku sabe cantar la canción tellYourWorld que dura 4 minutos.
- gumi sabe cantar foreverYoung que dura 4 min y tellYourWorld que dura 5 min
- seeU sabe cantar novemberRain con una duración de 6 min y nightFever con una duración de 5 min.
- kaito no sabe cantar ninguna canción.
*/

% sabeCantar(Cantante, cancion(Cancion))
% cancion(Nombre, DuracionEnMinutos)

sabeCantar(megurineLuka, cancion(nightFever, 4)).
sabeCantar(megurineLuka, cancion(foreverYoung, 5)).

sabeCantar(hatsuneMiku, cancion(tellYourWorld,4 )).

sabeCantar(gumi, cancion(foreverYoung, 4)).
sabeCantar(gumi, cancion(tellYourWorld, 5)).

sabeCantar(seeU, cancion(novemberRain, 6)).
sabeCantar(seeU, cancion(nightFever, 5)).

% extra
sabeCantar(mad, cancion(tururu, 2)).
sabeCantar(mad, cancion(tururu, 3)).


% sabeCantar(kaito, Cancion):-
%    cancion(Cancion),
%    not(cancion(Cancion)).

% extra
cancion(Cancion):- sabeCantar(_, Cancion).
cantante(Cantante):- sabeCantar(Cantante, _).
/*
1. Para comenzar el concierto, es preferible introducir primero a los cantantes más novedosos, 
por lo que necesitamos un predicado para saber si 
"un vocaloid es novedoso cuando" 
>>> saben al menos  2 canciones y el tiempo total que duran todas las canciones debería ser menor a 15.
*/

novedoso(Cantante):-
    sabeAlMenosDosCanciones(Cantante),
    tiempoTotalCanciones(Cantante, TiempoTotalCanciones),
    TiempoTotalCanciones < 15.

sabeAlMenosDosCanciones(Cantante):-
    sabeCantar(Cantante, Cancion1),
    sabeCantar(Cantante, Cancion2),
    Cancion1 \= Cancion2.

tiempoTotalCanciones(Cantante, TiempoTotal):-
    cantante(Cantante),
    findall(
        Tiempo,
        sabeCantar(Cantante, cancion(_, Tiempo)),
        Tiempos
    ), sumlist(Tiempos, TiempoTotal).


/*
2. Hay algunos vocaloids que simplemente no quieren cantar canciones largas porque no les gusta, 
es por eso que 
>>se pide saber si  "un cantante es acelerado",
- condición que se da cuando todas sus canciones duran 4 minutos o menos. (canciones cortas)
Resolver sin usar forall/2.
*/

% sabeCantar(megurineLuka, cancion(foreverYoung, 5)).
acelerado(Cantante):-
    cantante(Cantante),
    not((sabeCantar(Cantante, Cancion), not(cancionCorta(Cancion)))).

cancionCorta(cancion(_, Duracion)):-
    Duracion =< 4.


/*
demás de los vocaloids, conocemos información acerca de varios conciertos que se darán en un futuro no muy lejano.
De cada concierto se sabe 
-su nombre, 
-el país donde se realizará, 
-una cantidad de fama 
-y el tipo de concierto.
*/

/*
- Miku Expo, 
    - es un concierto gigante que se va a realizar en Estados Unidos, 
    - le brinda 2000 de fama al vocaloid que pueda participar en él 
     y pide que el vocaloid sepa más de 2 canciones y el tiempo mínimo de 6 minutos.    

Magical Mirai, 
    - se realizará en Japón y también es gigante, 
    - pero da una fama de 3000
    - y pide saber más de 3 canciones por cantante con un tiempo total mínimo de 10 minutos. 
Vocalekt Visions, 
    - se realizará en Estados Unidos 
    - y es mediano brinda 1000 de fama 
    - y exige un tiempo máximo total de 9 minutos.    
Miku Fest, 
    - se hará en Argentina 
    - y es un concierto pequeño que solo da 100 de fama al vocaloid que participe en él, 
    - con la condición de que sepa una o más canciones de más de 4 minutos.
*/

/*
1. Modelar los conciertos y agregar en la base de conocimiento todo lo necesario.
*/
% concierto(Nombre, Pais, Fama, Requisito).
% concierto(mikuExpo, estadosUnidos, 2000, gigante(MinimoCanciones, DuracionCanciones)):-

concierto(mikuExpo, estadosUnidos, 2000, gigante(2, 6)).
concierto(magical, japon, 3000, gigante(3, 10)).
concierto(vocalekt, estadosUnidos, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequenio(4)).

%% Quizas mejor usar functores (?) 

tipoConcierto(Nombre, Tipo):-
    concierto(Nombre, _, _, Tipo).
famaDe(Concierto, CantidadFama):-
    concierto(Concierto, _, CantidadFama, _).
/*
2. Se requiere saber si un vocaloid "puede participar en un concierto", 
- esto se da cuando cumple los requisitos del tipo de concierto. 
- También sabemos que Hatsune Miku puede participar en cualquier concierto.
*/

puedeParticipar(Cantante, Concierto):-
    cantante(Cantante),
    tipoConcierto(Concierto, Requisito),
    cumple(Cantante, Requisito).
puedeParticipar(hatsuneMiku, Concierto):-
    concierto(Concierto,_,_,_).
/*
- gigante del cual se sabe 
    - la cantidad mínima de canciones que el cantante tiene que saber 
    - y además la duración total de todas las canciones tiene que ser mayor a una cantidad dada.
*/
cumple(Cantante, gigante(MinimoCanciones, DuracionCanciones)):-
    
    %cantante(Cantante),
    cancionesQueCanta(Cantante, CantidadCanciones),
    tiempoTotalCanciones(Cantante, DuracionTotal),

    CantidadCanciones > MinimoCanciones,
    DuracionTotal > DuracionCanciones.

/*
- mediano sólo pide que 
    - la duración total de las canciones del cantante sea menor a una cantidad determinada.
*/
cumple(Cantante, mediano(DuracionCanciones)):-
    %cantante(Cantante),
    tiempoTotalCanciones(Cantante, DuracionTotal),
    DuracionTotal < DuracionCanciones.

/*
-pequeño el único requisito es que 
    - alguna de las canciones dure más de una cantidad dada.
*/
cumple(Cantante, pequenio(DuracionCanciones)):-
    %cantante(Cantante),
    sabeCantar(Cantante, cancion(_, Tiempo)),
    Tiempo > DuracionCanciones.

cancionesQueCanta(Cantante, Cantidad):-
    cantante(Cantante),
    findall(
        Cancion,
        sabeCantar(Cantante, Cancion),
        Canciones
    ), length(Canciones, Cantidad).


/*
3. Conocer el vocaloid "más famoso", es decir con mayor nivel de fama. 
El nivel de fama de un vocaloid se calcula como 
- la fama total que le dan los conciertos en los cuales  puede participar multiplicado por la cantidad de canciones 
que sabe cantar.
*/

/*
masFamoso(Cantante1):-
    nivelDeFama(Cantante1, Nivel1),
    forall(
        (nivelDeFama(Cantante2, Nivel2), Cantante1 \= Cantante2),
        Nivel1 > Nivel2
    ).
*/
masFamoso(Cantante1):-
    cantante(Cantante1),
    %nivelDeFama(Cantante1, Nivel1),
    %not((nivelDeFama(Cantante2, Nivel2),Cantante2\=Cantante1, Nivel1 =< Nivel2)).
    forall(
        (cantante(Cantante2), Cantante1 \= Cantante2),
        tieneMasFama(Cantante1, Cantante2)
    ).

tieneMasFama(Cantante1, Cantante2):-
    nivelDeFama(Cantante1, Nivel1),
    nivelDeFama(Cantante2, Nivel2),
    Nivel1 > Nivel2.

nivelDeFama(Cantante, Nivel):-
    famaTotal(Cantante, FamaTotal),
    cancionesQueCanta(Cantante, CantidadCanciones),
    Nivel is FamaTotal * CantidadCanciones.

famaTotal(Cantante, FamaTotal):-
    cantante(Cantante),
    findall(
        Fama,
        (distinct(puedeParticipar(Cantante, Concierto)), famaDe(Concierto, Fama)),
        FamaCantidad
    ), sumlist(FamaCantidad, FamaTotal).

/*
4. Sabemos que:
megurineLuka conoce a hatsuneMiku  y a gumi 
gumi conoce a seeU
seeU conoce a kaito
*/

conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).
conoce(pedro, perez).
conoce(fede, carlitos).

conocido(Cantante, Conocido):-
    conoce(Cantante, Conocido).
conocido(Cantante, Conocido):-
    conoce(Cantante, OtroConocido),
    conocido(OtroConocido, Conocido).

/*
Queremos verificar si un vocaloid es "el único que participa de un concierto",  esto se cumple 
- si ninguno de sus conocidos ya sea directo o indirectos (en cualquiera de los niveles) 
participa en el mismo concierto.
*/


unicoEnParticipar(Cantante):-
    puedeParticipar(Cantante, Concierto),
    not(conocidoParticipa(Cantante, Concierto)).
/*
unicoEnParticipar(Cantante):-
    puedeParticipar(Cantante, Concierto),
    forall(
        conocido(Cantante, Conocido),
        not(puedeParticipar(Conocido, Concierto))
    ).
*/
conocidoParticipa(Cantante, Concierto):-
    conocido(Cantante, Conocido),
    puedeParticipar(Conocido, Concierto).


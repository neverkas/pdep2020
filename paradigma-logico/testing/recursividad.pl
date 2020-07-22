/*
% hechos
% tarea(cual, tiempo)
tarea(a,10).
tarea(b,10).
tarea(c,10).
tarea(d,10).

% precede(TareaAnterior, Tarea)
precede(a, b).
precede(b, c).
precede(c, d).

anterior(TareaAnterior, Tarea):-
%%    tarea(TareaAnterior, _),
%%    tarea(Tarea, _),
    precede(TareaAnterior, Tarea).

anterior(TareaAnterior, Tarea):-
    tarea(TareaAnteriorAnterior, _),
    precede(TareaAnterior, Tarea),
	  anterior(TareaAnteriorAnterior, TareaAnterior).
*/

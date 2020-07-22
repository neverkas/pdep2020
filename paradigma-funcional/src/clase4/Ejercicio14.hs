module Clase4Ejercicio14 where

{-
Clase 4 - Ejercicio 14 - aparearCon
https://mumuki.io/nym/exercises/1889-programacion-funcional-practica-recursividad-zipwith
-}

aparearCon :: (a->a->a) -> [a]-> [a] -> [a]

aparearCon _ [] [] = []
aparearCon _ listaA [] = listaA
aparearCon _ [] listaB = listaB
aparearCon funcion (cabezaListaA:colaListaA) (cabezaListaB:colaListaB) =
  (funcion cabezaListaA cabezaListaB) : aparearCon funcion colaListaA colaListaB

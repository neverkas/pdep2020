module Clase4Ejercicio3 where

{-
Clase 4 - Listas
https://mumuki.io/nym/exercises/1687-programacion-funcional-practica-listas-rotar
-}

rotar :: [a] -> [a]

rotar [] = []
rotar (x:xs) = xs++[x]

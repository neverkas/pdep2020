{-
Clase 4 - Listas
https://mumuki.io/nym/exercises/1687-programacion-funcional-practica-listas-rotar
-}
module Clase4Ejercicio3

rotar :: [a] -> [a]

rotar [] = []
rotar (x:xs) = xs++[x]

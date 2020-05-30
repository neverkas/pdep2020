{-
Clase 4 - Ejercicio 4
Mumuki Ejercicio 18: Iniciales
https://mumuki.io/nym/exercises/1688-programacion-funcional-practica-listas-iniciales
-}
primerasLetras :: [String] -> String
primerasLetras = map(head)

palabrasConMasDeUnaLetra :: [String] -> [String]
palabrasConMasDeUnaLetra = filter ((>1).length)

listarPalabras :: String -> [String]
listarPalabras = words

iniciales :: String -> String
iniciales =
 primerasLetras
 .palabrasConMasDeUnaLetra
 .listarPalabras
-- map (head) . filter((>1).length) . words
 

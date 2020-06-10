module ParcialExpertosEnMaquinitas where

import Text.Show.Functions

--
-- # Datos
--
data Persona = UnaPersona String Float Int [(String,Int)] deriving(Show)
nombre (UnaPersona nombre _ _ _) = nombre
dinero (UnaPersona _ dinero _ _) = dinero
suerte (UnaPersona _ _ suerte _) = suerte
factores (UnaPersona _ _ _ factores) = factores

type Factor = (String, Int)
valorDelFactor = snd
nombreDelFactor = fst


--
-- # Punto 1
--
suerteTotalDe :: Persona -> Int
suerteTotalDe persona
  | tieneFactor "amuleto" persona = ((*) suerteDeLaPersona.valorDelFactor.encontrarFactor "amuleto") persona
  | otherwise = suerteDeLaPersona
  where suerteDeLaPersona = suerte persona

-- hacer refactor luego
tieneFactor :: String -> Persona -> Bool
tieneFactor nombre persona =
  (elem nombre.map (nombreDelFactor).factores) persona && ((>0).valorDelFactor.encontrarFactor nombre) persona

encontrarFactor :: String -> Persona -> Factor
encontrarFactor nombreDelFactor persona =  (head.filter ((== nombreDelFactor).fst)) (factores persona)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

--
-- # Punto 2
--

--type Apuesta = Int -> (Int -> Int)
type Criterio = Persona -> Bool

data Juego = UnJuego{
  nombreDelJuego :: String,
  -- cuantoGanariaSegun :: Float,
  cuantoGanaria :: Float->Float,
  criterios :: [Criterio]
}

--type Apuesta = Float -> (Float->Float) -> Float

-- no sirve esto, porque es una apuesta inicial para todos los juegos
-- ruleta :: Float -> Juego
-- ruleta cuantoApuesta = UnJuego{
ruleta :: Juego
ruleta = UnJuego{
 nombreDelJuego = "ruleta",
 -- cuantoGanariaSegun = dineroApostado cuantoApuesta (*37),
 cuantoGanaria = (*37),
 criterios = [tieneSuerteTotal (>80)]
}

maquinita :: Juego
maquinita = UnJuego{
  nombreDelJuego = "maquinita",
  -- cuantoGanariaSegun = dineroApostado cuantoApuesta (+1),
  cuantoGanaria = (+50),
  criterios = [tieneSuerteTotal (>95), tieneFactor "paciencia"]
}

--dineroApostado :: Apuesta
--dineroApostado cuantoApuesta criterio =  criterio cuantoApuesta

tieneSuerteTotal :: (Int->Bool) -> Persona -> Bool
tieneSuerteTotal cuanto persona = (cuanto.suerteTotalDe) persona
-- tieneSuerteTotal cuanto persona = cuanto (suerte persona)

--
-- # Punto 3
--

puedeGanar :: Persona -> Juego -> Bool
puedeGanar unaPersona esteJuego = all (\criterio->criterio unaPersona) (criterios esteJuego)

--
-- # Punto 4
--

-- Resolucion con fold
apostarEnVariosJuegos :: Persona -> Float -> [Juego] -> Float
apostarEnVariosJuegos unaPersona apuestaInicial variosJuegos =
  --(sum .foldl (hacerApuesta unaPersona) [apuestaInicial]) variosJuegos
   foldl (hacerApuesta unaPersona) apuestaInicial variosJuegos

hacerApuesta :: Persona -> Float -> Juego -> Float
hacerApuesta persona apuestaInicial juego
  -- | puedeGanar persona juego = apuestaInicial + ((cuantoGanaria juego) apuestaInicial)
  -- | puedeGanar persona juego = ((+) apuestaInicial.cuantoGanaria juego) apuestaInicial
   | puedeGanar persona juego = sumarDineroGanadoEn juego apuestaInicial
   | otherwise = apuestaInicial

sumarDineroGanadoEn :: Juego -> Float -> Float
sumarDineroGanadoEn juego apuesta = ((+) apuesta.cuantoGanaria juego) apuesta

apostarEnVariosJuegos' :: Persona -> Float -> [Juego] -> Float
apostarEnVariosJuegos' _ _ [] = 0
apostarEnVariosJuegos' unaPersona apuestaInicial (juego1:juegosSiguientes)
  | puedeGanar unaPersona juego1 = acumularApuesta + apostarEnVariosJuegos' unaPersona apuestaInicial juegosSiguientes
    --((+) apuestaInicial.cuantoGanaria juego1) apuestaInicial + apostarEnVariosJuegos' unaPersona apuestaInicial juegosSiguientes
  | otherwise = 0
  -- si usaba este otherwise le estaba dando plata de mas.. (si gana uno ya lo tiene acumulado al principio)
  -- | otherwise = apuestaInicial
  where acumularApuesta = sumarDineroGanadoEn juego1 apuestaInicial


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

--
-- # Punto 5
--

noPuedenGanarNingunJuego :: [Persona] -> [Juego] -> [String]
noPuedenGanarNingunJuego personas juegos = (map (nombre).filter (not.puedeGanarTodos juegos) ) personas

puedeGanarTodos :: [Juego] -> Persona -> Bool
puedeGanarTodos juegos persona = all (puedeGanar persona) juegos

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


--
-- # Punto 6
--

apostarAunJuego :: Float -> Persona -> Juego -> Persona
apostarAunJuego montoDeApuesta persona juego
  | puedeGanar persona juego = (cambiarDineroEn ((+) montoGanado) . cobrarleApuesta) persona
  | otherwise = cobrarleApuesta persona
  where montoGanado = sumarDineroGanadoEn juego montoDeApuesta
        cobrarleApuesta persona = cambiarDineroEn (flip (-) montoDeApuesta) persona

cambiarDineroEn :: (Float->Float) -> Persona -> Persona
cambiarDineroEn cuantoCambiar (UnaPersona nombre dinero suerte factores) =
  UnaPersona nombre (cuantoCambiar dinero) suerte factores

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

--
-- Punto #7
--
elCocoEstaEnLaCasa ::
   (Ord a, Num a, Foldable t) =>        (x1,[a])  -> (c->   [a])     -> a ->  t([a]  -> [a],  c) -> Bool
-- (Ord z, Num y, Num b) =>             (x1,a)    -> (c->[y])        -> z ->  [(a      ->[b],   c)] -> Bool
-- 1. las listas que reciban los fold, son foldable por tanto "Foldable t" y la lista es "t([a]->[b], c)" sin corchetes
-- 2. los foldl devuelven algo del mismo tipo que la semilla, en este caso ([a]->[a], c)
-- 3. la semilla que era la segunda componente del primer parametro "x" era una lista [a] que le aplica una funcion b
-- 4. la segunda componente de "x", el valor que devuelve "y", el valor de "z" son todos enteros por tanto Num a (los generalizo)
--    lo mismo aplica para la primera componente de la lista fodable t1([a]->[a], c)
--     Observacion: Esto es porque sino son del mismo tipo no se pueden comparar con <,>, ni concatenar con ++

elCocoEstaEnLaCasa x y z = all ((>z).(+42)).foldl (\a (b,c) -> y c ++ b a) (snd x)


--
-- # Simulacion de codigo
--

nico = (UnaPersona "Nico" 200.0 30 [("amuleto", 3), ("manos magicas",100)])
maiu = (UnaPersona "Maiu" 100.0 42 [("inteligencia",55), ("paciencia",50)])

fede = (UnaPersona "Fede" 900.0 100 [("manos magicas",100)])
pedro = (UnaPersona "Pedro" 1500.0 90 [("paciencia",10), ("amuleto", 10), ("manos magicas",100)])
carlitos = (UnaPersona "Carlitos" 3100.0 90 [("paciencia",10), ("amuleto", 10), ("manos magicas",100)])

simularSuerte = suerteTotalDe nico
simularSuerte' = suerteTotalDe maiu

simularApuestaNico = apostarEnVariosJuegos nico 5000 [ruleta, maquinita]
simularApuestaNico' = apostarEnVariosJuegos' nico 5000 [ruleta, maquinita]

simularApuestaMaiu' = apostarEnVariosJuegos' maiu 5000 [ruleta, maquinita]
simularApuestaMaiu = apostarEnVariosJuegos maiu 5000 [ruleta, maquinita]

simularNoPuedenGanarNingunJuego = noPuedenGanarNingunJuego [nico,maiu, fede, pedro, carlitos] [ruleta, maquinita]

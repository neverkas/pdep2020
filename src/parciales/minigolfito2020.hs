module ParcialMinigolfito2020 where

import Text.Show.Functions

-- # DATOS
data Jugador = UnJugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Int,
  precisionJugador :: Int
} deriving (Eq, Show)

bart = UnJugador "Bart" "Homero" (Habilidad 25 60)
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = UnTiro {
  velocidad :: Int,
  precision :: Int,
  altura :: Int
} deriving (Eq, Show)

type Puntos = Int

between n m x = elem x [n .. m]

maximoSegun f = foldl1 (mayorSegun f)
mayorSegun f a b
  | f a > f b = a
  | otherwise = b

-- # PUNTO 1
type Palo = Habilidad -> Tiro

putter :: Palo
putter (Habilidad _ precision) = UnTiro 10 (elDobleDe precision) 0

madera :: Palo
madera (Habilidad _ precision) = UnTiro 100 (laMitadDe precision) 5

hierros :: Int -> Palo
hierros suNumero (Habilidad fuerza precision) =
  UnTiro (fuerza*suNumero) (div precision suNumero) (queNoSeaMenorACero suNumero-3)


-- Revisar
palos :: [Palo]
palos = putter : madera : listaDeHierros
listaDeHierros = map hierros [1..10]

queNoSeaMenorACero :: Int -> Int
queNoSeaMenorACero = max 0

elDobleDe :: Int -> Int
elDobleDe = (*2)

laMitadDe :: Int -> Int
laMitadDe = flip div 2

-- # PUNTO 2

golpe :: Jugador -> Palo -> Tiro
golpe porQuien conEstePalo = conEstePalo (habilidad porQuien)

-- # PUNTO 3
type Efecto = Tiro -> Tiro
type Condicion = Tiro -> Bool
-- data Obstaculo = UnObstaculo{
--   condicion :: Bool,
--   efecto :: Tiro
-- }

type Obstaculo = Tiro -> (Bool, Tiro)
condicion (suCondicion, _) = suCondicion
efecto (_, suEfecto) = suEfecto
-- me parece que con data queda mas ordenado..
--type Obstaculo = Tiro -> (Condicion, Efecto)

tunelConRampita :: Obstaculo
tunelConRampita unTiro =
  (compararEntre altura (==0) unTiro && compararEntre precision (>90) unTiro,
  -- condicion = suAlturaEs ((==) 0) unTiro && suPrecisionEs ((>) 90) unTiro,
  -- efecto = (cambiarA precision (+100). cambiarA velocidad (*2)) unTiro
  (cambiarPrecisionA ((+100).(*0)).cambiarVelocidadA (*2)) unTiro)
{-
unaLaguna :: Int -> Tiro -> Obstaculo
unaLaguna suLargoEs unTiro = UnObstaculo{
  -- condicion = laVelocidadEs (>80) unTiro && suAlturaEs (between 1 5) unTiro,
  condicion = compararEntre velocidad (>80) unTiro && compararEntre altura (between 1 5) unTiro,
  -- se podia mejorar la expresividad
  -- efecto = cambiarAlturaA (flip div suLargoEs) unTiro
  efecto = cambiarAlturaA (divididoPor suLargoEs) unTiro
}

unHoyo :: Tiro -> Obstaculo
unHoyo unTiro = UnObstaculo{
  -- condicion = elTiroEs (between 5 20) unTiro && suAlturaEs (==0) unTiro && suPrecisionEs (>95) unTiro,
  condicion = compararEntre velocidad (between 5 20) unTiro && compararEntre altura (==0) unTiro && compararEntre precision (>95) unTiro,
  -- efecto = (cambiarAlturaA (*0).cambiarVelocidadA (*0).cambiarPrecisionA (*0)) unTiro
  efecto = cambiarAtributosAcero unTiro
}
-}
tiroLuegoDelObstaculo :: Tiro -> Obstaculo -> Tiro
tiroLuegoDelObstaculo esteTiro unObstaculo
  | superaElObstaculo = producirEfecto
  | otherwise = cambiarAtributosAcero esteTiro
  where superaElObstaculo = condicion (unObstaculo esteTiro)
        producirEfecto = efecto (unObstaculo esteTiro)

-- PENDIENTE: creo que no se puede hacer tan generico..
-- cambiarA :: Atributo -> (Int->Int) -> Efecto
-- cambiarA suAtributo porCuanto esteTiro = (porCuanto.suAtributo) esteTiro

cambiarAtributosAcero :: Efecto
cambiarAtributosAcero unTiro = (cambiarAlturaA (*0).cambiarVelocidadA (*0).cambiarPrecisionA (*0)) unTiro

divididoPor :: Int -> (Int -> Int)
divididoPor cuanto = flip div cuanto

cambiarPrecisionA :: (Int->Int) -> Efecto
cambiarPrecisionA porCuanto (UnTiro velocidad precision altura) =
  UnTiro velocidad (porCuanto precision) altura

cambiarAlturaA :: (Int->Int) -> Efecto
cambiarAlturaA porCuanto (UnTiro velocidad precision altura) =
  UnTiro velocidad precision (porCuanto altura)

cambiarVelocidadA :: (Int->Int) -> Efecto
cambiarVelocidadA porCuanto (UnTiro velocidad precision altura) =
  UnTiro (porCuanto velocidad) precision altura

type Atributo = Tiro->Int
compararEntre :: Atributo -> (Int->Bool) -> Condicion
compararEntre suAtributo esteCriterio esteTiro = (esteCriterio.suAtributo) esteTiro
-- repeticion de logica por cada atributo..
-- suAlturaEs :: (Int->Bool) -> Condicion
-- suAlturaEs criterio esteTiro = (criterio.altura) esteTiro
-- suPrecisionEs :: (Int->Bool) -> Condicion
-- suPrecisionEs criterio esteTiro = (criterio.precision) esteTiro

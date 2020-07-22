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


palos :: [Palo]
palos = putter : madera : listaHierros
listaHierros = map hierros [1..10]

queNoSeaMenorACero :: Int -> Int
queNoSeaMenorACero = max 0

elDobleDe :: Int -> Int
elDobleDe = (*2)

laMitadDe :: Int -> Int
laMitadDe = flip div 2

-- # PUNTO 2

golpe :: Jugador -> Palo -> Tiro
golpe porQuien conEstePalo = (conEstePalo.habilidad) porQuien
-- se podia mejorar!! usando composicicon, porque.. palo es una funcion, y habilidad tambien
-- golpe porQuien conEstePalo = conEstePalo (habilidad porQuien)


-- # PUNTO 3
type Condicion = Tiro -> Bool
type Efecto = Tiro -> Tiro

type Obstaculo = Tiro -> (Bool, Tiro)
--type Obstaculo = Tiro -> (Condicion, Efecto)
condicion (suCondicion, _) = suCondicion
efecto (_, suEfecto) = suEfecto

data Obstaculo' = UnObstaculo{
   condicion' :: Bool,
   efecto' :: Tiro
}

-- Obstaculo con DATA
unHoyo' :: Tiro -> Obstaculo'
unHoyo' unTiro = UnObstaculo{
  condicion' = all (\condicion -> condicion unTiro) [compararEntre velocidad (between 5 20), compararEntre altura (==0)],
  efecto' = cambiarAtributosAcero unTiro
}

unaLaguna' :: Int -> Tiro -> Obstaculo'
unaLaguna' suLargoEs unTiro = UnObstaculo{
  condicion' = all (\condicion -> condicion unTiro) [compararEntre velocidad (>80), compararEntre altura (between 1 5)],
  efecto' = cambiarAlturaA (divididoPor suLargoEs) unTiro
}

-- Obstaculo como FUNCION (usando Type)
tunelConRampita :: Obstaculo
tunelConRampita unTiro =
  (compararEntre altura (==0) unTiro && compararEntre precision (>90) unTiro,
  -- condicion = suAlturaEs ((==) 0) unTiro && suPrecisionEs ((>) 90) unTiro,
  -- efecto = (cambiarA precision (+100). cambiarA velocidad (*2)) unTiro
  (cambiarPrecisionA ((+100).(*0)).cambiarVelocidadA (*2)) unTiro)

unaLaguna :: Int -> Obstaculo
unaLaguna suLargoEs unTiro =
  (compararEntre velocidad (>80) unTiro && compararEntre altura (between 1 5) unTiro,
  cambiarAlturaA (divididoPor suLargoEs) unTiro)

unHoyo :: Obstaculo
unHoyo unTiro =
  (compararEntre velocidad (between 5 20) unTiro && compararEntre altura (==0) unTiro && compararEntre precision (>95) unTiro,
  cambiarAtributosAcero unTiro)

tiroLuegoDelObstaculo :: Tiro -> Obstaculo -> Tiro
tiroLuegoDelObstaculo esteTiro unObstaculo
  | superaElObstaculo = producirEfecto
  | otherwise = cambiarAtributosAcero esteTiro
   where superaElObstaculo = condicion (unObstaculo esteTiro)
         producirEfecto = efecto (unObstaculo esteTiro)

-- PENDIENTE: creo que no se puede hacer tan generico..
-- cambiarA :: Atributo -> (Int->Int) -> Efecto
-- cambiarA suAtributo porCuanto esteTiro = (porCuanto.suAtributo) esteTiro

-- Es mas claro y preciso si dice "tiro detenido"
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

-- # PUNTO 4
palosUtiles :: Jugador -> Obstaculo -> [Palo]
palosUtiles conEsteJugador esteObstaculo =
  filter (esUtilCon esteObstaculo.golpe conEsteJugador) palos

esUtilCon :: Obstaculo -> Tiro -> Bool
--esUtilCon esteObstaculo esteTiro = condicion (esteObstaculo esteTiro)
-- de esta manera utilizo composicicion
esUtilCon esteObstaculo esteTiro = (condicion.esteObstaculo) esteTiro

-- Ojo..!! No esta bien, deberias resolverlo con takeWhile y fold..
-- Porque pide que sean tiros consecutivos, que se vayan modificando al pasar por cada obstaculo..
cuantosObstaculosSupera :: [Obstaculo] -> Tiro -> Int
cuantosObstaculosSupera variosObstaculos esteTiro =
  -- (contarCuantos.takeWhile (flip esUtilCon esteTiro)) variosObstaculos
  -- estabas repitiendo logica, ya existia una funcion esUtilCon que hacia lo mismo
   (contarCuantos.takeWhile (esSuperadoPor esteTiro)) variosObstaculos
  --(contarCuantos.filter (esSuperadoPor esteTiro)) variosObstaculos

-- estabas repitiendo logica, ya existia una funcion esUtilCon que hacia lo mismo
esSuperadoPor :: Tiro -> Obstaculo -> Bool
esSuperadoPor esteTiro unObstaculo = condicion (unObstaculo esteTiro)
-- de esta manera utilizo composicion
-- esSuperadoPor esteTiro unObstaculo = (condicion.unObstaculo) esteTiro

contarCuantos :: [a] -> Int
contarCuantos deEstaLista = length deEstaLista

paloMasUtil :: Jugador -> [Obstaculo] -> Palo
paloMasUtil esteJugador variosObstaculos =
  maximoSegun (cuantosSupera esteJugador variosObstaculos) palos
--  foldl1 (cualSuperaMas esteJugador variosObstaculos) palos

cuantosSupera :: Jugador -> [Obstaculo] -> Palo -> Int
cuantosSupera jugador obstaculos = cuantosObstaculosSupera obstaculos.golpe jugador
-- el enunciado ya te daba una funcion..
--cualSuperaMas :: Jugador -> [Obstaculo] -> Palo -> Palo -> Palo
-- cualSuperaMas jugador obstaculos paloA paloB
 --  | cuantosSupera paloA > cuantosSupera paloB = paloA
--   | otherwise = paloB
--   where cuantosSupera = cuantosObstaculosSupera obstaculos.golpe jugador

-- # PUNTO 5
type Padre = String
type InfoDelJugador = (Jugador, Puntos)
--susPuntos (_, puntos) = puntos
elJugador = fst
susPuntos = snd

--losPadresQuePerdieronApuesta :: [InfoDelJugador] -> [Padre]
-- losPadresQuePerdieronApuesta variosNinios =
--   (losPadresSon.filter (mayorSegun susPuntos)) variosNinios

-- losPadresSon :: [InfoDelJugador] -> [String]
-- losPadresSon deEstosNinios = map (padre.fst) deEstosNinios

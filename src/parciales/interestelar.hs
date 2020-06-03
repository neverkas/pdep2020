module ParcialInterestelar where

-- DATOS
data Planeta = UnPlaneta String Posicion (Int->Int)
type Posicion = (Float, Float, Float)
posicion (UnPlaneta _ p _) = p
tiempo (UnPlaneta _ _ t) = t
coordX (x,_,_) = x
coordY (_,y,_) = y
coordZ (_,_,z) = z

data Astronauta = UnAstronauta String Int Planeta
nombre (UnAstronauta n _ _) = n
edad (UnAstronauta _ e _) = e
planeta (UnAstronauta _ _ p) = p

--
-- # PUNTO 1
--
type Distancia = Float
type Coordenadas = [Float]

coordenadas :: Planeta -> Coordenadas
coordenadas planeta = map (\coordenada -> coordenada.posicion $ planeta) [coordX, coordY, coordZ]

distanciaEntre :: Planeta -> Planeta -> Distancia
distanciaEntre unPlaneta =
  (calcularCadaPosicicion $ coordenadas unPlaneta) . coordenadas

calcularCadaPosicicion :: Coordenadas -> Coordenadas -> Float
calcularCadaPosicicion coordenadasA = sum . zipWith (elModuloEntre) coordenadasA

elModuloEntre :: Float -> Float -> Float
elModuloEntre unNumero otroNumero =
  (^2) $ unNumero - otroNumero

laRaizDe :: Float -> Float
laRaizDe = sqrt

type Velocidad = Float
type Tiempo = Float
tiempoEnViajarA :: Planeta -> Planeta -> Velocidad -> Tiempo
tiempoEnViajarA desde hasta =
  flip (/) (distanciaEntre desde hasta)
  --distanciaEntre desde hasta `div`
-- Obs: NO uso div porque tira error si no es entero


--
--  # PUNTO 2
--
pasarTiempoEn :: Planeta -> Astronauta -> Astronauta
pasarTiempoEn unPlaneta astronauta =
  aumentarEdadEn (tiempo unPlaneta $ edad astronauta) astronauta

pasarTiempoEn' :: Planeta -> Astronauta -> Astronauta
pasarTiempoEn' unPlaneta = undefined
--  aumentarEdadEn (tiempo unPlaneta).edad

aumentarEdadEn :: Int -> Astronauta -> Astronauta
aumentarEdadEn tiempo (UnAstronauta nombre edad planeta) =
  UnAstronauta nombre (edad+tiempo) planeta

--
-- # PUNTO 3
--

type Nave = Planeta -> Planeta -> Tiempo
type Tanques = Int

naveVieja :: Tanques -> Nave
naveVieja tanques
  | tanques < 6 = viajarA 7
  | otherwise = viajarA 10

viajarA :: Velocidad -> Nave
viajarA unaVelocidad origen =
  (*) unaVelocidad . distanciaEntre origen

viajarA' :: Velocidad -> Nave
viajarA' unaVelocidad origen destino =
  unaVelocidad * distanciaEntre origen destino


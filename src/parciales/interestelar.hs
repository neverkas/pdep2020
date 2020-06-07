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

-- # PUNTO 1
type Distancia = Float
type Coordenadas = [Float]

coordenadas :: Planeta -> Coordenadas
coordenadas planeta = map (\coordenada -> (coordenada.posicion) planeta) [coordX, coordY, coordZ]
-- otra manera sin map
--coordenadas' planeta = [(coordX.posicion) planeta, (coordY.posicion) planeta, (coordZ.posicion) planeta]

distanciaEntre :: Planeta -> Planeta -> Int
distanciaEntre unPlaneta otroPlaneta =
  (round.sumarySacarRaiz.operarCoordenadasEntre unPlaneta) otroPlaneta

operarCoordenadasEntre :: Planeta -> Planeta -> [Float]
operarCoordenadasEntre unPlaneta otroPlaneta=
  zipWith (operarCoordenadas) (coordenadas unPlaneta) (coordenadas otroPlaneta)

operarCoordenadas :: Float -> Float -> Float
operarCoordenadas unNumero otroNumero = (unNumero - otroNumero)^2

sumarySacarRaiz :: [Float] -> Float
sumarySacarRaiz coordenadas = (sqrt.sum) coordenadas

type Viaje = Planeta -> Planeta -> Int
tiempoEnViajarA :: Int -> Viaje
tiempoEnViajarA velocidad origen destino = (flip div velocidad.distanciaEntre origen) destino

--
--  # PUNTO 2
--
type Viajo = Astronauta->Astronauta

pasarTiempoEn :: Planeta -> Viajo
pasarTiempoEn unPlaneta astronauta = cambiarEdad ((+) (aniosIndicados unPlaneta astronauta)) astronauta
-- esto rompia porque... tiempo de planeta pedia tambien la edad del astronauta
-- pasarTiempoEn unPlaneta astronauta = (cambiarEdad ((+) tiempo unPlaneta)) astronauta
--  aumentarEdadEn (tiempo unPlaneta $ edad astronauta) astronauta

aniosIndicados :: Planeta -> Astronauta -> Int
aniosIndicados planeta astronauta = (tiempo planeta.edad) astronauta
-- esta otra forma no usa composicion
--aniosIndicados planeta astronauta = tiempo planeta (edad astronauta)

cambiarEdad :: (Int->Int) -> Viajo
cambiarEdad cuantosAnios (UnAstronauta nombre edad planeta) =
  UnAstronauta nombre (cuantosAnios edad) planeta
-- es mejor pasarle una funcion que recibe una operacion (*,+,-,/) para generalizar y evita repiticion de codigo
-- UnAstronauta nombre (edad+tiempo) planeta

--
-- # PUNTO 3
--
type Nave = Planeta -> Planeta -> Int

naveVieja :: Int -> Nave
naveVieja cuantosTanques
  | cuantosTanques < 6 = tiempoEnViajarA 10
  | otherwise = tiempoEnViajarA 7

naveFuturista :: Nave
naveFuturista _ _ = 0
-- no era necesario calcular nada..
-- naveFuturista = tiempoEnViajarA 1

viajarEn :: Nave -> Planeta -> Planeta -> Viajo
viajarEn nave origen destino astronauta =
  (cambiarPlanetaA destino.cambiarEdad ((+) tiempoDeViaje)) astronauta
  where tiempoDeViaje = nave origen destino

cambiarPlanetaA :: Planeta -> Astronauta -> Astronauta
cambiarPlanetaA nuevoPlaneta (UnAstronauta nombre edad planeta) = UnAstronauta nombre edad nuevoPlaneta

--
-- # Punto 4
--

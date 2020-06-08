module ParcialInterestelar where

import Text.Show.Functions

-- DATOS
data Planeta = UnPlaneta String Posicion (Int->Int) deriving(Show)
type Posicion = (Float, Float, Float)
posicion (UnPlaneta _ p _) = p
tiempo (UnPlaneta _ _ t) = t
coordX (x,_,_) = x
coordY (_,y,_) = y
coordZ (_,_,z) = z

data Astronauta = UnAstronauta String Int Planeta deriving(Show)
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
type Viajero = Astronauta->Astronauta

pasarTiempoEn :: Planeta -> Viajero
pasarTiempoEn unPlaneta astronauta = cambiarEdad ((+) (aniosIndicados unPlaneta astronauta)) astronauta
-- esto rompia porque... tiempo de planeta pedia tambien la edad del astronauta
-- pasarTiempoEn unPlaneta astronauta = (cambiarEdad ((+) tiempo unPlaneta)) astronauta
--  aumentarEdadEn (tiempo unPlaneta $ edad astronauta) astronauta

aniosIndicados :: Planeta -> Astronauta -> Int
aniosIndicados planeta astronauta = (tiempo planeta.edad) astronauta
-- esta otra forma no usa composicion
--aniosIndicados planeta astronauta = tiempo planeta (edad astronauta)

cambiarEdad :: (Int->Int) -> Viajero
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

viajarEn :: Nave -> Planeta -> Viajero
-- viajarEn :: Nave -> Planeta -> Planeta -> Viajero
viajarEn nave destino astronauta =
-- no era necesario poner el destino, porque se saca del astronauta
-- viajarEn nave origen destino astronauta =
  (cambiarPlanetaA destino.cambiarEdad (+tiempoDeViaje)) astronauta
  where tiempoDeViaje = nave (planeta astronauta) destino

cambiarPlanetaA :: Planeta -> Astronauta -> Astronauta
cambiarPlanetaA nuevoPlaneta (UnAstronauta nombre edad planeta) = UnAstronauta nombre edad nuevoPlaneta

--
-- # Punto 4
--

type Rescate = [Astronauta] -> Nave -> Planeta -> [Astronauta]
rescateA :: Astronauta -> Rescate
rescateA astronauta tripulacion nave destino =
  (viajeDeRescateDeRegresoEn nave . incluirAlaTripulacionA astronautaVarado . viajarADestino) tripulacion
   where astronautaVarado = astronautaVaradoEn destino nave astronauta
         viajarADestino = viajeDeTripulacionEn nave destino

incluirAlaTripulacionA :: Astronauta -> [Astronauta] -> [Astronauta]
incluirAlaTripulacionA astronauta tripulacion = astronauta : tripulacion

astronautaVaradoEn :: Planeta-> Nave -> Astronauta -> Astronauta
astronautaVaradoEn unPlaneta naveDeRescate astronauta =
  (pasarTiempoEn unPlaneta) astronauta

viajeDeTripulacionEn :: Nave -> Planeta -> [Astronauta] -> [Astronauta]
viajeDeTripulacionEn nave destino = map (viajarEn nave destino)

viajeDeRescateDeRegresoEn :: Nave -> [Astronauta] -> [Astronauta]
viajeDeRescateDeRegresoEn nave = map (\tripulante -> viajarEn nave (planeta tripulante) tripulante)

-- -----------------------------------------------------------------------------------------------------------


startage = naveVieja 3

pluton = UnPlaneta "Pluton" (10,10,10) (id)
jupiter = UnPlaneta "Jupiter" (50,10,10) (id)

carlitos = UnAstronauta "Carlitos" 33 pluton
pedrito = UnAstronauta "Pedrito" 33 pluton
tripulacion = replicate 5 (UnAstronauta "Rescatista" 25 pluton)

-- pruebas
quedarseEnPluton = pasarTiempoEn pluton carlitos
viajeLoco = viajarEn (naveVieja 3) jupiter carlitos
simulacionDeRescate = rescateA carlitos tripulacion startage jupiter

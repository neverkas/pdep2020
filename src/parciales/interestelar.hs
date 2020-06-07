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

distanciaEntre :: Planeta -> Planeta -> Distancia
distanciaEntre unPlaneta otroPlaneta =
  (sumarySacarRaiz.operarCoordenadasEntre unPlaneta) otroPlaneta

operarCoordenadasEntre :: Planeta -> Planeta -> [Float]
operarCoordenadasEntre unPlaneta otroPlaneta=
  zipWith (operarCoordenadas) (coordenadas unPlaneta) (coordenadas otroPlaneta)

operarCoordenadas :: Float -> Float -> Float
operarCoordenadas unNumero otroNumero = (unNumero - otroNumero)^2

sumarySacarRaiz :: [Float] -> Float
sumarySacarRaiz coordenadas = (sqrt.sum) coordenadas

type Viaje = Planeta -> Planeta -> Float
tiempoEnViajarA :: Float -> Viaje
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
{-
pasarTiempoEn' :: Planeta -> Astronauta -> Astronauta
pasarTiempoEn' unPlaneta = undefined
--  aumentarEdadEn (tiempo unPlaneta).edad

aumentarEdadEn :: Int -> Astronauta -> Astronauta
aumentarEdadEn tiempo (UnAstronauta nombre edad planeta) =
  UnAstronauta nombre (edad+tiempo) planeta
-}
--
-- # PUNTO 3
--
{-
type Nave = Planeta -> Planeta -> Int
type Tanques = Int

naveVieja :: Tanques -> Nave
naveVieja tanques
  | tanques < 6 = tiempoEnViajarA 7
  | otherwise = tiempoEnViajarA 10

naveFuturista :: Nave
naveFuturista = tiempoEnViajarA 1 -- quizas esta mal (?) el tiempo es despreciable

--viajar :: Astronauta -> Nave -> Astronauta
viajar astronauta origen destino= undefined
--  flip aumentarEdadEn astronauta

--
-- # Punto 4
--
-}

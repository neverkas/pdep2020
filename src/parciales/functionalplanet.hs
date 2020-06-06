module ParcialFunctionalPlanet where

import Text.Show.Functions

data Mascota = UnaMascota{
  nombreMascota :: String,
  edad :: Int,
  duenio :: Duenio,
  nivelEnergia :: Int,
  trucos :: [Truco],
  estaDistraida :: Bool
}deriving(Show)
type Truco = Mascota -> Mascota

-- podria hacerlo con data, pero probare de esta manera
type Duenio = (String, Int)
nombreDuenio (suNombre, _) = suNombre
aniosExperiencia (_, aniosExp) = aniosExp

sentarse :: Truco
sentarse = cambiarEnergia ((-) 5)

tomarAgua :: Truco
tomarAgua = cambiarEnergia ((+) 5)

perroMojado :: Truco
perroMojado = cambiarEnergia ((-) 5).agregarAlPrincipioDelNombre "Pobre"

hacerseElMuerto :: Truco
hacerseElMuerto = cambiarADistraido.cambiarEnergia ((+) 10)

cambiarADistraido :: Truco
cambiarADistraido (UnaMascota nombre edad duenio nivelEnergia trucos estaDistraida) =
  UnaMascota nombre edad duenio nivelEnergia trucos True

mortalTriple :: Truco
mortalTriple = agregarAniosDeExperienciaAlDuenio ((+) 10).cambiarEnergia ((-) 20)

agregarAniosDeExperienciaAlDuenio :: (Int->Int) -> Truco
agregarAniosDeExperienciaAlDuenio cuantosAnios (UnaMascota nombre edad (nombreDuenio, aniosExp) nivelEnergia trucos distraida) =
  UnaMascota nombre edad (nombreDuenio, cuantosAnios aniosExp) nivelEnergia trucos distraida

agregarAlPrincipioDelNombre :: String -> Truco
agregarAlPrincipioDelNombre unaFrase (UnaMascota nombre edad duenio nivelEnergia trucos estaDistraida)=
  UnaMascota (unaFrase++nombre) edad duenio nivelEnergia trucos estaDistraida

cambiarEnergia :: (Int->Int) -> Truco
cambiarEnergia cuantoCambia (UnaMascota nombre edad duenio nivelEnergia trucos estaDistraida) =
  UnaMascota nombre edad duenio (cuantoCambia nivelEnergia) trucos estaDistraida

-- PUNTO 1

ayudanteDeSanta :: Mascota
ayudanteDeSanta = UnaMascota{
  nombreMascota = "ayudanteDeSanta",
  edad = 10,
  duenio = ("Bart Simpson", 5),
  nivelEnergia = 50,
  estaDistraida = False,
  trucos = [sentarse, hacerseElMuerto, tomarAgua, mortalTriple]
}

bolt :: Mascota
bolt = UnaMascota{
  nombreMascota = "bolt",
  edad = 5,
  duenio = ("Penny", 1),
  nivelEnergia = 100,
  estaDistraida = False,
  trucos = [perroMojado, hacerseElMuerto, sentarse, mortalTriple]
}

laTortuga :: Mascota
laTortuga = UnaMascota{
  nombreMascota = "laTortuga",
  edad = 32,
  duenio = ("Fede Scarpa", 30),
  nivelEnergia = 30,
  estaDistraida = True,
  trucos = [tomarAgua,cuantasVecesRepetirlo 3 sentarse]
}

-- REVISAR
cuantasVecesRepetirlo :: Int -> Truco -> Truco
--cuantasVecesRepetirlo numeroDeVeces esteTruco= (!! numeroDeVeces) (iterate esteTruco)
cuantasVecesRepetirlo numeroDeVeces esteTruco= (!! numeroDeVeces) (repeat esteTruco)

-- PUNTO 2
-- resuelto mas arriba

-- PUNTO 3
realizarPresentacion :: Truco
realizarPresentacion conEstaMascota = foldl (realizarTruco) conEstaMascota (trucos conEstaMascota)

realizarTruco :: Mascota -> Truco -> Mascota
realizarTruco conEstaMascota elTruco = elTruco conEstaMascota
-- otra alternativa
realizarTruco' = flip

-- PUNTO 4
type Resultado = (String, Int, Int, Int)

resultados :: Mascota -> Resultado
resultados deEstaMascota = (decidirPuntacion.realizarPresentacion) deEstaMascota

decidirPuntacion :: Mascota -> Resultado
decidirPuntacion deEstaMascota =
  (nombreMascota deEstaMascota, calificacionEnergia, calificacionHabilidad, calificacionTernura)
  where calificacionEnergia = calificarEnergia deEstaMascota
        calificacionHabilidad = calificarHabilidad deEstaMascota
        calificacionTernura = calificarTernura deEstaMascota

calificarEnergia :: Mascota -> Int
calificarEnergia (UnaMascota _ edad _ nivelEnergia _ _) = edad*nivelEnergia

calificarHabilidad :: Mascota -> Int
calificarHabilidad (UnaMascota _ _ (_, aniosExpDelDuenio) _ trucos _) = (((*) aniosExpDelDuenio).length) trucos

calificarTernura :: Mascota -> Int
calificarTernura (UnaMascota nombre edad _ _ _ _)
  | (empiezaCon "Pobre") nombre = 20
  | otherwise = 20-edad

empiezaCon :: String -> String -> Bool
empiezaCon estaPalabra esteNombre =
  ((==estaPalabra).take (length estaPalabra)) esteNombre

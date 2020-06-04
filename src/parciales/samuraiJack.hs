module ParcialSamuraiJack where

import Text.Show.Functions

data Elemento = UnElemento {
  tipo :: String,
  ataque :: (Personaje-> Personaje),
  defensa :: (Personaje-> Personaje)
} deriving(Show)

data Personaje = UnPersonaje {
  nombre :: String,
  salud :: Float,
  elementos :: [Elemento],
  anioPresente :: Int
} deriving(Show)

--
-- # PUNTO 1
--

-- 1a. mandarAlAnio: lleva al personaje al año indicado.
type Transformacion = Personaje->Personaje

type Anio = Int
mandarAlAnio :: Anio -> Transformacion
mandarAlAnio anioFijado personaje = personaje{ anioPresente = anioFijado}

-- 1b. meditar: le agrega la mitad del valor que tiene a la salud del personaje.
meditar :: Transformacion
meditar personaje = personaje{ salud = salud personaje + (reducirAlaMitad.salud) personaje}

reducirAlaMitad :: Float -> Float
reducirAlaMitad = (/2)

-- 1c. causarDanio: le baja a un personaje una cantidad de salud dada.
-- Hay que tener en cuenta al modificar la salud de un personaje que ésta nunca puede quedar menor a 0.
type Danio = Float

causarDanio :: Danio -> Transformacion
causarDanio cantidadDanio personaje = personaje{ salud = (reducirSaludEn cantidadDanio.salud) personaje}

reducirSaludEn :: Float -> Float -> Float
--reducirSaludEn danio salud = max 0 (salud - danio)
reducirSaludEn danio = max 0.((-) danio)

--
-- # PUNTO 2
--

-- 2a. esMalvado, que retorna verdadero si alguno de los elementos que tiene el personaje en cuestión es de tipo “Maldad”.



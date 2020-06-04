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
esMalvado :: Personaje -> Bool
esMalvado personaje = (algunoEsTipo "Malvado".elementos) personaje

algunoEsTipo :: String -> [Elemento] -> Bool
algunoEsTipo tipoElegido = any ((== tipoElegido).tipo)

-- 2b. danioQueProduce :: Personaje -> Elemento -> Float
-- que retorne la diferencia entre la salud inicial del personaje y la salud del personaje
-- luego de usar el ataque del elemento sobre él.
danioQueProduce :: Personaje -> Elemento -> Float
danioQueProduce personaje elemento =
  salud personaje - (salud.luegoDeAtaqueCon elemento) personaje

luegoDeAtaqueCon :: Elemento -> Transformacion
luegoDeAtaqueCon elemento = ataque elemento

-- 2c. enemigosMortales que dado un personaje y una lista de enemigos
-- devuelve la lista de los enemigos que pueden llegar a matarlo con un solo elemento.
-- Esto sucede si luego de aplicar el efecto de ataque del elemento, el personaje queda con salud igual a 0.
type Enemigo = Personaje
enemigosMortales :: Personaje -> [Enemigo] -> [Enemigo]
enemigosMortales personaje = filter (casiLoMataA personaje)

casiLoMataA :: Personaje -> Enemigo -> Bool
casiLoMataA personaje = algunoEsMortiferoCon personaje.elementos

algunoEsMortiferoCon :: Personaje -> [Elemento] -> Bool
algunoEsMortiferoCon personaje = any ((==0).danioQueProduce personaje)


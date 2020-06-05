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
{-
- # CORRECCIONES:
- (1)(2) Se puede mejorar aun mas en una sola.
-   Evita usar azucar sintactico con { } (lo hace mas vistoso pero no usas conceptos de funcional)
-   aprovecha y usa orden superior, aplicacion parcial, composicion, etc..
-}

-- 1a. mandarAlAnio: lleva al personaje al año indicado.
type Transformacion = Personaje->Personaje

type Anio = Int
mandarAlAnio :: Anio -> Transformacion
mandarAlAnio anioFijado personaje = personaje{ anioPresente = anioFijado}


-- ######################
-- ### CORRECCION (1) ###
-- ######################

meditar :: Transformacion
--meditar personaje = personaje{ salud = salud personaje + (reducirAlaMitad.salud) personaje}
--meditar personaje = aumentarSaludEn (0.5*salud personaje) $ personaje
meditar = aumentarSaludEn (/2)

aumentarSaludEn :: (Float -> Float) -> Transformacion
aumentarSaludEn cuantoAumenta (UnPersonaje nombre salud elementos anioPresente)=
  UnPersonaje nombre ((salud+).cuantoAumenta $ salud)  elementos anioPresente
--reducirAlaMitad :: Float -> Float
--reducirAlaMitad = (/2)

type Danio = Float

-- ######################
-- ### CORRECCION (2) ###
-- ######################

causarDanio :: Danio -> Transformacion
causarDanio cuantoAfecta = reducirSaludEn (cuantoAfecta-)
--causarDanio cantidadDanio personaje = personaje{ salud = (reducirSaludEn cantidadDanio.salud) personaje}

reducirSaludEn :: (Float -> Float) -> Transformacion
reducirSaludEn cuantoReduce (UnPersonaje nombre salud elementos anioPresente)=
  UnPersonaje nombre (max 0 $ cuantoReduce salud)  elementos anioPresente
--reducirSaludEn danio salud = max 0 (salud - danio)
--reducirSaludEn danio = max 0.((-) danio)

--
-- # PUNTO 2
--

esMalvado :: Personaje -> Bool
esMalvado = algunoEsTipo "Malvado".elementos

algunoEsTipo :: String -> [Elemento] -> Bool
algunoEsTipo tipoElegido = any ((==) tipoElegido.tipo)

danioQueProduce :: Personaje -> Elemento -> Float
danioQueProduce personaje elemento =
  salud personaje - (salud.luegoDeAtaqueCon elemento) personaje

luegoDeAtaqueCon :: Elemento -> Transformacion
luegoDeAtaqueCon elemento = ataque elemento

type Enemigo = Personaje
enemigosMortales :: Personaje -> [Enemigo] -> [Enemigo]
enemigosMortales personaje = filter (casiLoMataA personaje)

casiLoMataA :: Personaje -> Enemigo -> Bool
casiLoMataA personaje = algunoEsMortiferoCon personaje.elementos

algunoEsMortiferoCon :: Personaje -> [Elemento] -> Bool
algunoEsMortiferoCon personaje = any ((==0).danioQueProduce personaje)

--
-- # PUNTO 3
--

type Nivel = Int

concentracion :: Nivel -> Elemento
concentracion nivel = UnElemento "Magia" (meditarTantasVecesComo nivel) ()

meditarTantasVecesComo :: Nivel -> Transformacion
meditarTantasVecesComo nivel personaje
  | nivel >= 0 = meditarTantasVecesComo (nivel-1) (meditar personaje)
  | otherwise = personaje

type Esbirro = Elemento

esbirrosMalvados :: Int -> [Esbirro]
esbirrosMalvados cantidadEsbirros = crearEsbirrosHasta cantidadEsbirros

crearEsbirrosHasta :: Int -> [Esbirro]
--crearEsbirrosHasta 1 = [unEsbirro]
crearEsbirrosHasta numeroVeces
 | numeroVeces > 0 = unEsbirro : crearEsbirrosHasta (numeroVeces-1)

unEsbirro :: Esbirro
unEsbirro = UnElemento "Maldad" (causarDanio 1) ()

jack :: Personaje
jack = UnPersonaje "Jack" 300 [concentracion 3, katanaMagica] 200

katanaMagica :: Elemento
katanaMagica = UnElemento "Magia" (causarDanio 1000) ()

type Salud = Float

aku :: Anio -> Salud -> Personaje
aku anioQueVive suSalud = UnPersonaje{
  nombre = "aku",
  salud = suSalud,
  elementos = elementosSegun anioQueVive suSalud
}

elementosSegun :: Anio -> Salud -> [Elemento]
elementosSegun anioQueVive suSalud = [
  concentracion 4,
  --(concat.crearEsbirrosHasta) (anioQueVive*100),
  UnElemento "Magia" (mandarAlAnio $ 2800+anioQueVive) aku]

--
-- # PUNTO 4
--

luchar :: Personaje -> Personaje -> (Personaje, Personaje)
luchar atacante defensor
  | casiLoMataA atacante defensor = (defensor, atacante)
  | otherwise = luchar (defenderseDe atacante $ defensor) (atacarA defensor $ atacante)

type Atacante = Personaje
type Defensor = Personaje

defenderseDe :: Atacante -> Defensor -> Atacante
defenderseDe unAtacante unDefensor=
  foldl (\atacante elemento-> defensa elemento $ atacante) unAtacante (elementos unDefensor)

atacarA :: Defensor -> Atacante -> Defensor
atacarA unDefensor unAtacante =
  foldl (\atacante elemento-> ataque elemento $ atacante) unDefensor (elementos unAtacante)

--
-- # PUNTO 5
--

f :: Eq a =>
  (a -> ( (b->d), (b->d) ) )
  -> (c->a)
  -> a
  -> [b]
  -> [d]
f x y z
    | y 0 == z = map (fst.x z)
    | otherwise = map (snd.x (y 0))

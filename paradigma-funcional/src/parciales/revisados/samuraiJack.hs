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

meditar :: Transformacion
--meditar personaje = personaje{ salud = salud personaje + (reducirAlaMitad.salud) personaje}
--meditar personaje = aumentarSaludEn (0.5*salud personaje) $ personaje
--meditar = aumentarSaludEn (/2)
-- para que quede mas generico se puede incrementar usando porcentajes, 1.5 equivale al 100%+50%
meditar = cambiarSaludEn (*1.5)

cambiarSaludEn :: (Float -> Float) -> Transformacion
cambiarSaludEn cuanto (UnPersonaje nombre salud elementos anioPresente) =
  UnPersonaje nombre (cuanto salud) elementos anioPresente

--aumentarSaludEn :: (Float -> Float) -> Transformacion
--aumentarSaludEn cuantoAumenta (UnPersonaje nombre salud elementos anioPresente)=
--  UnPersonaje nombre ((salud+).cuantoAumenta $ salud)  elementos anioPresente
--reducirAlaMitad :: Float -> Float
--reducirAlaMitad = (/2)

type Danio = Float
causarDanio :: Danio -> Transformacion
--causarDanio cuantoAfecta = reducirSaludEn (cuantoAfecta-)
causarDanio cuantoAfecta = cambiarSaludEn (max 0.flip (-) cuantoAfecta)
--no va a restar de manera correcta (-) 10 50 devuelve -40, en cambio flip (-) 10 50 devuelve 40, el danio es menor a la salud
--causarDanio cuantoAfecta = reducirSaludEn (max 0.(-) cuantoAfecta)
-- no explotas al maximo el paradigma (funciones, orden superior, aplicacion parcial, composicion,..)
--causarDanio cantidadDanio personaje = personaje{ salud = (reducirSaludEn cantidadDanio.salud) personaje}

-- reducirSaludEn :: (Float -> Float) -> Transformacion
-- reducirSaludEn cuantoReduce (UnPersonaje nombre salud elementos anioPresente)=
--   UnPersonaje nombre (max 0 $ cuantoReduce salud)  elementos anioPresente
--reducirSaludEn danio salud = max 0 (salud - danio)
--reducirSaludEn danio = max 0.((-) danio)

-------------------------------------------------------------------------------------------------------
--- # PUNTO 2
--

esMalvado :: Personaje -> Bool
esMalvado personaje = (algunoEsTipo "Maldad".elementos) personaje

algunoEsTipo :: String -> [Elemento] -> Bool
algunoEsTipo tipoElegido = any ((==) tipoElegido.tipo)

danioQueProduce :: Personaje -> Elemento -> Float
danioQueProduce personaje elemento =
   ((salud personaje -).salud.ataque elemento) personaje
  --salud personaje - (salud.luegoDeAtaqueCon elemento) personaje
  -- De esta manera estas usando aun mas lo que es composicicion
  -- la funcion "luegoDeAtaqueCon" era innecesaria, podias usar directo "ataque"
  --((salud personaje -).salud.luegoDeAtaqueCon elemento) personaje

--luegoDeAtaqueCon :: Elemento -> Transformacion
--luegoDeAtaqueCon elemento = ataque elemento

type Enemigo = Personaje
enemigosMortales :: Personaje -> [Enemigo] -> [Enemigo]
--enemigosMortales personaje = filter (casiLoMataA personaje)
-- reducis la cantidad de argumentos pero se pierde la expresividad
enemigosMortales personaje enemigo = filter (casiLoMataA personaje) enemigo

casiLoMataA :: Personaje -> Enemigo -> Bool
--casiLoMataA personaje = algunoEsMortiferoCon personaje.elementos
-- reducis la cantidad de argumentos pero se pierde la expresividad
casiLoMataA personaje enemigo = (algunoEsMortiferoCon personaje.elementos) enemigo

algunoEsMortiferoCon :: Personaje -> [Elemento] -> Bool
--algunoEsMortiferoCon personaje = any ((==0).danioQueProduce personaje)
-- si "danioQueProduce" es 0 entonces no le hizo nada, en cambio si es igual a la salud del personaje
-- entonces le saco toda la salud (lo mata)
algunoEsMortiferoCon personaje = any ((salud personaje ==).danioQueProduce personaje)

--
-- # PUNTO 3
--

type Nivel = Int

noHacerNada = id

concentracion :: Nivel -> Elemento
--concentracion nivel = UnElemento "Magia" (meditarTantasVecesComo nivel) ()
-- No sabias que poner en el ultimo parametro, debias usar la funcion "id"
concentracion nivel = UnElemento "Magia" (meditarTantasVecesComo nivel) (noHacerNada)

meditarTantasVecesComo :: Nivel -> Transformacion
meditarTantasVecesComo cuantasVeces personaje =
  ((!! cuantasVeces).iterate meditar) personaje
-- podes evitar la recursividad usando funciones como iterate
--meditarTantasVecesComo nivel personaje
--  | nivel >= 0 = meditarTantasVecesComo (nivel-1) (meditar personaje)
--  | otherwise = personaje

type Esbirro = Elemento

esbirrosMalvados :: Int -> [Esbirro]
esbirrosMalvados cantidadEsbirros = replicate cantidadEsbirros unEsbirro
-- no podes replicar type, deben ser definiciones con datos concretos
--esbirrosMalvados cantidadEsbirros = replicate cantidadEsbirros Esbirro
-- podias evitar recursividad utilizando "replicate"
--esbirrosMalvados cantidadEsbirros = crearEsbirrosHasta cantidadEsbirros

--crearEsbirrosHasta :: Int -> [Esbirro]
--crearEsbirrosHasta numeroVeces | numeroVeces > 0 = unEsbirro : crearEsbirrosHasta (numeroVeces-1)

unEsbirro :: Esbirro
--unEsbirro = UnElemento "Maldad" (causarDanio 1) ()
unEsbirro = UnElemento "Maldad" (causarDanio 1) (noHacerNada)

jack :: Personaje
jack = UnPersonaje "Jack" 300 [concentracion 3, katanaMagica] 200

katanaMagica :: Elemento
--podias usar la funcion "id" cuando definis algo que... no queres asignarle datos
--katanaMagica = UnElemento "Magia" (causarDanio 1000) ()
katanaMagica = UnElemento "Magia" (causarDanio 1000) (noHacerNada)

type Salud = Float

aku :: Anio -> Salud -> Personaje
aku anioQueVive suSalud = UnPersonaje{
  nombre = "aku",
  salud = suSalud,
  elementos = elementosSegun anioQueVive suSalud
}

elementosSegun :: Anio -> Salud -> [Elemento]
elementosSegun anioQueVive suSalud =
 concentracion 4:portal anioQueVive:esbirrosMalvados (anioQueVive*100)
-- concentracion 4:portal anioQueVive suSalud:esbirrosMalvados (anioQueVive*100)
-- no te olvides que si es una lista [....] deberia ir al final, mientras que antes deberia ir los elementos
-- Ej.: 1:2:[1,3,4], estabas haciendo 1:[1,3,4]:4
 --concentracion 4:esbirrosMalvados (anioQueVive*100):portal anioQueVive

-- ### pendiente a revisar el ".salud"
portal anioQueVive = UnElemento "Magia" (mandarAlAnio $ 2800+anioQueVive) (aku anioQueVive.salud)
-- antes le estabas pasando solo (aku) pero.. es una funcion que recibe "anio salud" y luego devuelve el personaje
--portal anioQueVive salud = UnElemento "Magia" (mandarAlAnio $ 2800+anioQueVive) (aku anioQueVive salud)

--elementosSegun anioQueVive suSalud = [
--  concentracion 4,
--(concat.crearEsbirrosHasta) (anioQueVive*100),
--  UnElemento "Magia" (mandarAlAnio $ 2800+anioQueVive) aku]

--
-- # PUNTO 4
-- Pendiente revisar "luchar"
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
-- Pendiente en volver a revisar

f :: (Eq a, Num c) =>
     (a -> b -> (d, d)) -> (c->a) -> a -> [b] -> [d]
-- dato importante...
-- ese "b" es el elemento que recibe de la lista [b]
-- es decir recibe como valor el parametro "z" y ademas el elemento de la lista [b]
--   (a -> ( (b->d), (b->d) ) ) -> (c->a) -> a -> [b] -> [d]

-- no te acordabas como asignar varias clases como Eq, Num
-- estaba bien pero..la funcion "x" recibia "a" y "b" y devolvia una tupla (d,d)
--f :: Eq a => (a -> ( (b->d), (b->d) ) ) -> (c->a) -> a -> [b] -> [d]
f x y z
    | y 0 == z = map (fst.x z)
    | otherwise = map (snd.x (y 0))

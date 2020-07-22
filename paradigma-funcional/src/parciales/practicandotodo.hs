module PracticandoTodo where

import Text.Show.Functions

-- Habilidades como Funciones
-- Las habilidades podrian haber sido solo funciones del tipo type Habilidad = Personaje->Personaje
type Habilidad' = Personaje -> Personaje
alagar' :: Habilidad'
alagar' enemigo = recibirDanio 500 enemigo
--alagar' cuantoDanio enemigo = recibirDanio cuantoDanio enemigo

-- Habilidades como data
-- Al usar las habilidades como data puedo separarlo
data Habilidad = Habilidad{ tipo::String, danio:: Int } deriving (Show)

alagar'' :: Habilidad
alagar'' = Habilidad{ tipo="fisico", danio=500 }
usarHabilidadContra' :: Habilidad -> Personaje -> Personaje
usarHabilidadContra' habilidad enemigo = recibirDanio (danio habilidad) enemigo

data Personaje = Personaje{ energia::Int, ataque::Int, salud::Int, habilidades::[Habilidad]} deriving (Show)

type Atacado = Personaje->Personaje
type Enemigo = Personaje

atacar :: Personaje -> Atacado
atacar personaje enemigo = recibirDanio ataqueDelPersonaje enemigo
  --cambiarSalud (flip (-) ataqueDelPersonaje) enemigo
  where ataqueDelPersonaje = ataque personaje

ataquesConsecutivos :: Personaje -> Atacado
ataquesConsecutivos personaje enemigo = foldr (usarHabilidadContra) enemigo (habilidades personaje)
ataquesConsecutivos' personaje enemigo = foldl (flip usarHabilidadContra) enemigo (habilidades personaje)


-- VERSION RECURSIVA
cuantosVence :: Personaje -> [Enemigo] -> Int
-- caso base, expresion no recursiva (detiene la recursividad)
-- cuando no hay mas enemigos, devuelve cero
cuantosVence personaje [] = 0
-- caso recursivo, expresion recursiva (funcion que se llama a si misma, hace un loop/bucle)
cuantosVence personaje (primerEnemigo:masEnemigos)
   -- si sigue en pie y puede ganarle, sumo 1 tantas veces como gane
   | sigueEnPie && puedeGanarle personaje primerEnemigo = 1 + cuantosVence personajeLuegoDeBatalla masEnemigos
-- | puedeGanarle personaje primerEnemigo = 1 + cuantosVence personaje masEnemigos
   -- si devolvemos cero se cortaria la recursividad en el primero que no pueda vencer
   | otherwise = 0
   where personajeLuegoDeBatalla = ataquesConsecutivos primerEnemigo personaje
         sigueEnPie = (not.estaNoqueado) personaje

-- VERSION CON FILTER ? NO! NO FUNCIONA (como deberia)
-- no se podria con filter.. porque si en el medio hay uno al que no le gana, no le importa y sigue con los demas..
-- la idea seria vencerlos hasta donde pueda, el resultado con el anterior sera diferente
-- cuantosVence' hulk [humano,loki,thor,loki,thor] seran 3, la recursiva devuelve 2
cuantosVence' :: Personaje -> [Enemigo] -> Int
cuantosVence' personaje enemigos =
  (length.filter (\enemigo->puedeGanarle (personajeLuegoDeBatalla enemigo) enemigo && sigueEnPie)) enemigos
  where sigueEnPie = (not.estaNoqueado) personaje
        personajeLuegoDeBatalla enemigo = ataquesConsecutivos enemigo personaje


puedeGanarle :: Personaje -> Enemigo -> Bool
-- puedeGanarle personaje enemigo = ((>0).salud) (foldr (usarHabilidadContra) enemigo (habilidades personaje))
puedeGanarle personaje enemigo = (estaNoqueado . ataquesConsecutivos personaje) enemigo

recibirDanio :: Int -> Atacado
recibirDanio cuanto personaje = cambiarSalud (\salud-> salud-cuanto) personaje
-- podria usar flip, pero no se perderia la expresividad...

usarHabilidadContra :: Habilidad -> Atacado
usarHabilidadContra habilidad enemigo = recibirDanio (danio habilidad) enemigo

cambiarSalud :: (Int -> Int) -> Personaje -> Personaje
cambiarSalud cuantoCambiar (Personaje energia ataque salud habilidades) =
  -- Personaje ataque (max 0.cuantoCambiar $ salud) habilidades
  Personaje energia ataque (hastaQueCaiga.cuantoCambiar $ salud) habilidades

estaNoqueado :: Personaje -> Bool
estaNoqueado personaje = ((==0).salud) personaje

hastaQueCaiga :: Int -> Int
hastaQueCaiga = max 0

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

gritar :: Habilidad
gritar = Habilidad{ tipo="fisico", danio=500 }

rayos :: Habilidad
rayos = Habilidad{ tipo="magico", danio=500 }

-- alternativa con Habilidad como funcion
-- gritar personaje = recibirDanio 100 personaje

hulk = Personaje{ energia = 1000, ataque=100, salud=2500, habilidades=[gritar]}
loki = Personaje{ energia = 1000, ataque=100, salud=500, habilidades=[gritar]}
humano = Personaje{ energia = 10, ataque=1, salud=10, habilidades=[]}
thor = Personaje{ energia = 1000, ataque=100, salud=3500, habilidades=[gritar, rayos]}

personajes = [hulk, loki, thor, humano]

hulkContraLaHumanidad = cuantosVence hulk (take 10 $ repeat humano)

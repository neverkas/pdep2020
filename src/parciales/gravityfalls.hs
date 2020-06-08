module ParcialGravityFalls where

import Text.Show.Functions

--
-- # Punto 1
--

data Persona = UnaPersona{
  edad :: Int,
  items :: [String],
  experiencia :: Int
} deriving(Show)

type Condicion = Persona->Bool

data Criatura = UnaCriatura{
  peligrosidad :: Int,
-- al principio servia, pero no cuando se trataba de condiciones con operadores logicos
-- condiciones :: [String]
  condiciones :: [Condicion]
} deriving(Show)


siempreDetras :: Criatura
siempreDetras = UnaCriatura{
  peligrosidad = 0,
  condiciones = []
}

gnomos :: Int -> Criatura
gnomos cuantos = UnaCriatura{
  peligrosidad = 2^cuantos,
--  condiciones = ["soplador de hojas"]
-- tienen el formato de (Persona->Bool)
-- esperan una persona, y devuelven una respuesta booleana si se cumple o no
  condiciones = [tieneElItem "soplador de hojas"]
}

cumpleCondiciones :: Persona -> Criatura -> Bool
cumpleCondiciones persona criatura = all (\condicion->condicion persona) (condiciones criatura)

type Item = String
tieneElItem :: Item -> Persona -> Bool
tieneElItem item persona = (elem item . items) persona

-- repeticion de logica
-- tieneEdad :: (Int->Bool) -> Persona -> Bool
-- tieneEdad cuanto persona = (cuanto.edad) persona
-- tieneExperiencia :: (Int->Bool) -> Persona -> Bool
-- tieneExperiencia cuanto persona = (cuanto.experiencia) persona

laPersonaTiene :: (Persona->Int) -> (Int->Bool) -> Persona -> Bool
laPersonaTiene atributo cuanto persona = (cuanto.atributo) persona

fantasmas :: Int -> Criatura
fantasmas categoria = UnaCriatura{
  peligrosidad = categoria*20,
  condiciones = []
}

--
-- # Punto 2
--
type Enfrentamiento = Persona -> Persona

enfrentarseA :: Criatura -> Enfrentamiento
enfrentarseA criatura persona
  | cumpleCondiciones persona criatura = ganarExperiencia (+experienciaPorDesaparecerla) persona
  | otherwise = ganarExperiencia (+1) persona
  where experienciaPorDesaparecerla = (peligrosidad criatura)

-- esto servia cuando se trataba de condiciones del tipo [String]
--enfrentarseA :: Criatura -> Persona -> Persona
--enfrentarseA criatura persona
--  | (algunoPuedeDesaparecerA criatura.items) persona = experienciaPorDesaparecerla
--  | otherwise = ganarExperiencia (+1) persona
--  where experienciaPorDesaparecerla = (ganarExperiencia ((+) (peligrosidad criatura))) persona
-- algunoPuedeDesaparecerA :: Criatura -> [Item] -> Bool
-- algunoPuedeDesaparecerA estaCriatura items = any (sirveContra estaCriatura) items
-- --sirveContra :: Criatura -> Item -> Bool
-- sirveContra estaCriatura item = (elem item.condicionesDesaparecer) estaCriatura

ganarExperiencia :: (Int->Int) -> Enfrentamiento
ganarExperiencia cuantoCambiar (UnaPersona edad items experiencia) =
  UnaPersona edad items (cuantoCambiar experiencia)

--
-- # Punto 3
--
experienciaPorEnfrentamientosSucesivosA :: [Criatura] -> Persona -> Int
experienciaPorEnfrentamientosSucesivosA criaturas persona =
  (experiencia.enfrentarseSucesivamenteA criaturas ) persona

enfrentarseSucesivamenteA :: [Criatura] -> Enfrentamiento
enfrentarseSucesivamenteA criaturas persona =
  -- En realidad no hace de forma sucesiva, la persona no cambia, modifica la original, deberia ir modificandola
  -- Ej. 1er ataque gana 10, a esa otra modificarle y que gane 20, ...
   foldr (enfrentarseA) persona criaturas
  --( takeWhile () .  foldr (intentarVencer persona) [persona]) criaturas

-- intentarVencer :: Persona -> Criatura -> [Persona] -> Persona
-- intentarVencer personaOriginal criatura cambiosPersona =
--   enfrentarseA criatura personaOriginal

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

--
-- # Simulacion
--
grupoGnomos :: Criatura
grupoGnomos = gnomos 10

-- unFantasma = (fantasmas 3){ condiciones=[ tieneEdad (<13), tieneElItem "disfraz oveja"] }
fantasma :: Criatura
fantasma = (fantasmas 3){ condiciones=[ laPersonaTiene edad (<13), tieneElItem "disfraz oveja"] }

fantasma' :: Criatura
fantasma' = (fantasmas 1){ condiciones=[ laPersonaTiene experiencia (>10) ] }

carlitos :: Persona
carlitos = UnaPersona 10 ["disfraz oveja"] 1


simulacionEnfrentamiento =
  experienciaPorEnfrentamientosSucesivosA [siempreDetras, grupoGnomos, fantasma, fantasma'] carlitos

-- No puede desaparecer a los gnomos (Experiencia +1)
simulacionContraGnomos = experienciaPorEnfrentamientosSucesivosA [grupoGnomos] (UnaPersona 15 [] 0)
-- Si puede desaparecer a los gnomos (Experiencia 2^(cantidad gnomos))
simulacionContraGnomos' = experienciaPorEnfrentamientosSucesivosA [grupoGnomos] (UnaPersona 15 ["soplador de hojas"] 0)

-- Casos en que no podra desaparecer al fantasma
simulacionContraFantasmasB = experienciaPorEnfrentamientosSucesivosA [fantasma']  (UnaPersona 15 [] 0)
-- Unico caso en que si puede desaparecer al fantasma
simulacionContraFantasmasB''' = experienciaPorEnfrentamientosSucesivosA [fantasma']  (UnaPersona 10 [] 100)

-- Casos en que no podra desaparecer al fantasma
simulacionContraFantasmasA = experienciaPorEnfrentamientosSucesivosA [fantasma]  (UnaPersona 15 [] 0)
simulacionContraFantasmasA' = experienciaPorEnfrentamientosSucesivosA [fantasma]  (UnaPersona 10 [] 0)
simulacionContraFantasmasA'' = experienciaPorEnfrentamientosSucesivosA [fantasma]  (UnaPersona 15 ["disfraz oveja"] 0)
-- Unico caso en que si puede desaparecer al fantasma
simulacionContraFantasmasA''' = experienciaPorEnfrentamientosSucesivosA [fantasma]  (UnaPersona 10 ["disfraz oveja"] 0)


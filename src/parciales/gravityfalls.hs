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
-- alternativa usando "azucar sintatico"
ganarExperiencia' cuantoCambiar persona = persona{ experiencia = (cuantoCambiar.experiencia) persona }

--
-- # Punto 3
--
experienciaPorEnfrentamientosSucesivosA :: [Criatura] -> Persona -> Int
experienciaPorEnfrentamientosSucesivosA criaturas persona =
  (experiencia.enfrentarseSucesivamenteA criaturas ) persona

enfrentarseSucesivamenteA :: [Criatura] -> Enfrentamiento
enfrentarseSucesivamenteA criaturas persona =
  -- Correccion a la frase de abajo, "parece funcionar ok" (quizas te confundiste por el ej. bonus de minigolfito 2020)
  -- En realidad no hace de forma sucesiva, la persona no cambia, modifica la original, deberia ir modificandola
  -- Ej. 1er ataque gana 10, a esa otra modificarle y que gane 20, ...
   foldr (enfrentarseA) persona criaturas
  -- foldl? "a menos que haya alguna aclaración particular sobre el orden en el que haya que foldear, ambas valen"

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

--
-- # Simulacion de codigo
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
simulacionContraGnomosA = experienciaPorEnfrentamientosSucesivosA [gnomos 10] (UnaPersona 15 [] 0)
-- No puede desaparecer a los gnomos (Experiencia +10)
simulacionContraGnomosB = experienciaPorEnfrentamientosSucesivosA (replicate 10 (gnomos 10)) (UnaPersona 15 [] 0)
-- Si puede desaparecer a los gnomos (Experiencia 2^(cantidad gnomos))
simulacionContraGnomosC = experienciaPorEnfrentamientosSucesivosA [gnomos 2] (UnaPersona 15 ["soplador de hojas"] 0)

-- Casos en que no podra desaparecer al fantasma
simulacionContraFantasmasA = experienciaPorEnfrentamientosSucesivosA [fantasma']  (UnaPersona 15 [] 0)
-- Unico caso en que si puede desaparecer al fantasma
simulacionContraFantasmasB = experienciaPorEnfrentamientosSucesivosA [fantasma']  (UnaPersona 10 [] 100)

-- Casos en que no podra desaparecer al fantasma
simulacionContraFantasmasC = experienciaPorEnfrentamientosSucesivosA [fantasma]  (UnaPersona 15 [] 0)
simulacionContraFantasmasD = experienciaPorEnfrentamientosSucesivosA [fantasma]  (UnaPersona 10 [] 0)
simulacionContraFantasmasE = experienciaPorEnfrentamientosSucesivosA [fantasma]  (UnaPersona 15 ["disfraz oveja"] 0)
-- Unico caso en que si puede desaparecer al fantasma
simulacionContraFantasmasF = experienciaPorEnfrentamientosSucesivosA [fantasma]  (UnaPersona 10 ["disfraz oveja"] 0)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

--
-- # Parte 2
--

-- # Punto 1

-- > zipWithIf (*) even [10..50] [1..7]
-- [1,20,3,44,5,72,7] ← porque [1, 2*10, 3, 4*11, 5, 6*12, 7]

-- Pendiente por revisar "Casos de base"
zipWithIf :: (a -> b -> b) -> (b -> Bool) -> [a] -> [b] -> [b]
-- Caso base (expresion que corta el caso/funcion/expresion recursiva)
-- Si no hay mas elementos en la primera lista, no tiene sentido avanzar
zipWithIf _ _ [] _ = []
-- Correccion: no interesaba el tercer parametro en este patron..
-- mientras haya elementos en la primera lista, pero no haya en la segunda no tiene sentido avanzar
--zipWithIf _ _ (cabeza:cola) [] = []
-- Ojo..! Esto seria un patron innecesario
zipWithIf _ _ _ [] = []
zipWithIf operacion condicion (listaAcabeza:listaAcola) (listaBcabeza:listaBcola)
-- Ojo..! esto fallaria porque.. el tipado pide (a->b->b), no (b->a->b)
-- | condicion listaBcabeza = (operacion listaBcabeza listaAcabeza) : zipWithIf operacion condicion listaAcola listaBcola
  | condicion listaBcabeza = (operacion listaAcabeza listaBcabeza) : zipWithIf operacion condicion listaAcola listaBcola
  | otherwise = listaBcabeza : zipWithIf operacion condicion (listaAcabeza:listaAcola) listaBcola

simulacionZipWithIf = zipWithIf (*) even [10..50] [1..7]

-- # Punto 2

-- abecedarioDesde 'y' debería retornar 'y':'z':['a' .. 'x'].

type Criterio = Letra->Bool
type DesencriptacionTexto = String->String
type DesencriptacionLetra = Char->Char
type Abecedario = String
type Letra = Char
type Distancia = Int

abecedario :: Abecedario
abecedario = ['a'..'z']

abecedarioDesde :: Letra -> Abecedario
-- alternativa al filter, seria usando takeWhile para (<letra) y dropWhile para (>letra)
abecedarioDesde letra = abecedarioSegunCriterio (>=letra) ++ abecedarioSegunCriterio (<letra)

abecedarioSegunCriterio :: Criterio -> Abecedario
abecedarioSegunCriterio esteCriterio = filter (esteCriterio) abecedario

desencriptarLetra :: Letra -> DesencriptacionLetra
desencriptarLetra letraClave letraDesencriptar =
  ultimaLetraConDistanciaA (distanciaEntre letraClave letraDesencriptar) (abecedarioDesde 'a')
   where ultimaLetraConDistanciaA distancia= (last . take (distancia+1) )
  -- Esta otra manera no estaba mal.. pero el enunciado pide sin calcular la posicicion
  --(!! posicionLetraAdesencriptar) (abecedarioDesde 'a')
  -- tenia que ser desde la 'a'
  --(!! posicionLetraAdesencriptar) (abecedarioDesde letraDesencriptar)
  --where posicionLetraAdesencriptar = max 0 (distanciaEntreLetras letraClave letraDesencriptar - 1)
  -- uso max 0 para que si la distancia es 0, no quede un valor negativo (sino tira error)
  -- le resto uno a la distancia, porque (!! 1) devuelve la segunda letra, en cambio (!! 0) la primera

distanciaEntre :: Letra -> Letra -> Distancia
distanciaEntre desde hasta = (length . takeWhile (/=hasta) . abecedarioDesde) desde
-- si usara filter, el resultado seria distinto
--distanciaEntreLetras letraDesde letraHasta = (length.takeWhile (/=letraHasta).abecedarioDesde) letraDesde

cesar :: Letra -> DesencriptacionTexto
cesar letraClave textoEncriptado =
  -- zipWithIf desencriptarLetra perteneceAlAbecedario (abecedarioDesde letraClave) textoEncriptado
  zipWithIf desencriptarLetra perteneceAlAbecedario (repetirLetraSegun textoEncriptado letraClave) textoEncriptado

posiblesDesencripcionesDe :: String -> [String]
posiblesDesencripcionesDe textoEncriptado = map (\letra->cesar letra textoEncriptado) ['a'..'z']

repetirLetraSegun :: String -> Letra -> String
repetirLetraSegun texto letra = (flip replicate letra . length) texto

perteneceAlAbecedario :: Char -> Bool
perteneceAlAbecedario letra = elem letra ['a'..'z']

--
-- # Simulacion de codigo
--
simulacionDesencriptacion = posiblesDesencripcionesDe "jrzel zrfaxal!"


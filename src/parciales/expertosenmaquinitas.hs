module ParcialExpertosEnMaquinitas where

import Text.Show.Functions

--
-- # Datos
--
data Persona = UnaPersona String Float Int [(String,Int)] deriving(Show)
nombre (UnaPersona nombre _ _ _) = nombre
dinero (UnaPersona _ dinero _ _) = dinero
suerte (UnaPersona _ _ suerte _) = suerte
factores (UnaPersona _ _ _ factores) = factores

type Factor = (String, Int)
valorDelFactor = snd
nombreDelFactor = fst

nico = (UnaPersona "Nico" 100.0 30 [("amuleto", 3), ("manos magicas",100)])
maiu = (UnaPersona "Maiu" 100.0 42 [("inteligencia",55), ("paciencia",50)])

--
-- # Punto 1
--
suerteTotalDe :: Persona -> Int
suerteTotalDe persona
  | tieneFactor "amuleto" persona = ((*) suerteDeLaPersona.valorDelFactor.encontrarFactor "amuleto") persona
  | otherwise = suerteDeLaPersona
  where suerteDeLaPersona = suerte persona

-- hacer refactor luego
tieneFactor :: String -> Persona -> Bool
tieneFactor nombre persona =
  (elem nombre.map (nombreDelFactor).factores) persona && ((>0).valorDelFactor.encontrarFactor nombre) persona

encontrarFactor :: String -> Persona -> Factor
encontrarFactor nombreDelFactor persona =  (head.filter ((== nombreDelFactor).fst)) (factores persona)

--
-- # Simulaciones de codigo
--
simularSuerte = suerteTotalDe nico
simularSuerte' = suerteTotalDe maiu 

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

--
-- # Punto 2
--

data Juego = UnJuego{
}

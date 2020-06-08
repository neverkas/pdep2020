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

data Criatura = UnaCriatura{
  peligrosidad :: Int,
  condicionesDesaparecer :: [String]
} deriving(Show)


siempreDetras :: Criatura
siempreDetras = UnaCriatura{
  peligrosidad = 0,
  condicionesDesaparecer = []
}

gnomos :: Int -> Criatura
gnomos cuantos = UnaCriatura{
  peligrosidad = 2^cuantos,
  condicionesDesaparecer = ["soplador de hojas"]
}

fantasmas :: Int -> Criatura
fantasmas categoria = UnaCriatura{
  peligrosidad = categoria*20,
  condicionesDesaparecer = []
}

--
-- # Punto 2
--

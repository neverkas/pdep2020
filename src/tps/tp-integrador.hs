module TPIntegrador where
import Text.Show.Functions


----------------------
-- Código inicial
----------------------

ordenarPor :: Ord a => (b -> a) -> [b] -> [b]
ordenarPor ponderacion =
  foldl (\ordenada elemento -> filter ((< ponderacion elemento).ponderacion) ordenada
                                  ++ [elemento] ++ filter ((>= ponderacion elemento).ponderacion) ordenada) []

data Demonio = Demonio {
    deudores :: [String],
    subordinados :: [Demonio]
} deriving (Show, Eq)


----------------------------------------------
-- Definí tus tipos de datos y funciones aquí
----------------------------------------------

type Deseo = Humano -> Humano
type Carrera = String

-- Punto 1 - INICIO

data Humano = UnHumano {
  nombre :: String,
  nivelDeReconocimiento :: Int,
  cantidadFelicidad :: Int,
  deseos :: [Deseo]
}deriving (Show)

cambiarFelicidadA :: Int -> Humano -> Humano
cambiarFelicidadA cantidad unHumano =
  unHumano{ cantidadFelicidad = cantidad }

aumentarFelicidadEn :: Int -> Humano -> Humano
aumentarFelicidadEn cantidad unHumano =
  unHumano{ cantidadFelicidad = cantidadFelicidad unHumano + cantidad }

aumentarFelicidadTantasVeces :: Int -> Humano -> Humano
aumentarFelicidadTantasVeces cantidad unHumano =
  unHumano{ cantidadFelicidad = cantidadFelicidad unHumano * cantidad }

aumentarReconocimientoEn :: Int -> Humano -> Humano
aumentarReconocimientoEn cantidad unHumano =
  unHumano{ nivelDeReconocimiento = nivelDeReconocimiento unHumano + cantidad}

tripleLongitudCarreraRecibida :: Carrera -> Int
tripleLongitudCarreraRecibida = (*3) . length

laPazMundial :: Humano -> Humano
laPazMundial = aumentarFelicidadTantasVeces 20

recibirseDeUnaCarrera :: Carrera -> Humano -> Humano
recibirseDeUnaCarrera unaCarrera =
  aumentarFelicidadEn 250 . aumentarReconocimientoEn (tripleLongitudCarreraRecibida unaCarrera)

serFamoso :: Humano -> Humano
serFamoso = cambiarFelicidadA 50 . aumentarReconocimientoEn 1000

carlitos :: Humano
carlitos = UnHumano{
  nombre = "carlitos",
  nivelDeReconocimiento = 50,
  cantidadFelicidad = 100,
  deseos = [
      laPazMundial,
      recibirseDeUnaCarrera "Ingenieria en Sistemas de Informacion",
      recibirseDeUnaCarrera "Medicina",
      serFamoso
      ]
}

-- PUNTO 2
nivelDeReconocimientoLuegoDelDeseo :: Deseo -> Humano -> Int
nivelDeReconocimientoLuegoDelDeseo unDeseo unHumano =
  (nivelDeReconocimiento.unDeseo) unHumano - nivelDeReconocimiento unHumano

cantidadFelicidadLuegoDelDeseo :: Deseo -> Humano -> Int
cantidadFelicidadLuegoDelDeseo unDeseo unHumano =
  (cantidadFelicidad.unDeseo) unHumano - cantidadFelicidad unHumano

espiritualidadDeUnDeseo :: Deseo -> Humano -> Int
espiritualidadDeUnDeseo unDeseo unHumano =
  (cantidadFelicidadLuegoDelDeseo unDeseo unHumano) - (nivelDeReconocimientoLuegoDelDeseo unDeseo unHumano)

-- PUNTO 3
aplicarDeseo :: Deseo -> Humano -> Humano
aplicarDeseo unDeseo = unDeseo

aplicarDeseos :: [Deseo] -> Humano -> Humano
--aplicarDeseos deseos unHumano = foldr (aplicarDeseo) unHumano deseos
aplicarDeseos deseos unHumano = foldl (flip aplicarDeseo) unHumano deseos

esMasFelizAlCumplirSusDeseos :: Humano -> Bool
esMasFelizAlCumplirSusDeseos unHumano =
  (cantidadFelicidad.aplicarDeseos (deseos unHumano)) unHumano > cantidadFelicidad unHumano

-- PUNTO 4
esDeseoTerrenal :: Deseo -> Humano -> Bool
esDeseoTerrenal unDeseo = (<150) . espiritualidadDeUnDeseo unDeseo

-- REVISAR
ordenarPorEspiritualidad :: Humano -> [Deseo] -> [Deseo]
ordenarPorEspiritualidad unHumano =
  ordenarPor (\deseo->espiritualidadDeUnDeseo deseo unHumano)

deseosMasTerrenales :: Humano -> [Deseo]
deseosMasTerrenales unHumano =
  ordenarPorEspiritualidad unHumano $ filter (\deseo -> esDeseoTerrenal deseo unHumano) (deseos unHumano)

sumaDeFelicidadYReconocimiento :: Humano -> Int
sumaDeFelicidadYReconocimiento unHumano =
  cantidadFelicidad unHumano + nivelDeReconocimiento unHumano

ordenarPorSuMejorVersion :: [Humano] -> [Humano]
ordenarPorSuMejorVersion = ordenarPor sumaDeFelicidadYReconocimiento

aplicarDeseoAlHumanoYagrupar :: Humano -> Deseo -> [Humano] -> [Humano]
aplicarDeseoAlHumanoYagrupar unHumano deseo humanos =
  aplicarDeseo deseo unHumano : humanos

laMejorVersion :: Humano -> [Humano]
laMejorVersion unHumano =
   ordenarPorSuMejorVersion $ foldr (aplicarDeseoAlHumanoYagrupar unHumano) [unHumano] (deseos unHumano)

-- PUNTO 5
kodama :: Demonio
kodama = Demonio{
  deudores = ["vidar", "pepe"],
  subordinados = []
}

leviatan :: Demonio
leviatan = Demonio{
  deudores = ["vali"],
  subordinados = [kodama]
}

vali :: Humano
vali = UnHumano "vali" 0 0 []

vidar :: Humano
vidar = UnHumano "vidar" 0 0 []

type Nombre = String

suNombreEstaEn :: [Nombre] -> Humano -> Bool
suNombreEstaEn nombres unHumano = elem (nombre unHumano) nombres

agruparConDeudoresDeSubordinados :: Demonio -> [Nombre] -> [Nombre]
agruparConDeudoresDeSubordinados subordinados = (++) $ deudores subordinados

deudoresDeSubordinados :: Demonio -> [Nombre]
deudoresDeSubordinados unDemonio =
  foldr agruparConDeudoresDeSubordinados (deudores unDemonio) (subordinados unDemonio)
--  foldr (\subordinados listado-> deudores subordinados++listado) (deudores unDemonio) (subordinados unDemonio)
--deudoresDeSubordinados unDemonio = concat (map (deudores) (subordinados unDemonio))

deudoresDeSubordinados' :: Demonio -> [Nombre]
deudoresDeSubordinados' unDemonio = concatMap deudores (subordinados unDemonio)++(deudores unDemonio)
{-
Pregunta 5c:
Explicar conceptualmente si la función desarrollada en este punto (con o sin bonus) podría terminar
de evaluarse si el demonio tuviera infinitos subordinados y/o infinitos deudores.
En base a tu solución, ¿qué es lo que podría o no permitir que termine?

Respuesta:
No, no terminaria de evaluarse si el demonio tuviera infinitos subordinados y/o infintios deudores,
el motivo es que estaria tratando de llegar al ultimo elemento para el ciclo de iteracion de dicha funcion,
pero este seria un loop infinito que no terminaria.

Para darle una solucion a loop infinito de iteraciones, podria utilizarse alguna de las funciones
por defecto de haskell para el control de listas, como por ejemplo take para manejar un numero limitado
de subordinados y/o infinitos deudores.
-}


tienePoderSobreElHumano :: Demonio -> Humano -> Bool
tienePoderSobreElHumano unDemonio unHumano=
  suNombreEstaEn (deudores unDemonio) unHumano ||
  suNombreEstaEn (deudoresDeSubordinados unDemonio) unHumano

-- PUNTO 6
tieneDeseosTerrenales :: Humano -> Bool
tieneDeseosTerrenales = (>0).length.deseosMasTerrenales

noTienePoderSobreElHumano :: Demonio -> Humano -> Bool
noTienePoderSobreElHumano unDemonio = not.tienePoderSobreElHumano unDemonio

aplicarDeseoMasTerrenal :: Humano -> Humano
aplicarDeseoMasTerrenal unHumano =
  aplicarDeseo (head.deseosMasTerrenales $ unHumano) unHumano

agregarADeudoresDe :: Demonio -> Nombre -> Demonio
agregarADeudoresDe unDemonio nombre =
  unDemonio{deudores = nombre:deudores unDemonio}

ayudarSiLeConviene :: Humano -> Demonio -> (Humano, Demonio)
ayudarSiLeConviene unHumano unDemonio
   | tieneDeseosTerrenales unHumano && noTienePoderSobreElHumano unDemonio unHumano =
     (aplicarDeseoMasTerrenal unHumano, agregarADeudoresDe unDemonio $ nombre unHumano)
   | otherwise = (unHumano, unDemonio)

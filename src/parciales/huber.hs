module ParcialHuber where

--
-- # PUNTO 1
-- Correccion: Todo ok, excepto lo de condiciones en el chofer
--
import Text.Show.Functions

data Cliente = Cliente{
  nombreCliente :: String,
  direccion :: String
} deriving(Show)

type Condicion = Viaje -> Bool

data Chofer = Chofer{
  nombre :: String,
  kilometraje :: Float,
  viajes :: [Viaje],
  --condiciones :: [Condicion]
  -- "al parecer era solo una"
  condiciones :: Condicion
} deriving(Show)
-- Observacion: Si no agregabas import de mostrar las funciones, rompe porque no podes mostrar Condicion (que es una funcion)

data Viaje = Viaje{
  fecha :: String,
  cliente :: Cliente,
  costo :: Int
} deriving(Show)

--
-- # PUNTO 2
--

{-
-CORRECCIONES:
-1. cualquierViaje lo habias pensado bien, pero tenias duda si dejarle el True, pero lo dejaste como undefined
-}

-- algunos choferes toman cualquier viaje
cualquierViaje :: Condicion
--cualquierViaje viaje = undefined
-- # CORRECCION (1)
cualquierViaje viaje = True

type Precio = Int
-- otros solo toman los viajes que salgan más de $ 200
viajeMayorA :: Condicion
viajeMayorA = (>200) . costo

-- otros toman aquellos en los que el nombre del cliente tenga más de n letras
nombreDelClienteConMasDe :: Int -> Condicion
nombreDelClienteConMasDe minimoDeLetras =
  longitudMayorIgualA minimoDeLetras.nombreCliente.cliente

-- funcion auxiliar (1)
longitudMayorIgualA :: Int -> String -> Bool
longitudMayorIgualA longitud = (>= longitud).length

--y por último algunos requieren que el cliente no viva en una zona determinada
elClienteNoVivePor :: String -> Condicion
elClienteNoVivePor zona = (/= zona).direccion.cliente

--
-- # PUNTO 3
--
{-
- # CORRECCIONES:
- 1. Las condiciones no eran una lista, era una sola "al parecer.."
-}

-- el cliente “Lucas” que vive en Victoria
lucas :: Cliente
lucas = Cliente "Lucas" "Victoria"

-- el chofer “Daniel”, su auto tiene 23.500 kms.,
-- hizo un viaje con el cliente Lucas el 20/04/2017 cuyo costo fue $ 150,
-- y toma los viajes donde el cliente no viva en “Olivos”.
daniel :: Chofer
--daniel = Chofer "Daniel" 23500 [Viaje "20/04/2017" lucas 150] [elClienteNoVivePor "Olivos"]
daniel = Chofer "Daniel" 23500 [Viaje "20/04/2017" lucas 150] (elClienteNoVivePor "Olivos")

-- la chofer “Alejandra”, su auto tiene 180.000 kms, no hizo viajes y toma cualquier viaje.
alejandra :: Chofer
--alejandra = Chofer "Alejandra" 180000 [] [cualquierViaje]
alejandra = Chofer "Alejandra" 180000 [] cualquierViaje


--
-- # PUNTO 4
--
{-
- # CORRECCIONES:
- 1. Antes tenias para varias condiciones, por tanto usar all estaba mal
- 2. Tratabas de delegar en otra funcion, pero se podia hacer en esa misma
-}

-- Saber si un chofer puede tomar un viaje.
puedeTomarElViaje :: Chofer -> Viaje -> Bool
puedeTomarElViaje chofer viaje =
  --all (condicionCumpleCon viaje) (condiciones chofer)
  -- # CORRECCION (1)
  --condicionCumpleCon viaje (condiciones chofer)
  -- # CORRECCION (2)
  (condiciones chofer) viaje

-- funcion auxiliar (2)
-- Condicion = Viaje -> Bool
--condicionCumpleCon :: Viaje -> (Viaje->Bool)
--condicionCumpleCon viaje condicion = condicion viaje

--
-- # PUNTO 5
--

-- Saber la liquidación de un chofer, que consiste en sumar los costos de cada uno de los viajes.
-- Por ejemplo, Alejandra tiene $ 0 y Daniel tiene $ 150.
suLiquidacionEs :: Chofer -> Int
suLiquidacionEs chofer = (sum.map costo.viajes) chofer
-- con aplicacion parcial (? o point-free)
suLiquidacionEs' = sum.map costo.viajes
-- Observacion: Otra manera? Con foldr/foldl

--
-- # PUNTO 6
--
--  Realizar un viaje: dado un viaje y una lista de choferes, se pide que
{-
- # OBSERVACIONES:
- 1. Podrias haber mejorado en elQueMenosViajo la expresividad usando "cantidadDeViajes"
-
- # CORRECCIONES:
- 1. realizarViaje debia devolver u chofer no un viaje
- 2. efectuarViaje no pedia que estuviera al principio o al final, solo que lo agrgara
-  ademas debia devolver un Chofer no un Viaje
-}

-- filtre los choferes que toman ese viaje. Si ningún chofer está interesado, no se preocupen: el viaje no se puede realizar.

-- ### CORRECCION (1)

--realizarViaje :: Viaje -> [Chofer] -> Viaje
realizarViaje :: Viaje -> [Chofer] -> Chofer
realizarViaje viaje =
  efectuarViaje viaje.elQueMenosViajo.filter(flip puedeTomarElViaje viaje)
-- alternativa (1)
realizarViaje' viaje =
  efectuarViaje viaje.elQueMenosViajo.filter(\chofer -> puedeTomarElViaje chofer viaje)

-- considerar el chofer que menos viaje tenga. Si hay más de un chofer elegir cualquiera.
-- funcion auxiliar (2)
elQueMenosViajo :: [Chofer] -> Chofer
elQueMenosViajo [chofer] = chofer

-- ### OBSERVACION (1)

elQueMenosViajo (chofer1:chofer2:choferes)
 | (length.viajes) chofer1 > (length.viajes) chofer2 = elQueMenosViajo (chofer2:choferes)
 | otherwise = chofer1

--efectuar el viaje: esto debe incorporar el viaje a la lista de viajes del chofer. ¿Cómo logra representar este cambio de estado?

-- ### CORRECCION (2)

--efectuarViaje :: Viaje -> Chofer -> Viaje
--efectuarViaje viaje chofer =
--  (ultimoViaje . viajes) chofer{ viajes = viajes chofer:[viaje]}
efectuarViaje :: Viaje -> Chofer -> Chofer
efectuarViaje viaje chofer = chofer{ viajes = viaje:viajes chofer}

-- funcion auxiliar (3)
--ultimoViaje :: [Viaje] -> Viaje
--ultimoViaje = last

--
-- # PUNTO 7
--
{-
- # CORRECCIONES:
- 1. Pensabas que.. las condiciones eran una lista, pero "NO"
-}

-- dato del enunciado
repetirViaje viaje = viaje : repetirViaje viaje

-- Modelar al chofer “Nito Infy”, su auto tiene 70.000 kms.,
-- que el 11/03/2017 hizo infinitos viajes de $ 50 con Lucas y
-- toma cualquier viaje donde el cliente tenga al menos 3 letras. Puede ayudarse con esta función:

-- ### CORRECCION (1)
nito :: Chofer
--nito = Chofer "Nito Infy" 70.000 (repetirViaje $ Viaje "11/03/2017" lucas 50) [nombreDelClienteConMasDe 3, cualquierViaje]
nito = Chofer "Nito Infy" 70.000 (repetirViaje $ Viaje "11/03/2017" lucas 50) (nombreDelClienteConMasDe 3)

-- ¿Puede calcular la liquidación de Nito? Justifique.
--Rta: No, no terminaria de hacer los viajes
-- ¿Y saber si Nito puede tomar un viaje de Lucas de $ 500 el 2/5/2017? Justifique. 
--Rta: Si, porque no involucra listas

--
-- # PUNTO 8
--

{-
- # CORRECCIONES:
- 1. Te faltaba agregar la lista [a]
- 2. Lo que entraba en el criterio del filter debia ser el mismo que el primer parametro
-}
--gongNeng :: Ord a => a -> (b->Bool) -> (a->b) -> a
gongNeng :: Ord b => b -> (b->Bool) -> (a->b) -> [a] -> b
gongNeng arg1 arg2 arg3 =
     max arg1 . head . filter arg2 . map arg3

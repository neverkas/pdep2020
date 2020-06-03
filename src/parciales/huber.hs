module ParcialHuber where

--
-- # PUNTO 1
--
data Cliente = Cliente{
  nombreCliente :: String,
  direccion :: String
}

data Chofer = Chofer{
  nombre :: String,
  kilometraje :: Float,
  viajes :: [Viaje],
  condiciones :: [Condicion]
}

data Viaje = Viaje{
  fecha :: String,
  cliente :: Cliente,
  costo :: Int
}

--
-- # PUNTO 2
--
type Condicion = Viaje -> Bool

-- algunos choferes toman cualquier viaje
cualquierViaje :: Condicion
cualquierViaje viaje = undefined

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

-- el cliente “Lucas” que vive en Victoria
lucas :: Cliente
lucas = Cliente "Lucas" "Victoria"

-- el chofer “Daniel”, su auto tiene 23.500 kms.,
-- hizo un viaje con el cliente Lucas el 20/04/2017 cuyo costo fue $ 150,
-- y toma los viajes donde el cliente no viva en “Olivos”.
daniel :: Chofer
daniel = Chofer "Daniel" 23.500 [Viaje "20/04/2017" lucas 150] [elClienteNoVivePor "Olivos"]

-- la chofer “Alejandra”, su auto tiene 180.000 kms, no hizo viajes y toma cualquier viaje.
alejandra :: Chofer
alejandra = Chofer "Alejandra" 180.000 [] [cualquierViaje]

--
-- # PUNTO 4
--

-- Saber si un chofer puede tomar un viaje.
puedeTomarElViaje :: Chofer -> Viaje -> Bool
puedeTomarElViaje chofer viaje =
  all (condicionCumpleCon viaje) (condiciones chofer)

-- funcion auxiliar (1)
condicionCumpleCon :: Condicion
condicionCumpleCon viaje condicion = condicion viaje

--
-- # PUNTO 5
--

-- Saber la liquidación de un chofer, que consiste en sumar los costos de cada uno de los viajes.
-- Por ejemplo, Alejandra tiene $ 0 y Daniel tiene $ 150.
suLiquidacionEs :: Chofer -> Int
suLiquidacionEs chofer = (sum.map costo.viajes) chofer
-- con aplicacion parcial (? o point-free)
suLiquidacionEs' = sum.map costo.viajes

--
-- # PUNTO 6
--
--  Realizar un viaje: dado un viaje y una lista de choferes, se pide que

-- filtre los choferes que toman ese viaje. Si ningún chofer está interesado, no se preocupen: el viaje no se puede realizar.
realizarViaje :: Viaje -> [Chofer] -> Viaje
realizarViaje viaje =
  efectuarViaje viaje.elQueMenosViajo.filter(puedeTomarElViaje)

-- considerar el chofer que menos viaje tenga. Si hay más de un chofer elegir cualquiera.
-- funcion auxiliar (2)
elQueMenosViajo :: [Chofer] -> Chofer
elQueMenosViajo [chofer] = chofer
elQueMenosViajo (chofer1:chofer2:choferes)
 | (length.viajes) chofer1 < (length.viajes) chofer2 = elQueMenosViajo (chofer1:choferes)
 | otherwise = chofer1

--efectuar el viaje: esto debe incorporar el viaje a la lista de viajes del chofer. ¿Cómo logra representar este cambio de estado?
efectuarViaje :: Viaje -> Chofer -> Viaje
efectuarViaje viaje chofer =
  (ultimoViaje . viajes) chofer{ viajes = viajes chofer:[viaje]}

-- funcion auxiliar (3)
ultimoViaje :: [Viaje] -> Viaje
ultimoViaje = last

--
-- # PUNTO 7
--

-- dato del enunciado
repetirViaje viaje = viaje : repetirViaje viaje

-- Modelar al chofer “Nito Infy”, su auto tiene 70.000 kms.,
-- que el 11/03/2017 hizo infinitos viajes de $ 50 con Lucas y
-- toma cualquier viaje donde el cliente tenga al menos 3 letras. Puede ayudarse con esta función:
nito :: Chofer
nito = Chofer "Nito Infy" 70.000 (repetirViaje $ Viaje "11/03/2017" lucas 50) [nombreDelClienteConMasDe 3, cualquierViaje]

--
-- # PUNTO 8
--

gongNeng arg1 arg2 arg3 =
     max arg1 . head . filter arg2 . map arg3

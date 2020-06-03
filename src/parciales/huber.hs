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
  kilometraje :: Int,
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
type Condicion = [Viaje] -> [Viaje]

-- algunos choferes toman cualquier viaje
cualquierViaje :: Condicion
cualquierViaje viajes = viajes

type Precio = Int
-- otros solo toman los viajes que salgan más de $ 200
viajesMayoresA :: Condicion
viajesMayoresA = filter ((>200) .costo)

-- otros toman aquellos en los que el nombre del cliente tenga más de n letras
nombreDelClienteMasDe :: Int -> Condicion
nombreDelClienteMasDe minimoDeLetras =
  filter (longitudMayorIgualA minimoDeLetras.nombreCliente.cliente)

longitudMayorIgualA :: Int -> String -> Bool
longitudMayorIgualA longitud = (>= longitud).length


module Minigolfito where
-- DATOS

bart = ("Bart","Homero",(25,60))
todd = ("Todd","Ned",(15,80))
rafa = ("Rafa","Gorgory",(10,1))
nombre (n,_,_) = n
padre (_,p,_) = p
habilidad (_,_,h) = h

laguna largo = ((\(v,_,a)-> v>80 && between 10 50 a),(\(v,p,a) -> (v,p,a `div` largo)))
tunelConRampita = ((\(_,p,a) -> p>90 && a==0), (\(v,_,a) -> (v*2,100,0)) )
hoyo = ((\(v,p,a) -> between 5 20 v && p>95 && a==0), (\ _ -> (0,0,0)))
between n m x = elem x [n .. m]
maximoSegun f = foldl1 (mayorSegun f)
mayorSegun f a b
 | f a >= f b = a
 | otherwise = b

palos = putter : madera : map hierro [1 .. 10]

--
-- # PUNTO 1
--
type Velocidad = Int
type Precision = Int
type Altura = Int
type Fuerza = Int

type Tiro = (Velocidad, Precision, Altura)
type Habilidad = (Fuerza, Precision)
elDobleDe :: Int -> Int
elDobleDe = (*2)

laMitadDe :: Int -> Int
laMitadDe = flip $ div 2

elCuadradoDe :: Int -> Int
elCuadradoDe unNumero = unNumero*unNumero

-- PALOS
type Palo = Habilidad -> Tiro
putter :: Palo
putter (fuerza, precision) = (10, elDobleDe precision, 0)

madera :: Palo
madera (fuerza, precision) = (100, laMitadDe precision, 5)

type NumeroHierro = Int
hierro :: NumeroHierro -> Palo
hierro numeroHierro (fuerza, precision) =
  (fuerza*numeroHierro, div precision numeroHierro, elCuadradoDe numeroHierro)

--
-- # PUNTO 2
--
type Nombre = String
type NombreDelPadre = String
type Persona = (Nombre, NombreDelPadre, Habilidad)

type CondicionSobreElTiro = Tiro->Bool
type EfectoSobreElTiro = Tiro->Tiro

--type Obstaculo = Tiro -> (CondicionSobreElTiro, EfectoSobreElTiro)
type Obstaculo = (CondicionSobreElTiro, EfectoSobreElTiro)
elTiroCumpleCondicionesDelObstaculo (condicion, _) = condicion
elTiroLuegoDePasarPorElObstaculo (_, efecto) = efecto

golpe :: Persona -> Palo -> Tiro
golpe unaPersona unPalo =
  unPalo $ habilidad unaPersona

--puedeSuperar :: Obstaculo -> Bool
puedeSuperar :: Obstaculo -> Tiro -> Bool
puedeSuperar unObstaculo =   elTiroCumpleCondicionesDelObstaculo unObstaculo

suGolpeSuperaElObstaculo :: Persona -> Obstaculo -> Palo -> Bool
suGolpeSuperaElObstaculo unaPersona unObstaculo =
  puedeSuperar unObstaculo.golpe unaPersona

palosUtiles :: Persona -> Obstaculo -> [Palo]
palosUtiles unaPersona unObstaculo =
  filter (suGolpeSuperaElObstaculo unaPersona unObstaculo) palos

tieneAlMenosUnPaloUtil :: Persona -> [Obstaculo] -> Bool
tieneAlMenosUnPaloUtil unaPersona =
  any ((>1).palosUtiles unaPersona)

listarSusNombres :: [Persona] -> [String]
listarSusNombres = map (nombre)

nombresDeLosQuePuedenSuperarTodos :: [Obstaculo] -> [Persona] -> [String]
nombresDeLosQuePuedenSuperarTodos obstaculos =
  listarSusNombres.filter (\unaPersona -> tieneAlMenosUnPaloUtil unaPersona obstaculos)

--
-- # PUNTO 3
--
puedePasarPorObstaculo :: Tiro -> Obstaculo -> Bool
puedePasarPorObstaculo unTiro unObstaculo =
  elTiroCumpleCondicionesDelObstaculo unObstaculo $ (elTiroLuegoDePasarPorElObstaculo unObstaculo) unTiro

cuantosObstaculosSupera :: Tiro -> [Obstaculo] -> Int
cuantosObstaculosSupera tiro =
  length . filter (puedePasarPorObstaculo tiro)

paloMasUtil :: Persona -> [Obstaculo] -> Palo
paloMasUtil unaPersona obstaculos = undefined
  --maximoSegun
  --palosUtiles unaPersona $ obstaculos

module ParcialLaCasaDePdepEl where

import Text.Show.Functions

-- # PUNTO 1

data Ladron = UnLadron{
  nombreDelLadron :: String,
  habilidades :: [String],
  armas :: [Arma]
}deriving(Show)

data Rehen = UnRehen{
  nombreDelRehen :: String,
  nivelDeComplot :: Int,
  nivelDeMiedo :: Int,
  planes :: [PlanParaRebelarse]
}deriving(Show)

-- type Arma = Pistola | Ametralladora
data Arma = Pistola | Ametralladora deriving(Show)

data Pistola = UnaPistola{
  calibre :: Int
}

data Ametralladora = UnaAmetralladora{
  balasRestantes :: Int
}

tokio :: Ladron
tokio = UnLadron{
  nombreDelLadron = "Tokio",
  habilidades = ["trabajo psicologico", "entrar en moto"],
  armas = [Pistola 9, Pistola 9, Ametralladora 30]
}

profesor :: Ladron
profesor = UnLadron{
  nombreDelLadron = "Profesor",
  habilidades = ["disfrazarse de linyera", "disfrazarse de payaso", "estar siempre un paso adelante"],
  armas = []
}

pablo :: Rehen
pablo = UnRehen{
  nombreDelRehen = "Pablo",
  nivelDeComplot = 40,
  nivelDeMiedo = 30,
  planes = [esconderse]
}


arturito :: Rehen
arturito = UnRehen{
  nombreDelRehen = "Arturito",
  nivelDeComplot = 70,
  nivelDeMiedo = 50,
  planes = [esconderse, atacarAlLadronCon pablo]
}


-- # PUNTO 2

esteLadronEsInteligente :: Ladron -> Bool
esteLadronEsInteligente unLadron = ((>2).cuantasHabilidadesTiene) unLadron

type Habilidad = String
cuantasHabilidadesTiene :: Ladron -> Int
cuantasHabilidadesTiene = length.habilidades

-- # PUNTO 3
-- REVISAR
conseguirUnArma :: Arma -> Ladron -> Ladron
conseguirUnArma estaArma (UnLadron nombre habilidades armas) =
  UnLadron nombre habilidades (estaArma:armas)

-- nuevaArma = Arma

-- # PUNTO 4
type Intimidacion = Ladron -> Rehen -> Rehen

intimidarCon :: Intimidacion -> Ladron -> Rehen -> Rehen
intimidarCon algunMetodo ladron rehen = (intimidarA rehen.algunMetodo) ladron

intimidarA :: Intimidacion
intimidarA unRehen elMetodoQueIntimida = elMetodoQueIntimida unRehen

dispararAlTecho :: Intimidacion
dispararAlTecho ladron rehen = causarMiedoEn rehen

-- REVISAR
causarMiedoEn :: Rehen -> Rehen
-- no aclara cuanto mas miedo (?)
causarMiedoEn (UnRehen nombre complot miedo planes) = UnRehen nombre complot miedo planes

-- revisar si te sirve pattern matching
hacerseElMalo :: Intimidacion
hacerseElMalo esteLadron unRehen
  | (seLlamaIgualA "Berlin".nombreDelLadron) esteLadron = (cambiarMiedoEn.(+) cuantasHabilidadesTiene esteLadron) unRehen
  | (seLlamaIgualA "Rio".nombreDelLadron) esteLadron = cambiarComplotEn (+20) unRehen
  | otherwise = cambiarMiedoEn (+10) unRehen

seLlamaIgualA :: String -> String -> Bool
seLlamaIgualA esteNombre = (== esteNombre)

cambiarMiedoEn :: (Int->Int) -> Rehen -> Rehen
cambiarMiedoEn cuanto (UnRehen nombre complot miedo planes) =
  UnRehen nombre complot (cuanto miedo) planes

cambiarComplotEn :: (Int->Int) -> Rehen -> Rehen
cambiarComplotEn cuanto (UnRehen nombre complot miedo planes) =
  UnRehen nombre (cuanto complot) miedo planes

-- # PUNTO 5

calmarLasAguas :: Ladron -> [Rehen] -> [Rehen]
calmarLasAguas unLadron variosRehenes = (tienenDeComplotMasDe 60 . map (dispararAlTecho unLadron)) variosRehenes

tienenDeComplotMasDe :: Int -> [Rehen] -> [Rehen]
tienenDeComplotMasDe cuantoTienen = filter (>cuantoTienen)

-- # PUNTO 6

puedeEscaparseDeLaPolicia :: Ladron -> Bool
puedeEscaparseDeLaPolicia esteLadron = (tieneUnaHabilidadQueEmpiezeCon "disfrazarse de".habilidades) esteLadron

tieneUnaHabilidadQueEmpiezeCon :: Habilidad -> [Habilidad] -> Bool
tieneUnaHabilidadQueEmpiezeCon comoEmpieza susHabilidades = elem (esIgualA comoEmpieza) susHabilidades

esIgualA :: String -> String -> Bool
esIgualA estoOtro = (==estoOtro)

-- # PUNTO 7

estoPintaMal :: [Ladron] -> [Rehen] -> Bool
estoPintaMal variosLadrones variosRehenes =
  promedioEntreRehenesDeComplot > promedioEntreRehenesDeMiedo*armasDeLosLadrones
  where promedioEntreRehenesDeComplot = (promedioDe nivelDeComplot) variosRehenes
        promedioEntreRehenesDeMiedo   = (promedioDe nivelDeMiedo) variosRehenes
        armasDeLosLadrones = cuantasArmasTienen variosLadrones

promedioDe :: (Rehen->Int) -> [Rehen] -> Int
promedioDe queCosa deEstosRehenes = (flip div cantidadDe deEstosRehenes.sumar queCosa) deEstosRehenes

cantidadDe :: [Rehen] -> Int
cantidadDe = length

sumar :: (Rehen->Int) -> [Rehen] -> Int
sumar queCosa deQuienes = (sum.map (queCosa)) deQuienes

cuantasArmasTienen :: [Ladron] -> Int
cuantasArmasTienen estosLadrones = (length.map armas) estosLadrones

-- # PUNTO 8
type PlanParaRebelarse = Ladron -> Ladron

todosSeRebelanContra :: Ladron -> [Rehen] -> Ladron
--todosSeRebelanContra :: Ladron -> [Rehen] ->[Rehen]
todosSeRebelanContra esteLadron variosRehenes =
  foldl (rebelarseContra) esteLadron (todosPierden10DeComplot variosRehenes)
--  (map (rebelarseContra esteLadron).cambiarComplotEn ((-) 10)) variosRehenes

todosPierden10DeComplot :: [Rehen] -> [Rehen]
todosPierden10DeComplot quienes = map (cambiarComplotEn ((-) 10)) quienes

rebelarseContra :: Ladron -> Rehen -> Ladron
rebelarseContra esteLadron cualRehen = foldr ($) esteLadron (planes cualRehen)

atacarAlLadronCon :: Rehen -> PlanParaRebelarse
atacarAlLadronCon suCompaniero esteLadron =
  (sacarleTantasArmasA esteLadron.divididoPor 10.cantidadDeLetrasDelNombre) suCompaniero

divididoPor :: Int -> Int -> Int
divididoPor cuanto = flip div cuanto

cantidadDeLetrasDelNombre :: Rehen -> Int
cantidadDeLetrasDelNombre = length.nombreDelRehen

sacarleTantasArmasA :: Ladron -> Int -> Ladron
sacarleTantasArmasA (UnLadron nombre habilidades armas) cuantasArmas =
  UnLadron nombre habilidades (drop cuantasArmas armas)

esconderse :: PlanParaRebelarse
esconderse deEsteLadron = (sacarleTantasArmasA deEsteLadron.divididoPor 3.cuantasHabilidadesTiene) deEsteLadron

-- # PUNTO 9
ejecutarPlanValenciaPor :: [Ladron] -> [Rehen] -> Int
ejecutarPlanValenciaPor estosLadrones susRehenes =
  (escaparseConElDinero.armarseCon (UnaAmetralladora 45).seRebelanSusRehenes) estosLadrones
  where armarseCon estaArma = map (conseguirUnArma estaArma)
        escaparseConElDinero = (*1000000).cuantasArmasTienen
        seRebelanSusRehenes = map (\cadaLadron -> todosSeRebelanContra cadaLadron susRehenes)
{-
ejecutarPlanValenciaPor :: [Ladron] -> [Rehen] -> Int
ejecutarPlanValenciaPor estosLadrones susRehenes =
  (escaparConElDineroSegun cuantasArmasTienen.armarseCon ametralladora.seLesRebelanTodos susRehenes) estosLadrones

seLesRebelanTodos :: [Rehen] -> [Ladron] -> [Ladron]
seLesRebelanTodos susRehenes estosLadrones =
  map (\cadaLadron -> todosSeRebelanContra cadaLadron susRehenes) estosLadrones

armarseCon :: Arma -> [Ladron] -> [Ladron]
armarseCon estaArma estosLadrones = map (conseguirUnArma estaArma) estosLadrones
-}

-- PUNTO 10
-- No, porque no terminaria de completar el numero de armas que tienen, por tanto no podria multiplicar 1000000

-- PUNTO 11
-- No, porque una de las habilidades de los rehenes es esconderse, y similar al anterior no terminaria de
-- saber cuantas habilidades tiene para diviir por 3

-- PUNTO 12
--funcion :: Num a1 => b -> (a->d) -> (b->(a->Bool)) -> h -> [a] ->
-- funcion :: Ord x => b -> a1 -> (b->(d->Bool)) -> x -> [a] -> Bool
-- funcion cond num lista str = (> str) . sum . map (length . num) . filter (lista cond)


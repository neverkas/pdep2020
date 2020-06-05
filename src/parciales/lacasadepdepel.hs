module ParcialLaCasaDePdepEl where

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
  planes :: [Plan]
}deriving(Show)

-- type Arma = Pistola | Ametralladora
data Arma = Pistola | Ametralladora

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
  planes = [esconderse, atacarCon pablo]
}


-- # PUNTO 2

esteLadronEsInteligente :: Ladron -> Bool
esteLadronEsInteligente unLadron = ((>2).cuantasHabilidadesTiene) unLadron

type Habilidad = String
cuantasHabilidadesTiene :: Ladron -> Int
cuantasHabilidadesTiene = length.habilidades

-- # PUNTO 3
-- REVISAR
conseguirUnArma :: Ladron -> Ladron
conseguirUnArma (UnLadron nombre habilidades armas) = UnLadron nombre habilidades (Arma:armas)

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
hacerseElMalo unLadron unRehen
  | (seLlama "Berlin".nombre) ladron = (cambiarMiedoEn.(+) cuantasHabilidadesTiene ladron) unRehen
  | (seLlama "Rio".nombre) ladron = cambiarComplotEn (+20) unRehen
  | otherwise = cambiarMiedo (+10) unRehen

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
promedioDe queCosa deEstosRehenes = (flip div cantidad deEstosRehenes.sumar queCosa) deEstosRehenes

sumar :: (Rehen->Int) -> [Rehen] -> Int
sumar queCosa deQuienes = (sum.map (queCosa)) deQuienes

cuantasArmasTienen :: [Ladron] -> Int
cuantasArmasTienen estosLadrones = (length.map armas) estosLadrones

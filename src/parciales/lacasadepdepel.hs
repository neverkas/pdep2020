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


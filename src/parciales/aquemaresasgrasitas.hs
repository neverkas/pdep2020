module ParcialAquemarEsasGrasitas where

import Text.Show.Functions

type Edad = Int
type Peso = Int
type Tonificacion = Int
type Minutos = Int
type Ejercicio = Minutos -> Persona -> Persona

type Persona = (Edad, Peso, Tonificacion)

type Velocidad = Int

edad :: Persona -> Int
peso :: Persona -> Int
tonificacion :: Persona -> Int

edad (suEdad, _, _) = suEdad
peso (_, suPeso, _) = suPeso
tonificacion (_,_,suTonificacion) = suTonificacion

-- (edad, peso, tonificacion)
-- Si no agregas el tipo a ambos, devuelve un error entre Int e Integer
pancho :: Persona
andres :: Persona

pancho = ( 40, 120, 1)
andres = ( 22, 80, 6)
--relax minutos persona = persona

--
-- # Punto 1
--
saludable :: Persona -> Bool
saludable persona = (not.estaObeso) persona && ((>5).tonificacion) persona

estaObeso :: Persona -> Bool
estaObeso persona = ((>100) . peso) persona

--
-- # Punto 2
--

-- 150kcal -> 1kg
-- 300kcal -> x  = 300kcal/150kcal= bajara 2kg
quemarCalorias :: Int -> Persona -> Persona
quemarCalorias cuantasCalorias persona
  | estaObeso persona = cambiarPesoEn (restarle pesoPerdidoEstandoObeso) persona
  | esMayorDe30 && noEstaObeso && cuantasCalorias > 200 = cambiarPesoEn (restarle 1) persona
  | otherwise = cambiarPesoEn (restarle pesoEnRelacionCaloriasPesoEdad) persona
  where pesoPerdidoEstandoObeso = div cuantasCalorias 150
        esMayorDe30 = ((>30).edad) persona
        noEstaObeso = (not.estaObeso) persona
        pesoEnRelacionCaloriasPesoEdad = div cuantasCalorias (peso persona * edad persona)

restarle :: Int -> Int -> Int
-- Sin flip hace pesoPerdido-Peso, la idea es que sea Peso-PesoPerdido
-- otra manera seria usando abs, pero no seria la operacion correcta
restarle = flip (-)

cambiarPesoEn :: (Int->Int) -> Persona -> Persona
cambiarPesoEn cuantoCambiar (edad, peso, tonificacion) = (edad, cuantoCambiar peso, tonificacion)

--
-- # Punto 3
--
-- type Ejercicio = Persona -> Minutos -> Persona

-- kmPorHoraAMetrosPorSegundo cuantosKm = div (cuantosKm*1000) 3600
velocidadPromedio :: Int -> Int -> Int
velocidadPromedio velocidad tiempo = tiempo*velocidad

velocidadPromedioAcelerado :: Int -> Int -> Int
velocidadPromedioAcelerado velocidad tiempo = tiempo*(velocidad + div 14 2)

cambiarTonificacionEn :: (Int->Int) -> Persona -> Persona
cambiarTonificacionEn cuantoCambiar (edad, peso, tonificacion) = (edad, peso, cuantoCambiar tonificacion)

caminata :: Ejercicio
caminata minutos persona = quemarCalorias (velocidadPromedio 5 minutos) persona
entrenamientoEnCinta :: Ejercicio
entrenamientoEnCinta minutos persona = quemarCalorias (velocidadPromedioAcelerado 6 minutos) persona

pesas :: Int -> Ejercicio
pesas kilos minutos persona
  | minutos > 10 = cambiarTonificacionEn ((+) $ div kilos 10) persona
  | otherwise = persona


colina :: Int -> Ejercicio
colina inclinacion minutos persona = quemarCalorias (2*minutos*inclinacion) persona

montania :: Int -> Ejercicio
montania inclinacion minutos persona =
  (cambiarTonificacionEn (+1) .colina (inclinacion+3) (div minutos 2).colina inclinacion (div minutos 2)) persona

--
-- # Punto 4
--

type Nombre = String
type Duracion = Int
--type Rutina = (Nombre, Duracion, [Ejercicio])
type Rutina = (Nombre, Duracion, [Ejercicio])

-- Resolucion con Foldl
luegoDeHacerRutina :: Rutina -> Persona -> Persona
luegoDeHacerRutina (nombre, duracion, ejercicios) estaPersona =
  foldr (hacerEjercicio duracion) estaPersona ejercicios

hacerEjercicio :: Minutos -> Ejercicio -> Persona -> Persona
hacerEjercicio minutos ejercicio persona= ejercicio minutos persona

-- Resolucion con Recursividad
-- "Pendiente a Revisar" (los valores arrojados no son iguales al fold)
luegoDeHacerRutina' :: Rutina -> Persona -> Persona
luegoDeHacerRutina' (_, _, []) persona = persona
luegoDeHacerRutina' (nombre, duracion, (ejercicio1:ejerciciosSiguientes)) persona
  | aunQuedanEjercicios = luegoDeHacerRutina' (nombre, duracion, ejerciciosSiguientes) (ejercicio1 duracion persona)
  | otherwise = persona
  where aunQuedanEjercicios = ((>0).length) ejerciciosSiguientes

-- Simulaciones
simularRutina = ("rutina militar", 60, [caminata, entrenamientoEnCinta, pesas 50, colina 5]) 
simularEntrenamiento = luegoDeHacerRutina simularRutina pancho
simularEntrenamiento' = luegoDeHacerRutina' simularRutina pancho

type Kilos = Int
type ResumenRutina = (String, Kilos, Tonificacion)

resumenDeUnaRutina :: Rutina -> Persona -> ResumenRutina
resumenDeUnaRutina rutina persona =
  (nombreDeRutina rutina,kilosPerdidos rutina persona, tonificacionGanada rutina persona)

nombreDeRutina :: Rutina -> String
nombreDeRutina (nombre, _, _) = nombre

kilosPerdidos :: Rutina -> Persona -> Int
kilosPerdidos rutina persona = (peso persona) - (peso.luegoDeHacerRutina rutina) persona

tonificacionGanada :: Rutina -> Persona -> Int
tonificacionGanada rutina persona = abs $ (tonificacion persona) - (tonificacion.luegoDeHacerRutina rutina) persona
-- Con abs evito el problema de valores negativos, porque una persona puede no tener tonificacion
-- por tanto si gana 50 y tenia 0, te devolveria -50 como valor negativo
-- Una alternativa seria usando max y min para restarle al mayor valor el menor
-- Otra alternativa seria usando guardas con el concepto anterior de max y min

--
-- # Simulaciones
--
simularResumenDeUnaRutina = resumenDeUnaRutina simularRutina pancho

--
-- # Punto 5
-- "Pendiente a revisar"
-- Deberia mostrarlo cuando paso por varias, rutinas hasta que en un momento esa persona sea saludable?
-- O solo cuando es saludable ?

resumenDeVariasRutinas :: [Rutina] ->  Persona -> [ResumenRutina]
resumenDeVariasRutinas rutinas persona
  | saludable persona = map (\rutina -> resumenDeUnaRutina rutina persona) rutinas
  | otherwise = []

--
-- # Simulacion de codigo
--

simulacionCaminata = caminata 40 pancho
simulacionCinta = entrenamientoEnCinta 40 pancho
simulacionPesas = pesas 50 15 pancho
simulacionColina = colina 5 40 pancho
simulacionMontania = montania 5 40 pancho

--simulacionRutina =  luegoDeHacerRutina ("pancho", 5, [caminata, entrenamientoEnCinta , pesas 5, colina 10]) pancho

simulacionRutina' =
  luegoDeHacerRutina' ("pancho", 10, [caminata, entrenamientoEnCinta , pesas 5, colina 10]) pancho

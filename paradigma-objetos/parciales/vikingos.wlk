// PUNTO 1
/*
class Expedicion{
	method puedeIr(vikingo) = vikingo.puedeIr(self)
}
 */
 
class Vikingo{
	var castaSocial
	
	method esProductivo() = false
	
	// TODO: Revisar los parámetros que se pasa puedeIr()
	method puedeIr(expedicion) =
		self.esProductivo() && castaSocial.puedeIr(self)
}

class Soldado inherits Vikingo{
	var vidasCobradas = 0
	var cantidadArmas = 0
	
	override method esProductivo(){
		return self.minimoDeVidasCobradas(20) && self.tieneArmas()
	}
	
	method minimoDeVidasCobradas(cantidad) = 
		vidasCobradas >= cantidad 
	
	method tieneArmas() =
		cantidadArmas > 0
}

class Granjero inherits Vikingo{
	var hectareasAsignadas
	var cantidadHijos 
	
	override method esProductivo(){
		return self.cumpleMinimoDeHectareasPorHijo()
	}
	
	// TODO: Corregir cálculo
	method cumpleMinimoDeHectareasPorHijo() =
		hectareasAsignadas == 2*cantidadHijos	
}

object jarl{
	method puedeIr(vikingo) = 
		not vikingo.tieneArmas()
}

object karl{
	method puedeIr(vikingo) = true
}

object thrall{
	method puedeIr(vikingo) = true
}

// PUNTO 2
// TODO: Releer enunciado, no se está planteando para todos los lugares
class Expedicion{
	var lugaresInvolucrados = []
	var vikingos = []
	var monedas = 0

	// TODO: Releer el enunciado, que pide?
	method puedeIr(vikingo) = 
		vikingo.puedeIr(self)
	
	// TODO: Pide que sea uno o varios? Releer
	method valeLaPena(lugarInvolucrado) =
		lugarInvolucrado.botin(self)
	
	method invadir(lugarInvolucrado) =
		lugarInvolucrado.invadir(self)
	// TODO
	method cantidadVikingos() = vikingos.size()
}


class Capital{
	var potencialDeRiqueza = 0
	var defensores = 0
	var monedasSaqueadas = 0

	// TODO: Necesitamos pasar toda la expedición?
	// Evaluar el resto de los casos donde usamos botin() 	
	method botin(expedicion) =
		self.haySuficientesMonedasPorVikingo(expedicion)
	
	
	method invadir(expedicion){
		// TODO: Produce algun efecto en los vikingos?
		self.cobrarLaVidaDeDefensoresEn(expedicion.cantidadVikingos())
	}
		
	method cobrarLaVidaDeDefensoresEn(cantidad){
		defensores -= cantidad
	}
	method haySuficientesMonedasPorVikingo(expedicion) =
		expedicion.cantidadVikingos() == 3 * monedasSaqueadas
		// 1v => 3m, 2v => 6m, 3 => 9m, v => 3m
	
		
}

// TODO: No te falta algo del diagrama?
class Aldea{
	//var monedasSaqueadas = 0
	var cantidadCrucifijos = 0
	
	// TODO: Se podría asignar un parámetro en común para el botin de aldea/capital
	method botin()	=
		self.sedDeSaqueosSaciada()
	
	method invadir()
	
	method sedDeSaqueosSaciada() =
		self.monedasSaqueadas() >= 15
			
	method monedasSaqueadas() = cantidadCrucifijos

}

class AldeaAmurallada inherits Aldea{
	method valeLaPena(){
		self.cumpleCantidadDeVikingos()
	}
	
	method cumpleCantidadDeVikingos() = true
}
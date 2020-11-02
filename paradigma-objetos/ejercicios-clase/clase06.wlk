class Pirata{
	// mapa, brujula, loro, cuchillo, botellaGrogXD
	var items = []
	var monedas = 0
	var property nivelDeEbriedad = 0
	var property seAnimaASaquear = false
	
	method esUtil(mision)
	
	// TODO: Como resolver esta igualdad (?)
	method seAnimaASaquear(victima){
		if(victima == BarcoPirata){
			return self.estaPasadoDeGrog() && items.contains('botellaDeGrogXD'))
		}
		else if(victima == CiudadCostera){
			return self.nivelDeEbriedad() >= 50
		} 
	}
	
	method estaPasadoDeGrog() = self.nivelDeEbriedad() >= 90	

}

/*
 * Misiones
 */
class Mision{
	//var property puedeSerRealizada = false
	method puedeSerRealizada(barco) = barco.tieneSuficienteTripulacion()

	method esUtil(tripulanteBarco) = tripulanteBarco.esUtil()
	
}

object busquedaDelTesoro inherits Mision{
	const itemsRequeridos = ["brujula", "mapa", "botellaDeGrogXD"]
	
	override method esUtil(tripulante){
		return self.tieneItemsParticulares(tripulante) && self.tieneMonedasSuficienes(tripulante)
	}
	
	method tieneItemsParticulares(tripulante){
		return tripulante.items().any({
			item => itemsRequeridos.contains(item)
		})
	}
	
	method tieneMonedasSuficienes(tripulante) = tripulante.monedas() < 5
	
	override method puedeSerRealizada(barco){
		return super(barco) && barco.algunTripulanteTiene("llaveDeCofre")
	}
}

object convertirseEnLeyenda inherits Mision{
	override method esUtil(tripulante){
		return tripulante.items().size() >= 10 && tripulante.items().any({item=> item == "obligatorio"})
	}
}

object saqueo inherits Mision{
	var victima // ciudad o barco
	
	override method esUtil(tripulante){
		return tripulante.monedas() == configuracion.misionSaqueoMonedasRequeridas() && tripulante.seAnimaASaquear(victima)
	}
	
	override method puedeSerRealizada(barco){
		return super(barco) && victima.esVulnerable(barco)
	}
}

object configuracion{
	var property misionSaqueoMonedasRequeridas = 0
}

/*
 * Victimas 
 */

class Victima{
	// TODO: superclase method y override en la subclases o sólo property en superclase?
	//var property esVunerable = false
	method esVunerable(alguien) = false
} 

class BarcoPirata inherits Victima{
	var mision
	var tripulacion = []
	const capacidadMaximaDePersonas = 0
	
	method puedePertenecerALaTripulacion(pirata){
		return self.hayLugar() && pirata.esUtil(mision) 
	}
	
	method hayLugar(){
		return tripulacion.size() < capacidadMaximaDePersonas	
	}
	
	method agregarALaTripulacion(pirata){
		if(self.puedePertenecerALaTripulacion(pirata))
			tripulacion.add(pirata)
	}
	
	method mision(nuevaMision){
		mision = nuevaMision
		
		self.echarTripulantesInecesarios()
	}
	
	// TODO: se podría implementar forEach ?
	method echarTripulantesInecesarios(){
		const tripulantes = tripulacion.filter({
			tripulante => not tripulante.esUtil(mision) 
		})
		
		tripulacion.removeAll(tripulantes)
	}
	
	// TODO: Revisar si es necesario
	method esUtil() = self.tieneSuficienteTripulacion()
	
	method tieneSuficienteTripulacion() = tripulacion.size() >= capacidadMaximaDePersonas*0.9
	
	method algunTripulanteTiene(item){
		return tripulacion.any({
			tripulante => tripulante.items().contains(item)
		})
	}
	
	method esVulnerable(barco){
		return tripulacion.size() < barco.tripulacion().size()/2
	}
	
	method esTemible() = mision.puedeSerRealizada(self) && self.tripulantesUtiles().size() >= 5
	
	method tripulantesUtiles(){
		return tripulacion.filter({tripulante => tripulante.esUtil(mision) })
	}
}

class CiudadCostera inherits Victima{	
}
 
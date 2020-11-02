class Pirata{
	// mapa, brujula, loro, cuchillo, botellaGrogXD
	var items = []
	var monedas = 0
	var property nivelDeEbriedad = 0
	var property seAnimaASaquear = false
	
	method esUtil(mision)
	
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
	method esUtil(tripulante)
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
	method esVunerable(){ }	
} 

class BarcoPirata inherits Victima{
}
class CiudadCostera inherits Victima{	
}
 
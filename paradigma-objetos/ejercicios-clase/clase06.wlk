class Pirata{
	// mapa, brujula, loro, cuchillo, botellaGrogXD
	var items = []
	var monedas = 0
	
	method esUtil(mision)
}

/*
 * Misiones
 */
class Mision{
	
}

object busquedaDelTesoro inherits Mision{
	const itemsRequeridos = ["brujula", "mapa", "botellaDeGrogXD"]
	
	method esUtil(tripulante){
		self.tieneItemsParticulares(tripulante) && self.tieneMonedasSuficienes(tripulante)
	}
	
	method tieneItemsParticulares(tripulante){
		return tripulante.items().any({
			item => itemsRequeridos.contains(item)
		})
	}
	
	method tieneMonedasSuficienes(tripulante) = tripulante.monedas() < 5
}

object convertirseEnLeyenda inherits Mision{
	
}

object saqueo inherits Mision{
	
}

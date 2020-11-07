// rehacer
// tenias dudas con el diagrama de clases

class Inmueble{	
}

class Operacion{
	var agente
	var tipo
	
	method comision() =
		tipo.comision()
}

class Alquiler inherits Operacion{
	const cantidadDeMeses
	
	method comision() = cantidadDeMeses * self.valor() / 50000
	
}

class Venta inherits Operacion{
	var porcentaje
	
	method comision() = porcentaje * 100
}

const operacionA = new Aquiler(inmueble=barcito)

object barcito{
	
}
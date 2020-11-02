/*
 * Tripulantes
 */

class Pirata{
	var items = [] 	// mapa, brujula, loro, cuchillo, botellaGrogXD
	var monedas = 0
	var property nivelDeEbriedad = 0
	var property seAnimaASaquear = false
	
	method esUtil(mision) = mision.esUtil(tripulante)
	
	// TODO: Esto me generaba dudas..
	method seAnimaASaquear(victima){
		victima.puedeSerSaqueadoPor(self)
		/*
		if(victima == BarcoPirata){
			return self.estaPasadoDeGrog() && items.contains('botellaDeGrogXD'))
		}
		else if(victima == CiudadCostera){
			return self.nivelDeEbriedad() >= 50
		}  
		 */
	}
	
	method estaPasadoDeGrog() = self.nivelDeEbriedad() >= 90	

	method tomarSiPuedeTragoGrogXD(ciudad){
		ciudad.cobrarTragoGrogXD(self) // lanza exception si no puede pagar
		nivelDeEbriedad += 5			
	}
	
	method seQuedaEn(ciudad){
		ciudad.agregarHabitante(self)
	}
	
	method tieneItem(item) =  items.contains(item)
}

class EspiaDeLaCorona inherits Pirata{
	var tienePermisoDeLaCorona = false
	
	override method estaPasadoDeGrog() = false
	
	override method seAnimaASaquear(){
		super() && tienePermisoDeLaCorona	
	}
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
		return itemsRequeridos.any({
			item => tripulante.tiene(item)
		})
	}
	
	method tieneMonedasSuficienes(tripulante) = tripulante.monedas() < 5
	
	override method puedeSerRealizada(barco){
		return super(barco) && barco.algunTripulanteTiene("llaveDeCofre")
	}
}

object convertirseEnLeyenda inherits Mision{
	override method esUtil(tripulante){
		return 
			tripulante.items().size() >= 10 &&
			tripulante.tieneItem("obligatorio") 
			//tripulante.items().any({item=> item == "obligatorio"})
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
	
	// OBS: EN clase le preguntaron a la mision si ese pirata era util, delegaron distinto
	// Conclusión: Quizas.. porque el pirata puede mentir ? y la mision es la que en realidad sabe o no
	method puedePertenecerALaTripulacion(pirata){
		return self.hayLugar() && pirata.esUtil(mision) 
	}
	
	method hayLugar(){
		return tripulacion.size() < capacidadMaximaDePersonas	
	}
	
	// OBS: En clase agregaron lanzar excepción si no se podia agregar...
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
		
	// TODO: Revisar
	method tieneSuficienteTripulacion(){
		return tripulacion.size() >= capacidadMaximaDePersonas*0.9
	}
	
	method algunTripulanteTiene(item){
		return tripulacion.any({
			tripulante => tripulante.tieneItem(item)
		})
	}
	
	method esVulnerable(barco){
		return tripulacion.size() < barco.tripulacion().size()/2
	}

	// OBS #1: En clase generaron una capa de abstracción más, el puedeRealizarla por el barco que delega en la misión
	// OBS #2: EN clase utilizaron count() con el criterio, en vez de filter y size
	method esTemible(){
		return mision.puedeSerRealizada(self) && self.tripulantesUtiles().size() >= 5
	}
	
	method tripulantesUtiles(){
		return tripulacion.filter({tripulante => tripulante.esUtil(mision) })
	}
	
	// OBS: En clase usaron min(), count() y flatMap() ese ultimo es como el concatMap de haskell
	method itemMasRaro(){
		return tripulacion
		.map({
			tripulante => tripulante.items()
		})
		.min({
			item => self.algunTripulanteTiene(item)
		})
	}
	
	method anclar(ciudad){
		self.tripulacionSeEmborracha(ciudad)		
		self.elMasEbrioSePierde(ciudad)
	}
	
	// OBS: En clase filtraron quienes pueden pagarlo(delegaron), y luego tomar el trago
	method tripulacionSeEmborracha(ciudad){
		tripulacion.foreach({
			tripulante => tripulante.tomarSiPuedeTragoGrogXD(ciudad)
		})		
	}
	
	method elMasEbrioSePierde(ciudad){
		const tripulante = tripulacion.max({
			tripulante => tripulante.nivelDeEbriedad()
		})
		
		tripulante.seQuedaEn(ciudad)
		tripulacion.remove(tripulante)
	}
	
	// OBS: En clase no se evaluó si tenia la otella Grog, solo que esté pasadoDeGrog
	method puedeSerSaqueadoPor(pirata){
		return pirata.estaPasadoDeGrog() && pirata.tieneItem('botellaDeGrogXD')		
	}
}

class CiudadCostera inherits Victima{	
	var habitantes = []
	const costoTragoGrogXD = 0
	
	// OBS:En clase lo delegaron en la persona el pago && exception 
	method cobrarTragoGrogXD(persona){
		if(persona.monedas() < costoTragoGrogXD)
			self.error("Esta persona no tiene suficiente monedas para pagar el tragoGrogXD")
			
		persona.monedas(persona.monedas() - costoTragoGrogXD)
	}
	
	method agregarHabitante(habitante){
		habitantes.add(habitante)
	}
	
	method puedeSerSaqueadoPor(pirata) =  pirata.nivelDeEbriedad() >= 50
}
 
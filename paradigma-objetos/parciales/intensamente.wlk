class Persona{
	var recuerdosDelDia = []
	var pensamientosCentrales = #{}
	var memoriaALargoPlazo = []
	var property nivelDeFelicidad
	var emocionDominante
	var estadoDeAnimoActual // no es lo mismo que emocionDominante?
	
	method vivirEvento	(_descripcion, _fecha)
	method dormir()
	
	method niega(recuerdo) =
		estadoDeAnimoActual.negar(recuerdo) 	
	
	method asentar(recuerdo) = 
		recuerdo.serAsentadoPor(self)
		
	method recuerdosRecientesDelDia() =
		recuerdosDelDia.reverse().take(5)
		
	method pensamientosCentralesDificiles() =
		pensamientosCentrales.filter({
			pensamiento => pensamiento.esDificilDeExplicar()
		}) 
	
	// adicionales
	//
	method reducirFelicidadEn(cantidad){		
		const felicidadReducida = nivelDeFelicidad - cantidad
		self.validarFelicidad(felicidadReducida)		
		nivelDeFelicidad = felicidadReducida				
	}
	
	method validarFelicidad(cantidad){
		if(cantidad < 1) 
			throw new Exception(message="No puede tener felicidad menor a 1")		
	}
}

object riley inherits Persona(nivelDeFelicidad=1000){
	override method vivirEvento(_descripcion, _fecha){
		const recuerdo = new Recuerdo(descripcion=_descripcion, fecha=_fecha, emocion=emocionDominante)
		recuerdosDelDia.add(recuerdo)
	}
	
	override method dormir(){
		self.desencadenarProcesosMentales()
	}
	
	method desencadenarProcesosMentales(){
		const palabraClave
		
		self.asentamiento()
		self.asentamientoSelectivo(palabraClave)
		self.profundizacion()
		self.controlHormonal()
		self.restauracionCognitiva()
		self.liberacionDeRecuerdosDelDia()
	}
	
	method asentamiento(){
		recuerdosDelDia.forEach({
			recuerdo => self.asentar(recuerdo)
		})		
	}
	
	// OBSERVACION
	// - Se puede refactorizar ? se puede reutilizar asentamiento() ?
	method asentamientoSelectivo(palabraClave){
		recuerdosDelDia.filter({
			recuerdo => recuerdo.descripcion().contains(palabraClave)
		}).forEach({
			recuerdo => self.asentar(recuerdo)
		})		
	}
	
	method profundizacion(){
		const recuerdos = self.recuerdosNoCentralesDelDia()
		const recuerdosNoNegados = self.recuerdosNoNegados(recuerdos)
		
		memoriaALargoPlazo.addAll(recuerdosNoNegados)
	}
	
	method controlHormonal(){
		if(self.algunPensamientoCentralEstaEnMemoria() || self.losRecuerdosDelDiaTienenMismaEmocion())
			self.desequilibrioHormonal()
	}
	
	method desequilibrioHormonal(){
		self.reducirFelicidadEn(nivelDeFelicidad*0.15)
		self.pierdeTresPensamientosAntiguos()
	}
	
	method restauracionCognitiva(){
		nivelDeFelicidad = 1000.min(nivelDeFelicidad + 100)
	}
	
	method liberacionDeRecuerdosDelDia(){
		recuerdosDelDia.clear()
	}
	// extra
	//	
	
	// DUDAS: Son de los recuerdosDelDia o de la memoria?
	method pierdeTresPensamientosAntiguos(){
		const pensamientos = self.pensamientosAntiguos().take(3)
		memoriaALargoPlazo.removeAll(pensamientos)
	}
	
	// DUDAS: Son de los recuerdosDelDia o de la memoria?	
	method pensamientosAntiguos(){
		return memoriaALargoPlazo.sortedBy({
			pensamientoA, pensamientoB => pensamientoA.fecha() > pensamientoB.fecha() 
		})				
	}
	
	method algunPensamientoCentralEstaEnMemoria(){
		return pensamientosCentrales.any({
			pensamiento => memoriaALargoPlazo.contains(pensamiento)
		})		
	}
	
	method losRecuerdosDelDiaTienenMismaEmocion(){
		return recuerdosDelDia.all({
			recuerdoA, recuerdoB => self.tienenMismaEmocion(recuerdoA, recuerdoB)
		})
	}
	
	method tienenMismaEmocion(recuerdoA, recuerdoB){
		return recuerdoA.emocion() == recuerdoB.emocion()
	}
	
	// DUDAS
	// - Estará ok manejarse por flag? o deberia comparar con la colección de 
	// recuerdos centrales?
	method recuerdosNoCentralesDelDia(){
		return recuerdosDelDia.filter({
			recuerdo => not recuerdo.esCentral()
		})
	}
	
	method recuerdosNoNegados(recuerdos){
		return recuerdos.filter({
			recuerdo => not self.niega(recuerdo)
		})
	}
	
}

class Recuerdo{
	const descripcion
	const fecha
	const emocion
	var property esCentral = false
	
	method asentarse(persona, recuerdo){
		emocion.asentarse(persona, self)					
	}
	
	method esDificilDeExplicar() = descripcion.words().size() > 10
	
	method convertirseEnCentral(){
		esCentral = true
	}
}

//
// EMOCIONES 
//

object alegre{
	method asentarse(persona, recuerdo){
		if(persona.nivelDeFelicidad() > 500){
			persona.pensamientosCentrales().add(recuerdo)
			recuerdo.convertirseEnCentral()			
		}
	}
	
	method negar(recuerdo) =
		!(not recuerdo.tipo() == alegre)
}

object triste{
	method asentarse(persona, recuerdo){
		persona.pensamientosCentrales().add(recuerdo)
		persona.reducirFelicidadEn(persona.nivelDeFelicidad()*0.10)
	}

	method negar(recuerdo) =
		!(recuerdo.tipo() == alegre)
}

object disgusto{
	method asentarse(persona, recuerdo){}
	method negar(recuerdo){ }
}
object furioso{
	method asentarse(persona, recuerdo){}
	method negar(recuerdo){ }
}
object temeroso{
	method asentarse(persona, recuerdo){}
	method negar(recuerdo){ }
}
class Persona{
	var recuerdosDelDia = []
	var pensamientosCentrales = #{}
	var memoriaALargoPlazo = []
	var property nivelDeFelicidad
	var emocionDominante
	//var estadoDeAnimoActual
	
	method vivirEvento(descripcion)
	method dormir()
	
	// Observación: Tenias dudas si eran lo mismo
	//method niega(recuerdo) = estadoDeAnimoActual.negar(recuerdo)
	method niega(recuerdo) = emocionDominante.negar(recuerdo) 	
	
	method asentar(recuerdo) = 
		recuerdo.serAsentadoPor(self)
	
	// TODO:
	// - En realidad deberias ordenarlos por fecha y luego tomar los 5
	method recuerdosRecientesDelDia() = recuerdosDelDia.reverse().take(5)
		
	// Observacion: Los pensamientos eran recuerdos, es lo mismo
	method pensamientosCentralesDificiles() =
		pensamientosCentrales.filter({
			recuerdo => recuerdo.esDificilDeExplicar()
			//pensamiento => pensamiento.esDificilDeExplicar()
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
	// CORRECCION:
	// - No era necesario pasarle el parámetro fecha
	// - Podías usar la clase Date de la sig manera.: new Date()
	
	//override method vivirEvento(_descripcion, _fecha){
	//	const recuerdo = new Recuerdo(descripcion=_descripcion, fecha=_fecha, emocion=emocionDominante)
	override method vivirEvento(descripcion){
		const recuerdo = new Recuerdo(descripcion=descripcion, fecha=new Date(), emocion=emocionDominante)
		recuerdosDelDia.add(recuerdo)
	}
	
	override method dormir(){
		self.desencadenarProcesosMentales()
	}
	
	// Observación: 
	// - La resolución utilizó una colección del tipo lista, y apply()
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
	
	// Observación:
	// - La resolución guardó como referencia al poseedor del recuerdo
	// por tanto no pasaba por parámetro a la persona en serAsentadoPor()
	method serAsentadoPor(persona){
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
	// Observacion:
	// - Estaba bien, pero faltaba delegar en puedoAsentarme()
	method asentarse(persona, recuerdo){
		if(self.puedoAsentarme(persona, recuerdo)){
		//if(persona.nivelDeFelicidad() > 500){
			persona.pensamientosCentrales().add(recuerdo)
			// Observacion: No era necesario este flag
			//recuerdo.convertirseEnCentral()			
		}
	}
	
	method puedoAsentarme(persona, recuerdo) = persona.nivelDeFelicidad() > 500
		
	//method negar(recuerdo) = !(not recuerdo.tipo() == alegre)
	method negar(recuerdo) = recuerdo.tipo() != alegre
}

object triste{
	method asentarse(persona, recuerdo){
		persona.pensamientosCentrales().add(recuerdo)
		persona.reducirFelicidadEn(persona.nivelDeFelicidad()*0.10)
	}

	method negar(recuerdo) = recuerdo.tipo() == alegre
	//method negar(recuerdo) = !(recuerdo.tipo() == alegre)
}

// Observacion: Si los anteriores (alegre, triste) retornan algo al negar
// estos tambień
object disgusto{
	method asentarse(persona, recuerdo){}
	
	//method negar(recuerdo){ }
		method negar(recuerdo){
		return false
	}

}
object furioso{
	method asentarse(persona, recuerdo){}
	//method negar(recuerdo){ }
	method negar(recuerdo){
		return false
	}

}
object temeroso{
	method asentarse(persona, recuerdo){}
	//method negar(recuerdo){ }
	method negar(recuerdo){
		return false
	}
	

}
// PUNTO 1
//
class Persona{
	// ALTERNATIVA
	// - Se podria haber hecho sólo un listado de suenios
	// - consultar si esta pendiente
	var sueniosCumplidos = []
	var sueniosPendientes = []
	var tipoDePersona
	var nivelDeFelicidad
	
	// OBSERVACION
	// - Es responsabilidad de la persona o del suenio ?
	// - Hay efecto en el suenio? o en la persona? o en ambos?
	method cumplirSuenio(suenio){
		sueniosCumplidos.add(suenio)
	}
	
	method validarSuenio(suenio){
		try{
			suenio.validarSuenio(self)
			self.cumplirSuenio(suenio)			
		}catch e: SuenioException{
			sueniosPendientes.add(suenio)
		}

	}	
	
	method tieneHijo() = false
	
	method cumplirSuenioMasPreciado(){
		const suenio = tipoDePersona.suenioMasPreciado(sueniosPendientes)
		self.cumplirSuenio(suenio)
	}

	// PUNTO 4
	//
			
	// TODO:
	// - Corregir el nivelDeFelicidad, está representado por los felicidonios (no es claro el enunciado, pero bueno)
	method esFeliz() =
		nivelDeFelicidad > self.sumaDefelicidonios()
	
	method sumaDefelicidonios() =
		sueniosPendientes.sum({suenio=>suenio.felicidonios()})
		
	// PUNTO 5
	//
	
	// OBSERVACION:
	// - Si hubiese sido solo una lista suenios = [] con un estado esPendiente(), no tendrías que usar union
	method esAmbiciosa() =
		// TODO:
		// - solo deberia filtrar por los suenios ambiciosos, contarlos, y compararlo con si es mayor a 3
		self.cuantosTienenMuchosFelicidonios(self.todosLosSuenios()) > 3
	
	method todosLosSuenios() =
		sueniosCumplidos.union(sueniosPendientes)
	
	// TODO
	// - al Suenio le falta el mensaje esAmbicioso()
	// - La lógica de felicidonio() > 100 hay que delegarlo en el suenio, él sabe eso
	// - No hay que contarlos, el suenio debe solo retornarlo (si es sueño simple) ò sumarlos (si es sueño compuesto osea que tenga multiples sueños)
	method cuantosTienenMuchosFelicidonios(suenios){
		return suenios.count({
			suenio => suenio.felicidonios() > 100
		})
	}
}

// TODO
// - No falta un suenio más? 
// El enunciado lo pide mediante una demostración de código que pide que se pueda hacer
class Suenio{
	const property nivelFelicidad
	
	method validarSuenio(persona){
		if(not self.seCumpleSuenio(persona))
			throw new SuenioException(message="No puede cumplir su deseo")		
	}
	
	method seCumpleSuenio(persona)
}


class SuenioException inherits DomainException{ }

// TODO
// - No deberia lanzar una excepción distinta si no se cumple quiereEstudiar y seRecibioDe ?
// es decir no deberia tener cada criterio un error distinto?
// - No deberia tener efecto en la persona? cuál sería?
object recibirseDe inherits Suenio{
	var carrera
	
	// ALTERNATIVA:
	// - Se podria haber utilizado error.throwExceptionWithMessage("un mensaje")
	override method seCumpleSuenio(persona) =
		persona.quiereEstudiar(carrera) || not persona.seRecibioDe(carrera)
		//if(not persona.quiereEstudiar(carrera) || persona.seRecibioDe(carrera))
		//	throw new Exception(message="No puede cumplir su deseo") 			
}

object conseguirEmpleo inherits Suenio{
	var empleo
	
	override method seCumpleSuenio(persona) =
		empleo.salario() > persona.sueldoQueQuiere()
}

// TODO
// - Si puede adoptar no tendria que haber efecto en la persona? Cual sería ese efecto?
// - Si hubiese efecto sería en otro método? o en ese mismo? que abstracción necesitarías? 
object adoptarHijo inherits Suenio{
	var nombre
	
	override method seCumpleSuenio(persona) =
		not persona.tieneHijo()
}

// PUNTO 2
//
object multipleSuenios inherits Suenio{
	var suenios = []
	
	override method seCumpleSuenio(persona){
		suenios.forEach{
			suenio => suenio.validarSuenio(persona)
		}		
	}
}

// PUNTO 3
//

object realista{
	method suenioMasPreciado(suenios){
		return suenios.max({
			suenio => suenio.nivelFelicidad()
		})
	}	
}

object alocado{
	method suenioMasPreciado(suenios) =
		suenios.anyOne()
}

object obsesivo{
	method suenioMasPreciado(suenios) =
		suenios.first()
}
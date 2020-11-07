// PUNTO 1
//
object Persona{
	var sueniosCumplidos = []
	var sueniosPendientes = []
	var tipoDePersona
	var nivelDeFelicidad
	
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
	method esFeliz() =
		nivelDeFelicidad > self.sumaDefelicidonios()
	
	method sumaDefelicidonios() =
		sueniosPendientes.sum({suenio=>suenio.felicidonios()})
		
	// PUNTO 5
	//
	method esAmbiciosa() =
		self.cuantosTienenMuchosFelicidonios(self.todosLosSuenios()) > 3
	
	method todosLosSuenios() =
		sueniosCumplidos.union(sueniosPendientes)
	
	method cuantosTienenMuchosFelicidonios(suenios){
		return suenios.count({
			suenio => suenio.felicidonios() > 100
		})
	}
}

class Suenio{
	const property nivelFelicidad
	
	method validarSuenio(persona){
		if(not self.seCumpleSuenio(persona))
			throw new SuenioException(message="No puede cumplir su deseo")		
	}
	
	method seCumpleSuenio(persona)
}


class SuenioException inherits DomainException{ }

object recibirseDe inherits Suenio{
	var carrera
	
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
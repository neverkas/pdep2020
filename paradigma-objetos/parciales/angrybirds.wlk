class Isla{
	var pajaros = []
	
	method pajarosFuertes() =
		pajaros.filter({pajaro => pajaro.esFuerte() })
	
	
	method fuerzaTotalIsla() =
		self.pajarosFuertes().sum({pajaro => pajaro.fuerza()})
		
}

object islaCerdito{
	var obstaculos = []	
	
	method libreDeObstaculos() = obstaculos.isEmpty()
}

object islaPajaro inherits Isla{
	var cantidadInvasores
	
	method sesionDeManejoDeLaIra(){
		pajaros.forEach({
			pajaro => pajaro.tranquilizarse()
		})
	}
	
	method invasionDeCerditos(){
		(cantidadInvasores/100).apply{self.enojarATodosLosPajaros()}
	}
	
	method fiestaSorpresa(){
	}
	
	method serieDeEventosDesafortunados(){		
		self.sesionDeManejoDeLaIra()
		self.invasionDeCerditos()
		self.fiestaSorpresa()
	}
	
	method enojarATodosLosPajaros(){
		pajaros.forEach({
			pajaro => pajaro.hacerEnojar()
		})		
	}
	
	method atacarIsla(isla){		
		pajaros.forEach({	
			pajaro => pajaro.atacar(isla)
		})
	}
	
	method atacarIslaCerdito(){
		self.atacarIsla(islaCerdito)
	}

	method seRecuperaronLosHuevos() =
		islaCerdito.libreDeObstaculos()
}

class Pajaro{
	var property fuerza
	var property ira
	
	method hacerEnojar(){
		fuerza = 2 * ira
	}
	
	method esFuerte() = fuerza > 50
	
	method tranquilizarse(){
		ira -= 5
	}

	method atacar(isla){					
		self.impactarObstaculoMasCercano(isla)		
	}
				
	method impactarObstaculoMasCercano(isla){
		const obstaculo = isla.obstaculoMasCercanoA(self)
		obstaculo.serImpactadoPor(self)	
	}
	
}

object red inherits Pajaro{
	var property vecesQueSeEnojo
	
	override method fuerza() = ira * 10 * vecesQueSeEnojo
	
}

object bomb inherits Pajaro{
	var topeDeFuerza = 9000
	
	override method fuerza(){		
		self.validarSuperaMaximoFuerza(super())
					
		super()
	}
	
	method validarSuperaMaximoFuerza(cantidad){
		if(cantidad > topeDeFuerza) 
			throw new Exception(message="Superó su tope de fuerza")		
	}

}

object chuck inherits Pajaro{
	var velocidad 
	var fuerzaBase = 150
	
	override method hacerEnojar(){
		velocidad *= 2
	}
	
	override method fuerza(){
		if(velocidad <= 80) 
			return fuerzaBase
		else 
			return fuerzaBase + 5 * (80 - velocidad)		
	}
	
	override method tranquilizarse(){
		// no hace nada, no se tranquiliza
	}
	
}

object terence inherits Pajaro{
	var multiplicador
	var vecesQueSeEnojo
	
	override method fuerza() = multiplicador * vecesQueSeEnojo
}

object matilda inherits Pajaro{
	var huevos = []
	
	override method fuerza() = 2 * ira + self.fuerzaTotalDeSusHuevos()
				
	override method hacerEnojar(){
		self.ponerHuevo(2)
	}
	
	method fuerzaTotalDeSusHuevos() =
		huevos.sum({huevo => huevo.fuerza()})
		
	method ponerHuevo(pesoEnKg){
		huevos.add(new Huevo(peso = pesoEnKg))
	}

}

class Huevo{
	const peso
	method fuerza() = peso
}


class Obstaculo{
	var property resistencia
	var derribado = false
	
	method serImpactadoPor(pajaro){
		if(pajaro.fuerza() > self.resistencia()){
			derribado = true
		}
	}
	
	method estaEnPie() = not derribado
}

class Pared inherits Obstaculo{
	const anchoDePared
	var material
	
	override method resistencia() = anchoDePared * material.resistencia()
	
	// otra manera..
	// override method resistencia() = anchoDePared * self.criterio()
	// method criterio()
}

object paredDeVidrio{ method resistencia() = 10 }
object paredDeMadera{ method resistencia() = 25 }
object paredDePiedra{ method resistencia() = 50 }
/* 
object paredDeVidrios inherits Pared{
	override method criterio() = 10
}
object paredDeMadera inherits Pared{
	override method criterio() = 25
}
object paredDePiedra inherits Pared{
	override method criterio() = 50
}  
 */

class Cerdito inherits Obstaculo{
	override method resistencia() = 50
}

class CerditoArmado inherits Cerdito{
	var estaArmadoCon // casco ó escudo
	
	override method resistencia() =10 * estaArmadoCon.resistencia() 
}

object casco{ var resistencia }
object escudo{ var resistencia }


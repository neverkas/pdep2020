/*
 * Animales
*/
class Animal{
	var peso = 0
	var property tieneSed = false	
	var property tieneHambre = false
	
	method comer(cantidad)
	method beber()
	method recibirAtencion(){ }

	method recibirVacunacion(){ }
}

class Vaca inherits Animal{
	override method comer(cantidad){
		peso += cantidad / 3
		tieneSed = true
	}
	
	override method beber(){
		peso -= 0.5 // 500grs
		tieneSed = false
	}
	
	override method tieneHambre() = peso < 200 // kg	
}

class Cerdo inherits Animal{
	var vecesQueComioSinBeber = 0
	
	override method comer(cantidad){
		vecesQueComioSinBeber +=1 
		
		if(cantidad > 0.2) // 200 grs
			peso += cantidad - 200
		if(cantidad > 1) // 1 Kg
			tieneHambre = false
	}

	override method beber(){
		tieneHambre = true
		vecesQueComioSinBeber = 0
	}
	override method tieneSed() = vecesQueComioSinBeber > 3
	
}

class Gallina inherits Animal{
	override method tieneHambre() = true
	override method tieneSed() = true
	
	override method comer(cantidad){
		// no hace nada		
	}
	override method beber(){
		// no hace nada
	}
	
}

/*
 * Dispositivos
*/

class Dispositivo{
	const property consumoEnergetico = 0
	
	method atender(animal){
		animal.recibirAtencion()
	}
	
	method esUtilPara(animal)
}

// TODO: Debe poder haber varios dispositivos, deberia ser una clase
object bebedero inherits Dispositivo(consumoEnergetico=10){
	override method atender(animal){
		super(animal)
		// TODO: será mejor animal.recibirLiquido() ?
		animal.beber()
	}
	
	override method esUtilPara(animal) = animal.tieneSed()
}

// TODO: Debe poder haber varios dispositivos, deberia ser una clase
object comedero inherits Dispositivo(consumoEnergetico=10){
	const cantidadAlimento = 0
	const pesoSoportado = 0
	
	override method consumoEnergetico(){
		return super() * pesoSoportado 
	}
	
	override method atender(animal){		
		self.sePuedeAtender(animal)
		
		super(animal)	
		// TODO: será mejor animal.recibirComida()?		
		animal.comer(cantidadAlimento)
	}
	
	method sePuedeAtender(animal){
		if(animal.peso() > pesoSoportado)
			self.error("El comedero no soporta un animal de " +animal.peso() +" Kg")		
	}
	
	// TODO: No pide mas erquisitos? no deberia tener incluir lo del peso?
	method esUtilPara(animal) = animal.tieneHambre()
}

// TODO: Debe poder haber varios dispositivos, deberia ser una clase
object vacunatorio inherits Dispositivo{
	var vacunas = []
	
	override method consumoEnergetico(){
		if(self.hayVacunas()) 
			return 50
		else 
			return 0
	}
	
	override method atender(animal){
		super(animal)
		
		if(self.convieneVacunar(animal)){
			animal.recibirVacuna()
			vacuna			
		}

	}
	
	override method esUtilPara(animal) =
		self.hayVacunas() && self.convieneVacunar(animal)
	
	method hayVacunas() = vacunas.size() > 0
	
	method convieneVacunar(animal){
		if(animal == vaca && !animal.estaVacunada())
			return true
		else if(animal == cerdo)
			return true
		else if(animal == gallina)
			return false		
	}
}
/*
 * Estacion
*/

class Estacion{
	var dispositivos = []
	
	method agregarDispositivo(dispositivo){
		dispositivos.add(dispositivo)
	}
	
	method quitarDispositivo(dispositivo){
		dispositivos.remove(dispositivo)
	}
	
	// TODO: No falta algo?
	method consumoEnergetico(){
		return dispositivos.sum({dispositivo => dispositivo.consumoEnergetico()})
	}
	
	method esUtilPara(animal){
		return dispositivos.any({dispositivo => dispositivo.esUtilPara(animal)})
	}
	
	method dispositivosUtilesPara(animal){
		return dispositivos.filter({dispositivo => dispositivo.esUtilPara(animal)})
	}
	
	method atencionBasica(animal){
		// TODO: el criterio parece ser distinto al de abajo
		// TODO: se podria generalizar la excepcion, para que la lanze un método?
		// asi si cambio el mensaje, no hay que cambiar uno por uno
		if(!self.esUtilPara(animal))
			self.error("Ningun dispositivo es util para este animal")
			
		// que sucede si el mensaje min(), no encuentra ningun
		// elemento? lanza excepción? se puede preguntar con un if?
		// TODO: en vez de usar esUtilPara podrias usar dispositivosUtilesPara como colección? 
		const dispositivo = dispositivos.min({
			dispositivo => 
			dispositivo.consumoEnergetico()
			dispositivo.esUtilPara(animal)
		})
		
		dispositivo.atender(animal)
	}
	
	method atencionCompleta(animal){
		if(!self.esUtilPara(animal))
			self.error("Ningun dispositivo es util para este animal")
		
		// TODO: Tenia dudas si forEach era el adecuado
		self.dispositivosUtilesPara(animal).forEach({
			dispositivo => dispositivo.atender(animal)
		})	
	}
}
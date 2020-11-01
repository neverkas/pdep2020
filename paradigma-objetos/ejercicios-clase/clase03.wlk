class Persona{
	const property dimension
	var property energia = 0
	var property poder = 0
	
	method atacar(contrincante)
	method poder()
}

class Enemigo{
	method poder() = 0
	method recibirDanio(valor){ }
}

object glorzo inherits Enemigo{
	var anfitrion
	
	override method recibirDanio(valor){
		anfitrion.energia(anfitrion.energia() - valor) 
	}	
	
	override method poder() = anfitrion.poder()
}

object gromflomite inherits Enemigo{	
}

class Morty inherits Persona{
	const poderBase = 100
	var energiaBase = 50
	
	override method poder(){
		if(self.traumado())
			return poderBase*3
		else
			return poderBase
	}
	
	override method atacar(contrincante){
		energiaBase -= 10
	}
	
	method traumado() = energia < 30
	
	method esDeSuDimension() = dimension == "C-137"
}

object mortyOriginal inherits Morty(dimension="C-137"){	
}

object mortyClon inherits Morty(dimension="C-138", energiaBase=150, poderBase=150){	
}

object rick inherits Persona(dimension="C-137",energia=100, poder=200){
	override method poder(){
		return super() + pistolaDePortales.poder()
	}
	
	override method atacar(contrincante){
		if(self.poder() > contrincante.poder())
			poder += 10
		else
			energia -= 50
			
		contrincante.recibirDanio(self.poder())
	}
}

object pistolaDePortales{
	const poder = 50
	
	method poder() = poder // getter
}
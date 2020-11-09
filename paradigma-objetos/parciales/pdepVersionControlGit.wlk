//
// Punto 1
//
class Carpeta{
	var nombre
	var archivos = []
	
	method contiene(nombreArchivo) = 
		archivos.find({
			archivo => archivo.nombre() == nombreArchivo
		})
}

class Archivo{
	var nombre
	var descripcion
	
	method agregarAlFinal(texto){
		descripcion += texto
	}
	method sacarDelFinal(texto){
		
	}
}

//
// Punto 2
//
class Commit{
	var descripcion
	var cambios
	
	method aplicarCambios(carpeta){		
		cambios.forEach({
			cambio => cambio.aplicarCambio(carpeta)
		})
	}
}

class Cambio{
	const archivo
	var tipo
	
	//method aplicarCambio(archivo, carpeta){
	method aplicarCambio(carpeta){
		//self.validarSiSePuedeAplicarCambio(archivo, carpeta)
		self.validarSiSePuedeAplicarCambio(carpeta)
		tipo.aplicarCambio(archivo, carpeta)
	}
	
	//method validarSiSePuedeAplicarCambio(archivo, carpeta){
	method validarSiSePuedeAplicarCambio(carpeta){
		tipo.validarSiSePuedeAplicarCambio(archivo, carpeta)
	}
}

object crear{	
	method aplicarCambio(archivo, carpeta){
		if(not carpeta.contiene(archivo)) carpeta.add(archivo)		
	}
	method validarSiSePuedeAplicarCambio(archivo, carpeta){ }	
}
object eliminar{
	method aplicarCambio(archivo, carpeta){		
		carpeta.remove(archivo)			
	}
	method validarSiSePuedeAplicarCambio(archivo, carpeta){
		if(not carpeta.contiene(archivo)) throw new Exception(message="No se puede aplicar cambio")		
	}				
}
object agregar{
	var property texto
	
	method aplicarCambio(archivo, carpeta){		
		archivo.agregarAlFinal(texto)					
	}
	method validarSiSePuedeAplicarCambio(archivo, carpeta){
		if(not carpeta.contiene(archivo)) throw new Exception(message="No se puede aplicar cambio")		
	}					
}
object sacar{
	var texto
	
	method aplicarCambio(archivo, carpeta){		
		archivo.sacarDelFinal(texto)					
	}
	method validarSiSePuedeAplicarCambio(archivo, carpeta){
		if(not carpeta.contiene(archivo)) throw new Exception(message="No se puede aplicar cambio")		
	}						
}
/*
 * 
 * 
 */
 
 const carpeta = new Carpeta(nombre="pdep")
 const commit = new Commit(descripcion="commit inicial", cambios=[
 	new Cambio(tipo=crear, archivo="readme.md"),
 	new Cambio(tipo=crear, archivo="parcial.wlk"),
 	 // esto me hace dudar si en realidad deberian ser clases
 	new Cambio(tipo=agregar.texto("este es un parcial"), archivo="readme.md")
 ])
  //const commit = new Commit(descripcion="commit inicial", cambios=[cambio1, cambio2, cambio3])
// const cambio1 = new Cambio(tipo=crear, archivo="readme.md")
 //const cambio2 = new Cambio(tipo=crear, archivo="parcial.wlk")
 // esto me hace dudar si en realidad deberian ser clases
 // del tipo class agregarArchivo, sacarArchivo,...
 //const cambio3 = new Cambio(tipo=agregar.texto("este es un parcial"), archivo="readme.md")
 
 
 
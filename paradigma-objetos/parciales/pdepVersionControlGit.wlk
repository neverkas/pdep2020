/**********************************************************************************/
//
// Punto 1
//

// OBSERVACION:
// - La resolución agrega las acciones crear/eliminar/agregar/sacar que tenias
// en cambios, dentro de esta clase
class Carpeta{
	var nombre
	var archivos = []
	
	method contiene(nombreArchivo){
		return archivos.find({
			archivo => archivo.nombre() == nombreArchivo
		})		
	}
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

/**********************************************************************************/
//
// Punto 2
//

// OBSERVACION:
// - La resolución decide agregar un agregarCambio()
class Commit{
	// OBSERVACION:
	// - La resolución decide guardar referencia de la carpeta
	var descripcion
	var cambios = []
	const autor
	
	method aplicarCambios(carpeta){		
		cambios.forEach({
			cambio => cambio.aplicarCambio(carpeta)
		})
	}
	
	method contieneArchivo(archivo){
		return cambios.any({ cambio => cambio.contains(archivo) })
	}
	
	// OBSERVACION:
	// - La resolución decide no tener una clase Revert, pone todo en el Commit
	method revert(){
		const commit = new Revert(descripcion=descripcion, cambios=cambios, autor=autor)
		commit.invertirCambios()
		commit.cambiarDescripcion()
	}
	
	// OBSERVACION
	// - La resolución decide poner un nombre más adecuado a que tipo de permisos
	// es decir usuario.puedeComitear(unBranch)
	// - Y de parámetro le pasa un Branch, no el commit 
	method tienePermisos(usuario){
		return usuario.tienePermisos(self)	
	}
}

// OBSERVACION
// - La resolución opta por usar Cambio como superclase, es decir usa herencia
// no utiliza composición
class Cambio{
	// OBSERVACION:
	// - EN la resolución tienen como referencia el nombre del archivo, no el objeto archivo
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
	
	method invertirCambio(cambio){ 
		tipo = tipo.opuesto()
	}
	
}


// OBSERVACION
// - En la resolución agregaron estas acciones como parte de la Carpeta
// - En la resolución en vez de la constante opuesto, tienen un método revert()
// que retorna el cambio opuesto
object crear{
	const opuesto = eliminar 
		
	method aplicarCambio(archivo, carpeta){
		// OBSERVACION
		// - La resolución opta por usar el mensaje negate() en vez de not
		// - Y la clase Carpeta tiene su mensaje crearArchivo(nombre)
		if(not carpeta.contiene(archivo)) carpeta.archivos().add(new Archivo(nombre=archivo, descripcion=""))		
	}
	method validarSiSePuedeAplicarCambio(archivo, carpeta){ }	
}

object eliminar{
	const opuesto = crear
	
	method aplicarCambio(archivo, carpeta){		
		carpeta.remove(archivo)			
	}
	method validarSiSePuedeAplicarCambio(archivo, carpeta){
		if(not carpeta.contiene(archivo)) throw new Exception(message="No se puede aplicar cambio")		
	}				
}

object agregar{
	const opuesto = sacar
	
	var property texto
	
	method aplicarCambio(archivo, carpeta){
		// OBSERVACION:
		// - La resolucion opta por tener agregarContenido() en la clase Carpeta
		// por tanto hace carpeta.agregarContenido(nombreArchivo, texto)
		archivo.agregarAlFinal(texto)					
	}
	method validarSiSePuedeAplicarCambio(archivo, carpeta){
		if(not carpeta.contiene(archivo)) throw new Exception(message="No se puede aplicar cambio")		
	}					
}

object sacar{
	const opuesto = agregar
	
	var texto
	
	method aplicarCambio(archivo, carpeta){		
		archivo.sacarDelFinal(texto)					
	}
	method validarSiSePuedeAplicarCambio(archivo, carpeta){
		if(not carpeta.contiene(archivo)) throw new Exception(message="No se puede aplicar cambio")		
	}						
}
 
 const carpeta = new Carpeta(nombre="pdep")
 const commit = new Commit(descripcion="commit inicial", cambios=[
 	new Cambio(tipo=crear, archivo="readme.md"),
 	new Cambio(tipo=crear, archivo="parcial.wlk"),
 	 // este de abajo me hace dudar si en realidad deberian ser clases
 	new Cambio(tipo=agregar.texto("este es un parcial"), archivo="readme.md")
 ])

/**********************************************************************************/
//
// Punto 3 y 4
//
 class Branch{
 	var commits = []
 	var colaboradores = []
 	
 	method checkout(carpeta){
 		commits.forEach({
 			commit => commit.aplicarCambios(carpeta)
 		})
 	}
 	
 	method log(archivo){
 		return commits.filter({
 			commit => commit.contieneArchivo(archivo)
 		})		
 	}
 }
 
/**********************************************************************************/
//
// Punto 5
//
 class Revert inherits Commit{
 	// OBSERVACION
 	// - La resolucion decide retornar los cambios invertidos
 	// y usarlo al momento de instanciar el commit invertido, 
 	// es decir no generó efecto en el momento
 	method invertirCambios(){ 		
 		cambios.forEach({
 			cambio => cambio.invertirCambio()
 		}).reverse()
 	}
 	
 	method cambiarDescripcion(){
 		descripcion = "revert " + descripcion
 	}
 }
/*
 const carpeta = new Carpeta(nombre="pdep")
 const commit = new Commit(descripcion="commit inicial", cambios=[
 	new Cambio(tipo=crear, archivo="readme.md"),
 	new Cambio(tipo=crear, archivo="parcial.wlk"),
 	 // este de abajo me hace dudar si en realidad deberian ser clases
 	new Cambio(tipo=agregar.texto("este es un parcial"), archivo="readme.md")
 ])
 */ 
 const revertDeCommit = commit.revert()
 
 /**********************************************************************************/
//
// Punto 6,7,8,9,10
//

class Usuario{
	const nombre
	const rol
		
	method crearBranch(){
		new Branch()		
	}
	method tienePermisos(branch)
}

object usuarioComun{
	method tienePermisos() = false
}

object usuarioAdministrador{
	method tienePermisos() = true
}
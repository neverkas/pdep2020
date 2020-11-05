class Curso{
	var materia
	var estudiantes = []
	var tareasPedidas = []
	
	method darTarea(tarea)
	method estanAlDia()	
}

class Tarea{
	var descripcion
	var fechaDeEntrega
	var tiempoEstimado
	
	method proximidadAFechaDeEntrega()
	method vencida()
}

class Estudiante{
	method recibirTarea(tarea){
		
	}
	method completo(tarea){
		
	}	
	method estudiar(){
		
	}
}

object caro inherits Estudiante{
	override method elegirTarea(){
		const tarea = self.tareaMasExtensa()
		self.estudiar(tarea)
	}
}

object leo inherits Estudiante{
	override method elegirTarea(){
		const tarea = self.tareaMasProxima()
		self.estudiar(tarea)
	}
}



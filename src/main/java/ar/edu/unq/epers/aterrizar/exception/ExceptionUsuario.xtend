package ar.edu.unq.epers.aterrizar.exception

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class ExceptionUsuario extends Exception{

	String mensaje
	
	
	new (String mensaje){ 
		this.mensaje = mensaje
	}

	
	def mensajeDeException (String mensaje){
		this.mensaje = mensaje
	}
	
}
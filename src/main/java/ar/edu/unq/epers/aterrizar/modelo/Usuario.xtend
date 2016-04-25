package ar.edu.unq.epers.aterrizar.modelo

import ar.edu.unq.epers.aterrizar.servicios.BuscadorDeVuelo
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.exception.ExceptionUsuario

@Accessors
class Usuario {
	String nombre
	String apellido
	String nombreUsuario
	String email
	String fechaNacimiento
	String contrasenia
	String codValidacion
	int id
	Boolean logeado = false
	BuscadorDeVuelo buscador = new BuscadorDeVuelo
	
	new(){
		
	}
	
	def cambiarContrasenia (String nuevaContrasenia){	
			if(contrasenia != nuevaContrasenia){
				this.contrasenia = nuevaContrasenia
		 	}
		 	else{
			 	throw new ExceptionUsuario("Contraseña invalida ")
			}
}	
	def validarContrasenia(String contrasenia){
		this.contrasenia == contrasenia
	}
}
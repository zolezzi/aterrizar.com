package ar.edu.unq.epers.aterrizar.modelo

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Usuario {
	String nombre
	String apellido
	String nombreUsuario
	String email
	String fechaNacimiento
	String contrasenia
	Boolean logeado
	
	new (String nombre, String apellido, String nombreUsuario, String email, String fechaNacimiento, 
		 String contrasenia, Boolean logeado){
		
		this.nombre = nombre
		this.apellido = apellido
		this.nombreUsuario = nombreUsuario
		this.email = email
		this.fechaNacimiento = fechaNacimiento
		this.contrasenia = contrasenia
		this.logeado = logeado 		
	}
	
	def cambiarContrasenia (String nuevaContrasenia){
		this.contrasenia = nuevaContrasenia
	}
}
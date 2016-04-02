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
	String clave
	Boolean logeado
	

	
	def cambiarContrasenia (String nuevaContrasenia){
		if(contrasenia != nuevaContrasenia){
			this.contrasenia = nuevaContrasenia
		}else{
			throw new Exception
		}
		
	}
	
	def validarContrasenia(String contrasenia){
		this.contrasenia == contrasenia
	}
}
package ar.edu.unq.epers.aterrizar.modelo

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import ar.edu.unq.epers.aterrizar.servicios.CriterioDeBusqueda

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
	List<CriterioDeBusqueda> busquedasDelUsuario
	
	new(){
		
	}
	
	def cambiarContrasenia (String nuevaContrasenia){
		if(contrasenia != nuevaContrasenia){
			this.contrasenia = nuevaContrasenia
		}else{
			throw new Exception("Contraseña invalida ")
		}
		
	}
	
	def validarContrasenia(String contrasenia){
		this.contrasenia == contrasenia
	}
}
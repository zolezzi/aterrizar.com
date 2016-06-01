package ar.edu.unq.epers.aterrizar.modelo

import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.exception.ExceptionUsuario
import java.util.List
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.modelo.modelobusqueda.Busqueda
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Perfil

@Accessors
class Usuario {
	String nombre
	String apellido
	String nombreUsuario
	String email
	String fechaNacimiento
	String contrasenia
	String codValidacion
	Byte validado
	int id
	Boolean logeado = false
	List<Busqueda> historialDeBusquedas = new ArrayList<Busqueda>
	
	new(){
		
	}
	
	
	def guardarBusqueda(Busqueda busqueda){
		historialDeBusquedas.add(busqueda)
	}
	
	def obtenerUltimaBusqueda(){
		if(! historialDeBusquedas.empty){
			historialDeBusquedas.last
		}else{
			throw new ExceptionUsuario("No hay busquedas en el historial ")
		}
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
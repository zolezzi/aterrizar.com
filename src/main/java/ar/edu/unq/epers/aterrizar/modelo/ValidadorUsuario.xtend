package ar.edu.unq.epers.aterrizar.modelo

import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.persistencias.Persistencia
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class ValidadorUsuario {
	
	Persistencia basesDeDatos
	
	def guardarUsuarioAValidar(Usuario usuario, int validado){
		basesDeDatos.insertUser(usuario,validado)
	}
	
	def validarClaveDeUsuario(Usuario usuario, String clave){
		if(usuario != null){
			usuario.clave == clave
		}else{
			false
		}
	}
	
	def esUsuarioValido(Usuario usuario) {
		return usuario.nombre != null && usuario.apellido != null 
			   && usuario.nombreUsuario != null && usuario.contrasenia != null 
			   && usuario.email != null
	}
	
}
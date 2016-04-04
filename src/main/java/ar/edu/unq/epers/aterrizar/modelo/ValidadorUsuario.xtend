package ar.edu.unq.epers.aterrizar.modelo

import ar.edu.unq.epers.aterrizar.modelo.Usuario
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.persistencias.RepositorioUsuarios

@Accessors
class ValidadorUsuario {
	
	RepositorioUsuarios basesDeDatos
	
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
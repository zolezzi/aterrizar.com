package ValidadorUsuario

import Usuarios.Usuario
import java.util.HashMap

class ValidadorUsuario {
	HashMap <String,Usuario> usuariosAValidar
	
	new(){
		usuariosAValidar = new HashMap<String, Usuario>()
	}
	
	def guardarUsuarioAValidar(String clave, Usuario usuario){
		usuariosAValidar.put(clave,usuario);
	}
	
	def validarClaveDeUsuario(String clave){
		usuariosAValidar.containsKey(clave);
	}
	
	/**
	 * Se asume que se esta dando una clave valida.
	 */
	def obtenerUsuarioDeClave(String clave){
		usuariosAValidar.get(clave);
	}
	
	def borrarUsuarioAsociadoALaClave(String clave){
		usuariosAValidar.remove(clave)
	}
}
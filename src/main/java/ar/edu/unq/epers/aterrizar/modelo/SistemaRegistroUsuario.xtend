package ar.edu.unq.epers.aterrizar.modelo

import java.util.HashMap
import ar.edu.unq.epers.aterrizar.persistencias.Persistencia

class SistemaRegistroUsuario {
	//C = nombreUsuario, V = Usuario	
	HashMap <String,Usuario> usuarios
	EnviadorEmails enviadorEmails
	ValidadorUsuario validadorUsuario
	Persistencia basesDeDatos
	int codigo = 0
	
	def generarCod(Usuario usuario){
		codigo ++
		return "cod"+codigo.toString
	}

	def logear(String nombreUsuario, String contrasenia){
		
		var Usuario usuario
		//Busca un usuario localmente, si no lo tiene, lo busca en la bases de datos.
		if(usuarios.containsKey(nombreUsuario)){
			usuario = usuarios.get(nombreUsuario)
		}else{
			usuario = basesDeDatos.selectUser(nombreUsuario)
			if(usuario != null){
				guardarUsuario(usuario)
			}
		}
		
		if(usuario != null && usuario.validarContrasenia(contrasenia)){
			usuario.logeado = true		
		}else{
			throw new Exception
		}		
	}
	
	def crearUsuario(String pNombre, String apellidoDeUsuario, String nombreDeUsuario, String emailDeUsuario, String fechaDeNacimiento, String contraseniaDeUsuario){
		var usuario = new Usuario =>[
				 	  nombre = pNombre
					  apellido = apellidoDeUsuario
					  nombreUsuario = nombreDeUsuario
					  email = emailDeUsuario
					  fechaNacimiento = fechaDeNacimiento
					  contrasenia = contraseniaDeUsuario
					  logeado = false 
	]
		if(validadorUsuario.esUsuarioValido(usuario)){
			var cod = this.generarCod(usuario)
			validadorUsuario.guardarUsuarioAValidar(cod,usuario)
			basesDeDatos.insertUser(usuario,0)
			this.enviarCodigo(cod, usuario)
		}
		else {
			 throw new Exception  
		}	
	}
	
	def validarClaveDeUsuario(String clave){
		
		if(validadorUsuario.validarClaveDeUsuario(clave)){
			var usuario = validadorUsuario.obtenerUsuarioDeClave(clave)
			this.guardarUsuario(usuario)
			basesDeDatos.updateUser(usuario)
			validadorUsuario.borrarUsuarioAsociadoALaClave(clave)
		}else{
			throw new Exception
		}
	}
	
	def guardarUsuario(Usuario usuario){
		usuarios.put(usuario.nombreUsuario,usuario)
	}
	
	def enviarCodigo (String cod,Usuario usuario){
		enviadorEmails.enviarCodigoUsuario(cod, usuario)
	}
	
}
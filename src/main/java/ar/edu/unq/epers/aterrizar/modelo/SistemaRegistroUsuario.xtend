package ar.edu.unq.epers.aterrizar.modelo

import java.util.HashMap

class SistemaRegistroUsuario {
	//C = nombreUsuario, V = Usuario
	EnviadorEmails enviadorEmails
	HashMap <String,Usuario> usuarios
	ValidadorUsuario validadorUsuario
	int codigo = 0
	
	def generarCod(Usuario usuario){
		codigo ++
		return "cod"+codigo.toString
	}
	
	def logear(Usuario usuario){
		usuario.logeado = true
		
	}
	
	def crearUsuario(String nombre, String apellido, String nombreDeUsuario, String email, String fechaDeNacimiento, String contrasenia){
		var usuario = new Usuario(nombre,apellido,nombreDeUsuario,email,fechaDeNacimiento,contrasenia,false)
		if(validadorUsuario.esUsuarioValido(usuario)){
			this.guardarUsuario(usuario.nombreUsuario,usuario)
			var cod = this.generarCod(usuario)
			this.enviarCodigo(cod, usuario)
		}
		else {
			 throw new Exception  
		}	
	}
	
	def guardarUsuario(String nombreUsuario, Usuario usuario){
		usuarios.put(usuario.nombreUsuario,usuario)
	}
	def enviarCodigo (String cod,Usuario usuario){
		enviadorEmails.enviarCodigoUsuario(cod, usuario)
	}
	
}
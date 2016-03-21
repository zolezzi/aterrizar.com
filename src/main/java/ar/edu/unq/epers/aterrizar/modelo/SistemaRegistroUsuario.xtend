package ar.edu.unq.epers.aterrizar.modelo

import java.util.HashMap

class SistemaRegistroUsuario {
	//C = nombreUsuario, V = Usuario
	HashMap <String,Usuario> usuarios
	int codigo = 0
	
	def generarCod(Usuario usuario){
		codigo ++
		return "cod"+codigo.toString
	}
	
	def logear(Usuario usuario){
		
	}
	
	def crearUsuario(String nombre, String apellido, String nombreDeUsuario, String email, String fechaDeNacimiento, String contrasenia){
		new Usuario(nombre,apellido,nombreDeUsuario,email,fechaDeNacimiento,contrasenia,false)
	}
}
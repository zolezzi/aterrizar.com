package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.persistencia.home.SessionManager
import ar.edu.unq.epers.aterrizar.persistencia.home.UsuarioHome
import ar.edu.unq.epers.aterrizar.modelo.Usuario

class SistemaRegistroUsuarioService {
	UsuarioHome userHome= new UsuarioHome()
	
	def consultarUsuario(int id) {
		SessionManager.runInSession([
			userHome.get(id)
		])
	}
	
	def consultarUsuarioPor(String campo, String valor){
		SessionManager.runInSession([
			userHome.getBy(campo,valor)
		])
	}

	def crearUsuario(String nombre, String apellido, String nombreUsuario, String email, String fechaNacimiento, String contrasenia, String clave) {
		SessionManager.runInSession([
			var usuario = new Usuario => [
				it.nombre = nombre
				it.apellido = apellido
				it.nombreUsuario = nombreUsuario
				it.email = email
				it.fechaNacimiento = fechaNacimiento
				it.contrasenia = contrasenia
				it.codValidacion = clave
			]
			userHome.save(usuario)
			usuario
		]);
	}
	
	def eliminarUsuario(int id){
		SessionManager.runInSession([
			var usuario = userHome.get(id)
			userHome.delete(usuario)
			null
		])
	}

	def cambiarContrasenia(int id, String nombre) {
		SessionManager.runInSession([
			var usuario = userHome.get(id)
			usuario.nombre = nombre
			usuario
		]);
	}
	
	def cambiarContraseniaDe(String nombreUsuario, String pContrasenia){
		SessionManager.runInSession([
			var usuario = userHome.getBy("nombreUsuario", nombreUsuario)
			usuario.contrasenia = pContrasenia
			null
		])
	}
	
	def eliminarUsuarioPor(String campo, String nombreUsuario ){
		SessionManager.runInSession([
			var usuario = userHome.getBy("nombreUsuario", nombreUsuario)
			userHome.delete(usuario)
			null
		])
	}
}

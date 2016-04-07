package ar.edu.unq.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.persistencia.home.SessionManager
import ar.edu.unq.epers.aterrizar.persistencia.home.UsuarioHome
import ar.edu.unq.epers.aterrizar.modelo.Usuario

class SistemaRegistroUsuarioService {
		
		def consultarUsuario(int id) {
		SessionManager.runInSession([
			new UsuarioHome().get(id)
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
				it.clave = clave
			]
			new UsuarioHome().save(usuario)
			usuario
		]);
	}

	def cambiarContrasenia(int id, String nombre) {
		SessionManager.runInSession([
			var jugador = new UsuarioHome().get(id)
			jugador.nombre = nombre
			jugador
		]);
	}
	
}
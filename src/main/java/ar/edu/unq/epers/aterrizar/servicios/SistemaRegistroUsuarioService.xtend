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

	def crearUsuario(String nombre, String apellido, String nombreUsuario, String email, String fechaNacimiento, String contrasenia,int id, String clave) {
		SessionManager.runInSession([
			var usuario = new Usuario => [
				it.nombre = nombre
				it.apellido = apellido
				it.nombreUsuario = nombreUsuario
				it.email = email
				it.fechaNacimiento = fechaNacimiento
				it.contrasenia = contrasenia
				it.id = id
				it.codValidacion = clave
			]
			//consultar, actualmente guarda infinitos usuarios por mas que sean iguales.
			userHome.save(usuario)
			usuario
		]);
	}

	def cambiarContrasenia(int id, String nombre) {
		SessionManager.runInSession([
			var jugador = userHome.get(id)
			jugador.nombre = nombre
			jugador
		]);
	}
	
}

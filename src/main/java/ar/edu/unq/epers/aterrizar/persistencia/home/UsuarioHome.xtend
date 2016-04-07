package ar.edu.unq.epers.aterrizar.persistencia.home

import ar.edu.unq.epers.aterrizar.modelo.Usuario

class UsuarioHome {
		def get(int id){
		return SessionManager.getSession().get(typeof(Usuario) ,id) as Usuario
	}

	def save(Usuario u) {
		SessionManager.getSession().saveOrUpdate(u)
	}
}
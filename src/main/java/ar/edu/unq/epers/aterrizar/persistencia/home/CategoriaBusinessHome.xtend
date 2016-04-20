package ar.edu.unq.epers.aterrizar.persistencia.home

import ar.edu.unq.epers.aterrizar.modelo.CategoriaBusiness

class CategoriaBusinessHome {
	
	def get(int id){
		return SessionManager.getSession().get(typeof(CategoriaBusiness) ,id) as CategoriaBusiness
	}

	def save(CategoriaBusiness a) {
		SessionManager.getSession().saveOrUpdate(a)
	}
	
	def delete(CategoriaBusiness a){
		SessionManager.getSession().delete(a)
	}
}
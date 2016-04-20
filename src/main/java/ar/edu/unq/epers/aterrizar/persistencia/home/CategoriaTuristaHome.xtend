package ar.edu.unq.epers.aterrizar.persistencia.home

import ar.edu.unq.epers.aterrizar.modelo.CategoriaTurista

class CategoriaTuristaHome {
	
	def get(int id){
		return SessionManager.getSession().get(typeof(CategoriaTurista) ,id) as CategoriaTurista
	}

	def save(CategoriaTurista a) {
		SessionManager.getSession().saveOrUpdate(a)
	}
	
	def delete(CategoriaTurista a){
		SessionManager.getSession().delete(a)
	}
}
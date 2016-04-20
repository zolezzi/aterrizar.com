package ar.edu.unq.epers.aterrizar.persistencia.home

import ar.edu.unq.epers.aterrizar.modelo.CategoriaPrimera

class CategoriaPrimeraHome {
	
	def get(int id){
		return SessionManager.getSession().get(typeof(CategoriaPrimera) ,id) as CategoriaPrimera
	}

	def save(CategoriaPrimera a) {
		SessionManager.getSession().saveOrUpdate(a)
	}
	
	def delete(CategoriaPrimera a){
		SessionManager.getSession().delete(a)
	}
}
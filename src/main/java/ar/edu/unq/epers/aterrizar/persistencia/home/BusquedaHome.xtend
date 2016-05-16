package ar.edu.unq.epers.aterrizar.persistencia.home

import ar.edu.unq.epers.aterrizar.modelo.modelobusqueda.Busqueda

class BusquedaHome {
	
	
	def get(int id){
		return SessionManager.getSession().get(typeof(Busqueda) ,id) as Busqueda
	}

	def save(Busqueda b) {
		SessionManager.getSession().saveOrUpdate(b)		
	}
	
	def delete(Busqueda b){
		SessionManager.getSession().delete(b)
	}
	
	
}
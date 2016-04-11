package ar.edu.unq.epers.aterrizar.persistencia.home

import ar.edu.unq.epers.aterrizar.modelo.Aerolinea
import org.hibernate.criterion.Restrictions

class AerolineaHome {
	
	def get(int id){
		return SessionManager.getSession().get(typeof(Aerolinea) ,id) as Aerolinea
	}

	def save(Aerolinea a) {
		SessionManager.getSession().saveOrUpdate(a)
	}
	
	def delete(Aerolinea a){
		SessionManager.getSession().delete(a)
	}
	
	def getBy(String campo, String valor){
		var criteria = SessionManager.getSession().createCriteria(Aerolinea);
		var aerolinea = criteria.add(Restrictions.eq(campo, valor)).uniqueResult()
		aerolinea as Aerolinea
	}
}
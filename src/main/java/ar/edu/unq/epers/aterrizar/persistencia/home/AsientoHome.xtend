package ar.edu.unq.epers.aterrizar.persistencia.home

import ar.edu.unq.epers.aterrizar.modelo.Asiento
import org.hibernate.criterion.Restrictions

class AsientoHome {

	
	def get(int id){
		return SessionManager.getSession().get(typeof(Asiento) ,id) as Asiento
	}

	def save(Asiento a) {
		SessionManager.getSession().saveOrUpdate(a)
	}
	
	def delete(Asiento a){
		SessionManager.getSession().delete(a)
	}
	
	def getBy(String campo, String valor){
		var criteria = SessionManager.getSession().createCriteria(Asiento);
		var asiento = criteria.add(Restrictions.eq(campo, valor)).uniqueResult()
		asiento as Asiento
	}

	
}
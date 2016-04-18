package ar.edu.unq.epers.aterrizar.persistencia.home

import ar.edu.unq.epers.aterrizar.modelo.Tramo
import org.hibernate.criterion.Restrictions

class TramoHome {
	
	def get(int id){
		return SessionManager.getSession().get(typeof(Tramo) ,id) as Tramo
	}

	def save(Tramo t) {
		SessionManager.getSession().saveOrUpdate(t)
	}
	
	def delete(Tramo t){
		SessionManager.getSession().delete(t)
	}
	
	def getBy(String campo, String valor){
		var criteria = SessionManager.getSession().createCriteria(Tramo);
		var tramo = criteria.add(Restrictions.eq(campo, valor)).uniqueResult()
		tramo as Tramo
	}
	
	def getBy(String campo, String valor, String campoII, String valorII){
		var criteria = SessionManager.getSession().createCriteria(Tramo);
		var tramo = criteria.add(Restrictions.eq(campo, valor))
							.add(Restrictions.eq(campoII, valorII))
							.uniqueResult()
		tramo as Tramo
	}
	
}

package ar.edu.unq.epers.aterrizar.persistencia.home

import org.hibernate.criterion.Restrictions
import ar.edu.unq.epers.aterrizar.modelo.Vuelo

class VueloHome {
	
	def get(int id){
		return SessionManager.getSession().get(typeof(Vuelo) ,id) as Vuelo
	}

	def save(Vuelo v) {
		SessionManager.getSession().saveOrUpdate(v)
	}
	
	def delete(Vuelo v){
		SessionManager.getSession().delete(v)
	}
	
	def getBy(String campo, String valor){
		var criteria = SessionManager.getSession().createCriteria(Vuelo);
		var vuelo = criteria.add(Restrictions.eq(campo, valor)).uniqueResult()
		vuelo as Vuelo
	}
}
package ar.edu.unq.epers.aterrizar.persistencia.home

import ar.edu.unq.epers.aterrizar.modelo.Asiento
import org.hibernate.criterion.Restrictions
import java.util.List

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
	
	def getBy(String campo, boolean valor){
		var criteria = SessionManager.getSession().createCriteria(Asiento);
		var asiento = criteria.add(Restrictions.eq(campo, valor)).list()
		asiento
	}
	
	def getFreeSeatsOfSection(String campo, String valor, String campoII, String valorII){
		var criteria = SessionManager.getSession().createCriteria(Asiento);
		var Asientos = criteria.add(Restrictions.eq(campo, valor))
							.add(Restrictions.eq(campoII, valorII))
							.add(Restrictions.eq("reservado",false)							)
							.list()
		Asientos 
	}
	
	def getRange(Integer cantidadDeAsientos) {
		var criteria = SessionManager.getSession().createCriteria(Asiento);
		var List<Asiento> asientos = criteria.add(Restrictions.eq("reservado", false)).setMaxResults(cantidadDeAsientos).list()
		asientos	
	}

	
}
package ar.edu.unq.epers.aterrizar.persistencia.home

import ar.edu.unq.epers.aterrizar.modelo.Usuario
import org.hibernate.HibernateException
import org.hibernate.Criteria
import org.hibernate.criterion.Restrictions

class UsuarioHome {
	def get(int id){
		return SessionManager.getSession().get(typeof(Usuario) ,id) as Usuario
	}

	def save(Usuario u) {
		SessionManager.getSession().saveOrUpdate(u)		
	}
	
	def delete(Usuario u){
		SessionManager.getSession().delete(u)
	}
	
	def getBy(String campo, String valor){
		var criteria = SessionManager.getSession().createCriteria(Usuario);
		var usuario = criteria.add(Restrictions.eq(campo, valor)).uniqueResult()
		usuario as Usuario
	}
	
	
	
}
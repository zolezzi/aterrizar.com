package ar.edu.unq.epers.aterrizar.persistencia.home

import ar.edu.unq.epers.aterrizar.modelo.Categoria
import org.hibernate.criterion.Restrictions

class CategoriaHome {
	
	def get(Integer id){
		return SessionManager.getSession().get(typeof(Categoria) ,id) as Categoria
	}

	def save(Categoria c) {
		SessionManager.getSession().saveOrUpdate(c)
	}
	
	def delete(Categoria c){
		SessionManager.getSession().delete(c)
	}
	
	def getBy(String campo, String valor){
		var criteria = SessionManager.getSession().createCriteria(Categoria);
		var categoria = criteria.add(Restrictions.eq(campo, valor)).uniqueResult()
		categoria as Categoria
	}
}
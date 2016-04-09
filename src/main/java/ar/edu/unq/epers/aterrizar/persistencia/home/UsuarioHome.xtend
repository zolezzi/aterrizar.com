package ar.edu.unq.epers.aterrizar.persistencia.home

import ar.edu.unq.epers.aterrizar.modelo.Usuario
import org.hibernate.HibernateException

class UsuarioHome {
	def get(int id){
		return SessionManager.getSession().get(typeof(Usuario) ,id) as Usuario
	}

	def save(Usuario u) {
		SessionManager.getSession().save(u)
	}
	
	//consultar
	def saveOrUpdate(Usuario u){
		try{
		SessionManager.getSession().saveOrUpdate(u)
		}catch(HibernateException e){
			SessionManager.getSession().save(u)
		}
	}
}
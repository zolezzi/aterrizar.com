package ar.edu.unq.epers.aterrizar.persistencia.home

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class BusquedaHome {
	
	def Search(String search){
		SessionManager.runInSession([
			SessionManager.getSession().createQuery(search).list()
		])
	}
}
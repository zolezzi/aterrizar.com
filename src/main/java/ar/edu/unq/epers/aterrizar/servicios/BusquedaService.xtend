package ar.edu.unq.epers.aterrizar.servicios

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import ar.edu.unq.epers.aterrizar.persistencia.home.BusquedaHome
import ar.edu.unq.epers.aterrizar.modelo.modelobusqueda.Busqueda
import ar.edu.unq.epers.aterrizar.modelo.modelocriterios.Criterios
import ar.edu.unq.epers.aterrizar.persistencia.home.SessionManager

@Accessors
class BusquedaService {
	
	var BusquedaHome busquedaHome = new BusquedaHome()
	
	def EjecutarBusqueda(Busqueda busqueda){
		var List<Criterios> criterios = busqueda.criterios
		var String query = "select distinct vuelos from Aerolinea as aerolinea 
							join aerolinea.vuelos as vuelos 
							left join vuelos.tramos as tramos 
							left join tramos.asientos as asientos 
							left join asientos.categoria as categoria"
							
		if(! criterios.empty){
		query = query + " where "
			for (Criterios c : criterios){
				query = query + " " + c.darQuery()
			}
		}
		
		if(busqueda.orden != null){
			query = query + " " + busqueda.orden.darOrden()
		}
		println(query)
		this.Search(query)
	}
	
	def Search(String search){
		SessionManager.runInSession([
			SessionManager.getSession().createQuery(search).list()
		])
	}
}
package ar.edu.unq.epers.aterrizar.servicios

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import ar.edu.unq.epers.aterrizar.modelo.Criterios
import ar.edu.unq.epers.aterrizar.modelo.Busqueda
import ar.edu.unq.epers.aterrizar.persistencia.home.BusquedaHome

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
		busquedaHome.Search(query)
	}
}
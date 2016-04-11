package ar.edu.unq.epers.aterrizar.servicios

import java.util.List
import ar.edu.unq.epers.aterrizar.modelo.Vuelo

class BusquedaMultiple implements CriterioDeBusqueda{
	
	List<BusquedaSimple> criterios
	
	def BusquedaMultiple (List<BusquedaSimple> criterios){
		
		this.criterios = criterios
	}
	
	override filtrarVuelo(List<Vuelo> vuelos) {
			
		var List<Vuelo> lista
		for(BusquedaSimple criterio: criterios){
			lista = criterio.filtrarVuelo(vuelos);
		}
		return lista;
	}
	
}

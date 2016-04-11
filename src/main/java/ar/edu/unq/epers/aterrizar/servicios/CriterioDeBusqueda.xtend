package ar.edu.unq.epers.aterrizar.servicios

import java.util.List
import ar.edu.unq.epers.aterrizar.modelo.Vuelo

interface CriterioDeBusqueda {
	
	
	 abstract def List<Vuelo> filtrarVuelo(List<Vuelo> vuelos)
}

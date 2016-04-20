package ar.edu.unq.epers.aterrizar.servicios

import java.util.List
import java.util.ArrayList

class BuscadorDeVuelo {

	List<String> criteriosDeBusqueda = new ArrayList<String>
	
	def guardarBusqueda(Busqueda busqueda){
		criteriosDeBusqueda.add(busqueda.queryFinal)
	}
}
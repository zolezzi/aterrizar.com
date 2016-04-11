package ar.edu.unq.epers.aterrizar.modelo

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.servicios.SistemaRegistroAerolineas
import java.util.ArrayList

@Accessors
class Aerolinea {
	
	Integer id
	String nombreAerolinea
	List<Vuelo> vuelos = new ArrayList<Vuelo>()
	
	new(){}
	
	def registrarUnVuelo(Vuelo vuelo){
		vuelos.add(vuelo)
	}

	
	
}
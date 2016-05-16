package ar.edu.unq.epers.aterrizar.modelo.modelobusqueda

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.modelo.modelocriterios.Criterios
import ar.edu.unq.epers.aterrizar.modelo.modeloorden.Orden

@Accessors
class Busqueda {
	
	int id
	List<Criterios> criterios = new ArrayList<Criterios>()
	Orden orden
	
	def agregarCriterioBusqueda(Criterios criterio){
		criterios.add(criterio)
	}
}
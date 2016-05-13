package ar.edu.unq.epers.aterrizar.modelo

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList

@Accessors
class Busqueda {
	int id
	List<Criterios> criterios = new ArrayList<Criterios>()
	Orden orden
	
	def agregarCriterioBusqueda(Criterios criterio){
		criterios.add(criterio)
	}
}
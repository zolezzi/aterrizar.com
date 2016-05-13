package ar.edu.unq.epers.aterrizar.modelo

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CriterioAND extends CriteriosCompuestos{
	
	new(Criterios izquierda, Criterios derecha) {
		super(izquierda, derecha)
	}
	
	def override darQuery(){
		izq.darQuery() + " and " + der.darQuery()
	}
	
}
	
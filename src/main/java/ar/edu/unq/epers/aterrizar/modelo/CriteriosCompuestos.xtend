package ar.edu.unq.epers.aterrizar.modelo

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class CriteriosCompuestos extends Criterios{
	
	var Criterios izq
	var Criterios der
	
	new (Criterios izquierda, Criterios derecha){
		izq = izquierda
		der = derecha
	}
	
}
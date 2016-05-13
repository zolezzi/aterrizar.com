package ar.edu.unq.epers.aterrizar.modelo

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Orden {
	int id
	String queryOrden
	
	new(){}
	
	def darOrden(){
		queryOrden
	}
}
package ar.edu.unq.epers.aterrizar.modelo.modelocriterios

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class Criterios {
	int id
	def String darQuery(){}
	
}
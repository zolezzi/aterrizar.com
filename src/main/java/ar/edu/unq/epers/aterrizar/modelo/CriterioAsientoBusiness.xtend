package ar.edu.unq.epers.aterrizar.modelo

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CriterioAsientoBusiness extends Criterios{
	def override darQuery(){
		"categoria.tipo = 'Business'"
	}
}
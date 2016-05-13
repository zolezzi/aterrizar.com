package ar.edu.unq.epers.aterrizar.modelo


import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CriterioAsientoTurista extends Criterios{

	def override darQuery(){
		"categoria.tipo = 'Turista'"
	}
	
}
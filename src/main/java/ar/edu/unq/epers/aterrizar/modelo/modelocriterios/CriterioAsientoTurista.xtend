package ar.edu.unq.epers.aterrizar.modelo.modelocriterios

import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.modelo.modelocriterios.Criterios

@Accessors
class CriterioAsientoTurista extends Criterios{

	def override darQuery(){
		"categoria.tipo = 'Turista'"
	}
	
}
package ar.edu.unq.epers.aterrizar.modelo.modelocriterios
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.modelo.modelocriterios.Criterios

@Accessors
class CriterioOrigen extends Criterios{
	String nombreOrigen
	
	new(String origen){
		nombreOrigen = origen
	}
	
	def override darQuery(){
		"vuelos.origen = '" + nombreOrigen + "'"
	}
}
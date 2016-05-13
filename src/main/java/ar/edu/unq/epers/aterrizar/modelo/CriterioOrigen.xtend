package ar.edu.unq.epers.aterrizar.modelo
import org.eclipse.xtend.lib.annotations.Accessors

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
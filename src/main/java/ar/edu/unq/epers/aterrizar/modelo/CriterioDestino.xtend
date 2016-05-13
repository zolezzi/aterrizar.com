package ar.edu.unq.epers.aterrizar.modelo
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CriterioDestino extends Criterios{
	String nombreDestino
	
	new(String destino){
		nombreDestino = destino
	}
	
	def override darQuery(){
		"vuelos.destino = '" + nombreDestino + "'"
	}
}
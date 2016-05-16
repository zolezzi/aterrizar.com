package ar.edu.unq.epers.aterrizar.modelo.modelocriterios
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.modelo.modelocriterios.Criterios

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
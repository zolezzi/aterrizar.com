package ar.edu.unq.epers.aterrizar.modelo.modelocriterios
import java.util.Date
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.modelo.modelocriterios.Criterios

@Accessors
class CriterioFechaSalida extends Criterios{
	Date fecha
	
	new (Date fecha){
		this.fecha = fecha
	}
	
	def override darQuery(){
		"vuelos.fechaSalida = '" + fecha + "'"
	}
	
}
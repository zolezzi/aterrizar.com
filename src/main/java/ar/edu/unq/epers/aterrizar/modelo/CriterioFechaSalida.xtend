package ar.edu.unq.epers.aterrizar.modelo

import java.util.Date
import org.eclipse.xtend.lib.annotations.Accessors

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
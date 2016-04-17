package ar.edu.unq.epers.aterrizar.modelo

import java.util.List
import java.util.Timer
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Tramo {
	
	List<Asiento> asientos
	String origen
	String destino
	Timer hora_llegada
	Timer hora_salida
	double precio_base
	Integer id
	
	new (){}
	
	def agregarAsiento(Asiento asiento){
		asientos.add(asiento)
	}
}
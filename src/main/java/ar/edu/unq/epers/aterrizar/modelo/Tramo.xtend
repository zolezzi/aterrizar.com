package ar.edu.unq.epers.aterrizar.modelo

import java.util.List
import java.util.Timer
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Tramo {
	
	List<Asiento> asientos
	String origen
	String destino
	String hora_llegada
	String hora_salida
	double precio_base
	Integer id
	
	new (){}
	
	def agregarAsiento(Asiento asiento){
		asientos.add(asiento)
	}
}
package ar.edu.unq.epers.aterrizar.modelo

import java.util.List
import java.util.Date
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Timer

@Accessors
class Vuelo {
	
	List<Tramo> tramos
	String origen
	String destino
	Date fechaSalida
	Date fechaLlegada
	Timer duracion
	Integer precio
	Integer id
	
	new(){}
	
}
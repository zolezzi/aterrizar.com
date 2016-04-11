package ar.edu.unq.epers.aterrizar.modelo

import java.util.List
import java.util.Date
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Vuelo {
	
	List<Tramo> tramos
	String origen
	String destino
	Date fechaSalida
	Date fechaLlegada
	Integer duracion // o podria ser un timer
	Integer Precio
	
	
}
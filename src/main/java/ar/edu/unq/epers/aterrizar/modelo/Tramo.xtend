package ar.edu.unq.epers.aterrizar.modelo

import java.util.List
import java.util.Timer

class Tramo {
	
	List<Asiento> asientos
	String origen
	String destino
	Timer horaLlegada
	Timer horaSalida
	double precioBase
	Integer id
}
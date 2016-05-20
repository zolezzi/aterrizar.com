package ar.edu.unq.epers.aterrizar.modelo

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Date

@Accessors
class Asiento {
	

	Tramo  tramo
	Categoria categoria
	Usuario usuario
	Integer id
	String numeroAsiento
	String origen
	String destino
	Date fechaSalida
	Date fechaLlegada
	Integer precio 
	Boolean reservado = false
	
	new (){}
}
package ar.edu.unq.epers.aterrizar.modelo
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class OrdenDuracion extends Orden{
	
	new(){
		this.queryOrden= "order by vuelos.duracion asc"
	}
	
}
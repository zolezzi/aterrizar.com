package ar.edu.unq.epers.aterrizar.modelo

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class Categoria {
	
	int factor_de_precio
	Integer id
	String tipo
	
	def double calcularPrecio(int precioDeUnTramo){
		precioDeUnTramo+(precioDeUnTramo*(factor_de_precio/100))
	}
}
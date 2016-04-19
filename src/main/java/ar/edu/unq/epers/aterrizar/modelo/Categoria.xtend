package ar.edu.unq.epers.aterrizar.modelo

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class Categoria {
	
	int factorDePrecio
	Integer id
	String tipo
	
	def double calcularPrecio(int precioDeUnTramo){
		precioDeUnTramo+(precioDeUnTramo*(factorDePrecio/100))
	}
}
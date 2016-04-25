package ar.edu.unq.epers.aterrizar.modelo

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class Categoria {
	
	int factor_de_precio
	Integer id
	String tipo
	
	new(String tipo, int factorDePrecio) {
		
		this.tipo = tipo
		this.factor_de_precio = factorDePrecio
	}
	
	def double calcularPrecio(int precioDeUnTramo){
		precioDeUnTramo+(precioDeUnTramo*(factor_de_precio/100))
	}
}
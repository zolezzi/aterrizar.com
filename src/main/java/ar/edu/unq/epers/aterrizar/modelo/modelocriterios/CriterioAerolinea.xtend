package ar.edu.unq.epers.aterrizar.modelo.modelocriterios

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CriterioAerolinea extends Criterios{
	
	String nombreAerolinea
	
	new(String nombre){
		this.nombreAerolinea = nombre
	}
	
	def override darQuery(){
		"aerolinea.nombreAerolinea = '" + nombreAerolinea + "'"
	}
}
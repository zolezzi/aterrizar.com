package ar.edu.unq.epers.aterrizar.modelo.modelocriterios

class CriterioAsientoUsuario extends Criterios{
	String nombreUsuario
	
	new(String nombreUsuario){
		this.nombreUsuario = nombreUsuario
	}
	
	def override darQuery(){
		"asientos.usuario.nombreUsuario = '" + nombreUsuario + "'"
	}
}
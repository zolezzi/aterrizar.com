package ar.edu.unq.epers.aterrizar.modelo.Comentarios

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Visibilidad {
	
	Boolean publico = true
	Boolean soloAmigos = false
	Boolean privado = false
	
	// idea general, si tienen una mejor adelante.
	def hacerPublico(){
		    publico = true
			soloAmigos = false
			privado = false		
	}
	
	def hacerPrivado(){
		    publico = false
			soloAmigos = false
			privado = true		
	}
	
	def hacerSoloAmigos(){
		    publico = false
			soloAmigos = false
			privado = true		
	}
	
	def esPublico(){
		this.publico
	}
	
	def esPrivado(){
		this.privado
	}
	
	def esSoloAmigos(){
		this.soloAmigos
	}
}
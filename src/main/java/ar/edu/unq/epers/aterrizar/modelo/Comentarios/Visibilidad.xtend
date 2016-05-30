package ar.edu.unq.epers.aterrizar.modelo.Comentarios

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Visibilidad {
	
	Boolean publico = true
	Boolean soloAmigos = false
	Boolean privado = false
	
	def hacerPublico(){
		    this.publico = true
			this.soloAmigos = false
			this.privado = false		
	}
	
	def hacerPrivado(){
		    this.publico = false
			this.soloAmigos = false
			this.privado = true		
	}
	
	def hacerSoloAmigos(){
		    this.publico = false
			this.soloAmigos = true
			this.privado = false		
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
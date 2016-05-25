package ar.edu.unq.epers.aterrizar.modelo.Comentarios

import ar.edu.unq.epers.aterrizar.modelo.Usuario
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonProperty
import org.mongojack.ObjectId

@Accessors
class Destino extends Visibilidad {
	
	
	@ObjectId
	@JsonProperty("_id")
	String id
	var ArrayList<Usuario> meGusta = new ArrayList<Usuario>
	var ArrayList<Usuario> noMeGusta = new ArrayList<Usuario>
	var ArrayList<Comentario> comentarios = new ArrayList<Comentario>
	
	def cantMeGusta(){
		meGusta.size
	}
	
	def cantNoMeGusta(){
		noMeGusta.size
	}
	
	def meGusta(Usuario usuario){
		if(! meGusta.contains(usuario))
			meGusta.add(usuario)
	}
	
	def noMeGusta(Usuario usuario){
		if(! noMeGusta.contains(usuario))
			noMeGusta.add(usuario)
	}
}
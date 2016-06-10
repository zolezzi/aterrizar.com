package ar.edu.unq.epers.aterrizar.modelo.Comentarios

import ar.edu.unq.epers.aterrizar.modelo.Usuario
import java.util.ArrayList
import com.fasterxml.jackson.annotation.JsonProperty
import org.mongojack.ObjectId
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Comentario extends Visibilidad{
	@ObjectId
	@JsonProperty("_id")
	String id
	var String usuarioDelComentario
	var ArrayList<Usuario> meGusta = new ArrayList<Usuario>
	var ArrayList<Usuario> noMeGusta = new ArrayList<Usuario>
	String textoComentario
	
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
package ar.edu.unq.epers.aterrizar.modelo.Comentarios

import ar.edu.unq.epers.aterrizar.modelo.Usuario
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors
import org.mongojack.ObjectId
import com.fasterxml.jackson.annotation.JsonProperty

@Accessors
class Destino extends Visibilidad {
	@ObjectId
	@JsonProperty("_id")
	String id
	String TituloDestino
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
		if(noMeGusta.contains(usuario)){
			noMeGusta.remove(usuario)
			if(! meGusta.contains(usuario)){
				meGusta.add(usuario)
			}
		}else{
			if(! meGusta.contains(usuario)){
				meGusta.add(usuario)
			}
		}
	}
	
	def noMeGusta(Usuario usuario){
		if(meGusta.contains(usuario)){
			meGusta.remove(usuario)
			if(! noMeGusta.contains(usuario)){
				noMeGusta.add(usuario)
			}
		}else{
			if(! noMeGusta.contains(usuario)){
				noMeGusta.add(usuario)
			}
		}
		
	}
}
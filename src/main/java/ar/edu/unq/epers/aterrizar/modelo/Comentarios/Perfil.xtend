package ar.edu.unq.epers.aterrizar.modelo.Comentarios

import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors
import org.mongojack.ObjectId
import com.fasterxml.jackson.annotation.JsonProperty
import ar.edu.unq.epers.aterrizar.modelo.Usuario

@Accessors
class Perfil {
	@ObjectId
	@JsonProperty("_id")
	String id
	String usuarioPerfil
	String titulo
	ArrayList<Destino> destinos = new ArrayList<Destino>
	
	def obtenerDestino(Destino destino){
		for (dest : destinos){
			if(dest.id == destino.id ){
				return dest
			}
		}
		return null
	}
	
	def agregarComentarioADestino(Comentario coment, Destino destino){
		var resdestino = obtenerDestino(destino)
		if(resdestino != null){
			resdestino.comentarios.add(coment)
		}
	}
	
	def darMeGusta(Destino destino, String usuario){
		var res = obtenerDestino(destino)
		res.meGusta(usuario)
	}
	
	def darNoMeGusta(Destino destino, String usuario){
		var res = obtenerDestino(destino)		
		res.noMeGusta(usuario)	
	}
	
	def agregarDestino(Destino destino) {
		destinos.add(destino)
	}
	
	def insertDestinos(ArrayList<Destino> modificados){
		var int i = 0
		for(Destino d:modificados){
			if(this.destinos.get(i).id == d.id){
				this.destinos.remove(i)
				this.destinos.add(d)
			}else{
				this.destinos.add(d)
			}
			i++
		}
	}
}
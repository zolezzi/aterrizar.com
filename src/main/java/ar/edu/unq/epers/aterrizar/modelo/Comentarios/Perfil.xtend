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
	Usuario usuarioPerfil
	String Titulo
	ArrayList<Destino> destinos = new ArrayList<Destino>
	
}
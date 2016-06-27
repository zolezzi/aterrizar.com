package ar.edu.unq.epers.aterrizar.persistencia.cassandra

import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Destino
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Perfil
import com.datastax.driver.mapping.annotations.Column
import com.datastax.driver.mapping.annotations.FrozenValue
import com.datastax.driver.mapping.annotations.PartitionKey
import com.datastax.driver.mapping.annotations.Table
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import java.util.List

@EqualsHashCode
@Table(keyspace = "simplex", name = "perfiles")
@Accessors
class PerfilMapper {
	
	@PartitionKey
	String nombreUsuario
	@Column(name = "titulo")
	String titulo
	@FrozenValue
	List<Destino> destinosDelPerfil = new ArrayList<Destino>

	new(){
		
	}
	
	new(String nombreUsuario, String titulo, List<Destino> destinos){

		this.nombreUsuario = nombreUsuario
		this.titulo = titulo
		this.destinosDelPerfil = destinos
	}
	
	def toPerfil() {
		new Perfil => [
			it.usuarioPerfil = nombreUsuario
			it.titulo = titulo
			it.destinos = convertToArray(destinosDelPerfil)
		]
	}
	
	def convertToArray(List<Destino> destinos) {

		var result = new ArrayList<Destino>
		
		for(destino : destinos){
			result.add(destino)
		}
		result
	}
}
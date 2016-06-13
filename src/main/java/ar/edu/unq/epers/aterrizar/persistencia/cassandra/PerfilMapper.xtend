package ar.edu.unq.epers.aterrizar.persistencia.cassandra

import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Destino
import com.datastax.driver.mapping.annotations.FrozenValue
import com.datastax.driver.mapping.annotations.PartitionKey
import com.datastax.driver.mapping.annotations.Table
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import com.datastax.driver.mapping.annotations.Column

@EqualsHashCode
@Table(keyspace = "simplex", name = "perfiles")
@Accessors
class PerfilMapper {
	
	@PartitionKey
	String nombreUsuario
	@Column(name = "titulo")
	String titulo
	@FrozenValue
	List<Destino> destinosDelPerfil

	new(){
		
	}
	
	new(String nombreUsuario, String titulo, List<Destino> destinos){

		this.nombreUsuario = nombreUsuario
		this.titulo = titulo
		this.destinosDelPerfil = destinos
	}
}
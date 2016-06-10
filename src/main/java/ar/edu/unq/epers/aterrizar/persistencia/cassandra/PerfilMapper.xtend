package ar.edu.unq.epers.aterrizar.persistencia.cassandra

import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Destino
import com.datastax.driver.mapping.annotations.FrozenValue
import com.datastax.driver.mapping.annotations.PartitionKey
import com.datastax.driver.mapping.annotations.Table
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode

@EqualsHashCode
@Table(keyspace = "perfilesAterrizar", name = "PerfilMapper")
@Accessors
class PerfilMapper {
	
	@PartitionKey()
	String nombreUsuario
	@PartitionKey(1)
	String titulo
	@FrozenValue
	List<Destino> destinosDelPerfil
	
	new(String nombreUsuario, String titulo, List<Destino> destinos){

		this.nombreUsuario = nombreUsuario
		this.titulo = titulo
		this.destinosDelPerfil = destinos
	}
}
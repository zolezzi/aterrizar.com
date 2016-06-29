package ar.edu.unq.epers.aterrizar.persistencia.cassandra

import com.datastax.driver.core.Cluster
import com.datastax.driver.core.Metadata
import com.datastax.driver.core.Host
import com.datastax.driver.core.Session
import com.datastax.driver.mapping.Mapper
import org.eclipse.xtend.lib.annotations.Accessors
import com.datastax.driver.mapping.MappingManager
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Destino
import java.util.List
import java.util.ArrayList

@Accessors
class CassandraManager {

	Cluster cluster
	Session session
	Mapper<PerfilMapper> mapper
	
	new(){
		createSession
		createSchema
	}

	def connect(String node) {
		cluster = Cluster.builder().addContactPoint(node).build()
		var Metadata metadata = cluster.getMetadata()
			System.out.printf("Connected to cluster: %s\n", metadata.getClusterName())
		for (Host host : metadata.getAllHosts()) {
			System.out.printf("Datacenter: %s; Host: %s; Rack: %s\n",
								host.getDatacenter(), host.getAddress(), host.getRack())
		}
	}
	def close() {
		cluster.close()
	}
	public static def main(String[] args) {
		var client = new CassandraManager()
		client.connect("127.0.0.1")
		client.session.execute("DROP KEYSPACE simplex;")
		client.close()
		System.exit(0)
	}

	def createSession(){
		
		val cluster = Cluster.builder().addContactPoint("127.0.0.1").build()
		session = cluster.connect()
	}

	def createSchema(){
		session.execute("CREATE KEYSPACE IF NOT EXISTS simplex " +
						"WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 3 };")
		
		session.execute("CREATE TYPE IF NOT EXISTS simplex.Destino (" +
						"id text," +
						"TituloDestino text);")

		session.execute("CREATE TABLE IF NOT EXISTS simplex.perfiles (" +
						"nombreUsuario text," +
						"visibilidad text," +
						"titulo text," +
						"destinosDelPerfil list< frozen<Destino> >," +
						"PRIMARY KEY (nombreUsuario, visibilidad));")

	mapper = new MappingManager(session).mapper(PerfilMapper)
	}
	
	def mostrarParaAmigos(String nombreUsuario){
		
		mapper.get(nombreUsuario,"amigo")
	}
	
	def mostrarParaPublico(String nombreUsuario){
		
		mapper.get(nombreUsuario,"publico")
	}
	
	def mostrarParaPrivado(String nombreUsuario){
		
		mapper.get(nombreUsuario,"privado")
	}

	def convertToArray(List<Destino> destinos) {
		//CHEQUEAR A VER SI SE PUEDE CORREGIR ESTA CONVERSION
		var result = new ArrayList<Destino>
		
		for(destino : destinos){
			result.add(destino)
		}
		result
	}
}